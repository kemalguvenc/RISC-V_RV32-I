library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Memory is
	port (
		i_clk				: in std_logic;
		i_dataAdress		: in std_logic_vector(31 downto 0);

		o_readData			: out std_logic_vector(31 downto 0)
	);
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

type MemoryArray is array (0 to 100*(2**10 - 1)) of std_logic_vector (31 downto 0);
signal memory	: MemoryArray	:= (others => (others => '0') ); 

begin

	process (i_clk)
	begin
		if(rising_edge(i_clk)) then
			o_readData  <= memory(conv_integer(i_dataAdress));
		end if;
	end process;

end Behavioral;
