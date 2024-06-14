library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_InstructionMemory is
end TestBench_InstructionMemory;

architecture Behavioral of TestBench_InstructionMemory is

component Instruction_Memory is
	port(
		i_dataAdress	: in std_logic_vector(31 downto 0);

		o_readData		: out std_logic_vector(31 downto 0)
	);
end component;

signal adress	: std_logic_vector(31 downto 0);
signal data		: std_logic_vector(31 downto 0);

begin

	IM : Instruction_Memory
	port map(
		i_dataAdress	=> adress,
		o_readData		=> data
	);

	test : process
	begin
		adress  <= x"00000000";
		wait for 10 ns;
		
		adress  <= x"00000002";
		wait for 10 ns;
		
		adress  <= x"00000004";
		wait for 10 ns;

		assert false
			report "Simulator Done"
			severity failure;
		
	end process;

end Behavioral;
