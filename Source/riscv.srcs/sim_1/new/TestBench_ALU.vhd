library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_ALU is
end TestBench_ALU;

architecture Behavioral of TestBench_ALU is

component ALU is
	port(
		i_operandA	: in std_logic_vector (31 downto 0);
		i_operandB	: in std_logic_vector (31 downto 0);
		i_operation : in std_logic_vector (4 downto 0);

		o_output	: out std_logic_vector (31 downto 0);
		o_branch	: out std_logic
	);
end component;

signal operandA	: std_logic_vector (31 downto 0)	:= x"00000000";
signal operandB	: std_logic_vector (31 downto 0)	:= x"00000000";
signal operation: std_logic_vector (4 downto 0)		:= b"00000";
signal output	: std_logic_vector (31 downto 0)	:= x"00000000";
signal branch	: std_logic							:= '0';

begin

	Operator : ALU
	port map(
		i_operandA	=> operandA,
		i_operandB	=> operandB,
		i_operation => operation,

		o_output	=> output,
		o_branch	=> branch	
	);

	test : process
	begin
        wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00000";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00001";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00010";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00011";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00100";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00101";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00110";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"00111";
		wait for 20 ns;

		operandA	<= x"80101010";
		operandB	<= x"01010101";
		operation	<= b"01000";
		wait for 20 ns;

		operandA	<= x"80101010";
		operandB	<= x"01010101";
		operation	<= b"01001";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"01010";
		wait for 20 ns;

		operandA	<= x"80101010";
		operandB	<= x"01010101";
		operation	<= b"01011";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"01100";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"01101";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"01110";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"01111";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"10000";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"10001";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"10010";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"10011";
		wait for 20 ns;

		operandA	<= x"10101010";
		operandB	<= x"01010101";
		operation	<= b"10100";
		wait for 20 ns;

		assert false
			report "Simulation Done"
			severity failure;
	end process;

end Behavioral;
