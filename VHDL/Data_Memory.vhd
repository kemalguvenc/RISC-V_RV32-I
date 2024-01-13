library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Memory is
	port (
		i_clk				: in std_logic;
		i_controlReadWrite	: in std_logic;							-- 0/1 => Read/Write
		i_dataAdress		: in std_logic_vector(31 downto 0);
		i_writeData			: in std_logic_vector(31 downto 0);
		i_dataWidth			: in std_logic_vector(1 downto 0);

		o_readData			: out std_logic_vector(31 downto 0)
	);
end Data_Memory;

architecture Behavioral of Data_Memory is

type MemoryArray is array (0 to 100*(2**10 - 1)) of std_logic_vector (7 downto 0);
signal memory	: MemoryArray	:= (others => (others => '0') ); 

begin

	process (i_clk)
	begin
		if(rising_edge(i_clk)) then
			if(i_controlReadWrite = '0') then
				o_readData	<= memory(conv_integer(i_dataAdress) + 3) & memory(conv_integer(i_dataAdress) + 2) & memory(conv_integer(i_dataAdress) + 1) & memory(conv_integer(i_dataAdress));	-- 32-Bit Reading
			else
				if i_dataWidth = 0 then
					memory(conv_integer(i_dataAdress))	<= i_writeData(7 downto 0);	-- 8-Bit Writing
				elsif i_dataWidth = 1 then
					memory(conv_integer(i_dataAdress))	<= i_writeData(7 downto 0);	-- 16-Bit Writing
					memory(conv_integer(i_dataAdress))	<= i_writeData(15 downto 8);
				else
					memory(conv_integer(i_dataAdress))	<= i_writeData(7 downto 0);	-- 32-Bit Writing
					memory(conv_integer(i_dataAdress))	<= i_writeData(15 downto 8);
					memory(conv_integer(i_dataAdress))	<= i_writeData(23 downto 16);
					memory(conv_integer(i_dataAdress))	<= i_writeData(31 downto 23);
				end if;
			end if;
		end if;
	end process;

end Behavioral;
