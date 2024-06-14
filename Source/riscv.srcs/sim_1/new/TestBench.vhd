library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench is
end TestBench;

architecture Behavioral of TestBench is

component Transfer_Layer_1to2 is
	port (
		i_clk				: in std_logic;
		i_stop				: in std_logic;

		i_programCounter	: in std_logic_vector(31 downto 0);
		i_instruction		: in std_logic_vector(31 downto 0);
		i_killInstruction	: in std_logic;

		o_programCounter	: out std_logic_vector(31 downto 0);
		o_instruction		: out std_logic_vector(31 downto 0);
		o_killInstruction	: out std_logic
	);
end component;

signal i_clk				: std_logic						:= '0';
signal i_stop				: std_logic						:= '0';

signal i_programCounter_1	: std_logic_vector(31 downto 0)	:= x"00000000";
signal i_instruction_1		: std_logic_vector(31 downto 0)	:= x"00000000";
signal i_killInstruction_1	: std_logic						:= '0';

signal o_programCounter_1	: std_logic_vector(31 downto 0)	:= x"00000000";
signal o_instruction_1		: std_logic_vector(31 downto 0)	:= x"00000000";
signal o_killInstruction_1	: std_logic						:= '0';

signal o_programCounter_2	: std_logic_vector(31 downto 0)	:= x"00000000";
signal o_instruction_2		: std_logic_vector(31 downto 0)	:= x"00000000";
signal o_killInstruction_2	: std_logic						:= '0';

begin

Module1 : Transfer_Layer_1to2
port map(
			i_clk				=> i_clk,
			i_stop				=> i_stop,
			i_programCounter	=> i_programCounter_1,
			i_instruction		=> i_instruction_1,
			i_killInstruction	=> i_killInstruction_1,
			o_programCounter	=> o_programCounter_1,
			o_instruction		=> o_instruction_1,
			o_killInstruction	=> o_killInstruction_1
);

Module2 : Transfer_Layer_1to2
port map(
			i_clk				=> i_clk,
			i_stop				=> i_stop,
			i_programCounter	=> o_programCounter_1,
			i_instruction		=> o_instruction_1,
			i_killInstruction	=> o_killInstruction_1,
			o_programCounter	=> o_programCounter_2,
			o_instruction		=> o_instruction_2,
			o_killInstruction	=> o_killInstruction_2
);

	process
	begin
		i_stop	<= '0';

		wait for 20ns;

		i_programCounter_1	<= x"10101010";
		i_instruction_1		<= x"01010101";
		i_killInstruction_1	<= '0';
		i_clk				<= '1';
		wait for 20ns;
		i_clk				<= '0';
		wait for 20ns;

		i_programCounter_1	<= x"13131313";
		i_instruction_1		<= x"54545454";
		i_killInstruction_1	<= '1';
		i_clk				<= '1';
		wait for 20ns;
		i_clk				<= '0';
		wait for 20ns;

		i_programCounter_1	<= x"63636363";
		i_instruction_1		<= x"25252525";
		i_killInstruction_1	<= '0';
		i_clk				<= '1';
		wait for 20ns;
		i_clk				<= '0';
		wait for 20ns;

		i_clk				<= '1';
		wait for 20ns;
		i_clk				<= '0';
		wait for 20ns;

		assert false
			report "Sim Done"
			severity failure;
		
	end process;
end Behavioral;
