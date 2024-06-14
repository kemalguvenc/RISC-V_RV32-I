library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_BranchPredictioner is
end TestBench_BranchPredictioner;

architecture Behavioral of TestBench_BranchPredictioner is

component BranchPredictioner is
	port(
		i_clk					: in std_logic;
		i_instruction			: in std_logic_vector(31 downto 0);
		i_programCounter		: in std_logic_vector(31 downto 0);
		i_branchResult			: in std_logic;

		o_newProgramCounter		: out std_logic_vector (31 downto 0);
		o_programCounterSelector: out std_logic;
		o_kill_Instructions		: out std_logic;
		o_stopPipeline			: out std_logic
	);
end component;

signal clk						: std_logic := '0';
signal instruction				: std_logic_vector(31 downto 0) := x"00000000";
signal programCounter			: std_logic_vector(31 downto 0);
signal branchResult				: std_logic;

signal newProgramCounter		: std_logic_vector (31 downto 0) := x"00000000";
signal programCounterSelector	: std_logic;
signal kill_Instructions		: std_logic;
signal stopPipeline				: std_logic;

begin

	BP : BranchPredictioner
	port map(
		i_clk					=> clk,
		i_instruction			=> instruction,
		i_programCounter		=> programCounter,
		i_branchResult			=> branchResult,
		o_newProgramCounter		=> newProgramCounter,
		o_programCounterSelector=> programCounterSelector,
		o_kill_Instructions		=> kill_Instructions,
		o_stopPipeline			=> stopPipeline
	);

	test : process
	begin
		wait for 20 ns;
		
		instruction	<= x"00" & x"c0" & b"00001000" & b"01101111";     -- JAL
		programCounter	<= x"00000014";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= x"00" & x"a0" & b"00001010" & b"01100111";     -- JALR
		programCounter	<= x"00000014";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= x"00" & x"a0" & b"00001010" & b"01100111";     -- JALR
		programCounter	<= x"00000014";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= x"00" & x"a0" & b"00001010" & b"01100111";     -- JALR
		programCounter	<= x"00000014";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= b"00000000" & b"00010000" & b"00000000" & b"10010011";     -- ADDI
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= x"00" & x"00" & b"00000100" & b"01100011";     -- BEQ
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= b"00000000" & b"00010000" & b"00000000" & b"10010011";     -- ADDI
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= b"00000000" & b"00010000" & b"00000000" & b"10010011";     -- ADDI
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;

		instruction	<= b"00000000" & b"00010000" & b"00100001" & b"10000011";     -- LW
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;

		instruction	<= b"00000000" & b"00010001" & b"10100001" & b"10000011";     -- LW
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= b"00000000" & b"00010001" & b"10000000" & b"10010011";     -- ADDI
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;
		
		instruction	<= b"00000000" & b"00010001" & b"10000000" & b"10010011";     -- ADDI
		programCounter	<= x"00000017";
		clk				<= '1';
		wait for 20 ns;
		clk				<= '0';
		wait for 20 ns;

		assert false
			report "Simulation Done"
			severity failure;
	end process;

end Behavioral;
