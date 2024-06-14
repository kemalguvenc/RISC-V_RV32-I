library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity BranchPredictioner is
	port (
		i_clk					: in std_logic							:= '0';
		i_instruction			: in std_logic_vector(31 downto 0)		:= (others => '0');
		i_programCounter		: in std_logic_vector(31 downto 0)		:= (others => '0');
		i_branchResult			: in std_logic							:= '0';

		o_newProgramCounter		: out std_logic_vector (31 downto 0)	:= (others => '0');
		o_programCounterSelector: out std_logic							:= '0';
		o_kill_Instructions		: out std_logic							:= '0';
		o_stopPipeline			: out std_logic							:= '0'
	);
end BranchPredictioner;

architecture Behavioral of BranchPredictioner is

type programCounterArray is array (2 downto 0) of std_logic_vector(31 downto 0);

signal saturatingCounter		: std_logic_vector(1 downto 0)		:= (others => '0');

signal branchCounter			: std_logic_vector(2 downto 0)		:= (others => '0');
signal oldPredictions			: std_logic_vector(2 downto 0)		:= (others => '0');
signal otherProgramCounters		: programCounterArray				:= (others => x"00000000");

signal backupRD					: std_logic_vector(4 downto 0)		:= (others => '0');
signal backupCounter			: std_logic_vector(1 downto 0)		:= (others => '0');
signal temp						: std_logic							:= '0';

signal JALRCounter				: std_logic_vector(2 downto 0)		:= (others => '0');

signal expandedImmediateOfJAL	: std_logic_vector(31 downto 0)		:= (others => '0');
signal expandedImmediateOfJALR	: std_logic_vector(31 downto 0)		:= (others => '0');
signal expandedImmediateOfBranch: std_logic_vector(31 downto 0)		:= (others => '0');

begin
	process(all)
	begin
		o_kill_Instructions		<= '0';
		o_stopPipeline			<= backupCounter(1) and temp;
		o_programCounterSelector<= JALRCounter(2);
		o_newProgramCounter		<= i_programCounter + 4;
		JALRCounter(0)			<= '0';
		branchCounter(0)		<= '0';
		oldPredictions(0)		<= '0';
		backupCounter(0)		<= '0';

		if
		(i_instruction(6 downto 0) /= b"0110111" and i_instruction(6 downto 0) /= b"0010111" and i_instruction(6 downto 0) /= b"1101111" and i_instruction(6 downto 0) /= b"1100111" and backupRD /= b"00000") and 
		(
			(
			(i_instruction(6 downto 0) = b"1100111" or i_instruction(6 downto 0) = b"0000011" or i_instruction(6 downto 0) = b"0010011") and 
			i_instruction(19 downto 15) = backupRD
			) or 
			(
			(i_instruction(6 downto 0) /= b"1100111" or i_instruction(6 downto 0) /= b"0000011" or i_instruction(6 downto 0) /= b"0010011") and 
			(i_instruction(19 downto 15) = backupRD or i_instruction(24 downto 20) = backupRD)
			)
		) then
			temp	<= '1';
		else
			temp	<= '0';
		end if;

		expandedImmediateOfJAL(0)				<= '0';
		expandedImmediateOfJAL(10 downto 1)		<= i_instruction(30 downto 21);
		expandedImmediateOfJAL(11)				<= i_instruction(20);
		expandedImmediateOfJAL(19 downto 12)	<= i_instruction(19 downto 12);
		expandedImmediateOfJAL(20)				<= i_instruction(31);
		for i in 31 downto 21 loop
			expandedImmediateOfJAL(i)			<= i_instruction(31);
		end loop;
	
		expandedImmediateOfJALR(11 downto 0)	<= i_instruction(31 downto 20);
		for i in 31 downto 12 loop
			expandedImmediateOfJALR(i)			<= i_instruction(31);
		end loop;
	
		expandedImmediateOfBranch(0)			<= '0';
		expandedImmediateOfBranch(4 downto 1)	<= i_instruction(11 downto 8);
		expandedImmediateOfBranch(10 downto 5)	<= i_instruction(30 downto 25);
		expandedImmediateOfBranch(11)			<= i_instruction(7);
		expandedImmediateOfBranch(12)			<= i_instruction(31);
		for i in 31 downto 13 loop
			expandedImmediateOfBranch(i)			<= i_instruction(31);
		end loop;

		if branchCounter(2) = '1' and oldPredictions(2) /= i_branchResult then					-- Wrong Branch
			o_kill_Instructions		<= '1';
			o_newProgramCounter		<= otherProgramCounters(2);
		elsif i_instruction(6 downto 0) = b"1101111" then										-- JAL
			o_newProgramCounter		<= i_programCounter + expandedImmediateOfJAL;
		elsif temp = '1' then																	-- For Load Instruction
			o_newProgramCounter		<= i_programCounter;
		elsif i_instruction(6 downto 0) = b"1100111" then										-- JALR
			if (JALRCounter(1) or JALRCounter(2)) = '0' then
				JALRCounter(0)			<= '1';
			end if;
			o_newProgramCounter		<= i_programCounter;
		elsif i_instruction(6 downto 0) = b"0000011" then										-- Load Instruction
			backupCounter(0)		<= '1';
		elsif i_instruction(6 downto 0) = b"1100011" then
			branchCounter(0)		<= '1';
			if saturatingCounter = b"00" or saturatingCounter = b"01"  then
				oldPredictions(0)		<= '0';
				otherProgramCounters(0)	<= i_programCounter + expandedImmediateOfBranch;
				o_newProgramCounter		<= i_programCounter + 4;
			else
				oldPredictions(0)		<= '1';
				otherProgramCounters(0)	<= i_programCounter + 4;
				o_newProgramCounter		<= i_programCounter + expandedImmediateOfBranch;
			end if;
		end if;
	end process;

	Branch : process(all)
	begin
		if rising_edge(i_clk) then
			branchCounter(1)	<= branchCounter(0);
			branchCounter(2)	<= branchCounter(1);

			oldPredictions(1)	<= oldPredictions(0);
			oldPredictions(2)	<= oldPredictions(1);

			otherProgramCounters(1)	<= otherProgramCounters(0);
			otherProgramCounters(2)	<= otherProgramCounters(1);

			if branchCounter(2) = '1' and i_branchResult = '1' then
				if saturatingCounter /= b"11" then
					saturatingCounter <= saturatingCounter + 1;
				end if;
			elsif branchCounter(2) = '1' and i_branchResult = '0' then
				if saturatingCounter /= b"00" then
					saturatingCounter <= saturatingCounter - 1;
				end if;
			end if;
		end if;
	end process;

	JALR : process(all)
	begin
		if rising_edge(i_clk) then
			JALRCounter(1)	<= JALRCounter(0);
			JALRCounter(2)	<= JALRCounter(1);
		end if;
	end process;

	Backup : process(all)
	begin
		if rising_edge(i_clk) then
			backupCounter(1)	<= backupCounter(0);
			if i_instruction(6 downto 0) = b"0000011" and backupCounter = b"00" then
				backupRD			<= i_instruction(11 downto 7);
			end if;
		end if;
	end process;

end Behavioral;
