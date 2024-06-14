library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_ProgramCounter is
end TestBench_ProgramCounter;

architecture Behavioral of TestBench_ProgramCounter is

component Program_Counter is
	port (
		i_clk				: in std_logic;
		i_instructionAdress	: in std_logic_vector(31 downto 0);

		o_instructionAdress	: out std_logic_vector(31 downto 0)
	);
end component;

signal clk		: std_logic						:= '0';
signal input	: std_logic_vector(31 downto 0)	:= x"00000000";
signal output	: std_logic_vector(31 downto 0);

begin

	PC : Program_Counter
	port map (
		i_clk				=> clk,
		i_instructionAdress => input,
		o_instructionAdress => output
	);

	test : process
	begin
		wait for 20 ns;

		input	<= x"11111111";
		clk					<= '1';
		wait for 20 ns;
		clk					<= '0';
		wait for 20 ns;

		input	<= x"99999999";
		clk					<= '1';
		wait for 20 ns;
		clk					<= '0';
		wait for 20 ns;

		input	<= x"12345678";
		clk					<= '1';
		wait for 20 ns;
		clk					<= '0';
		wait for 20 ns;
 
		assert false
			report "Simulator Done"
			severity failure;

	end process;

end Behavioral;
