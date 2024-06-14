library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Program_Counter is
	port (
		i_clk				: in std_logic						:= '0';
		i_instructionAdress	: in std_logic_vector(31 downto 0)	:= x"00000000";
		i_reset				: in std_logic						:= '0';

		o_instructionAdress	: out std_logic_vector(31 downto 0)	:= x"00000000"
	);
end Program_Counter;

architecture Behavioral of Program_Counter is

signal s_instructionAdress	: std_logic_vector(31 downto 0)	:= (others => '0');

begin	
	process (all)
	begin
		if i_reset = '1' then
			s_instructionAdress	<= (others => '0');
		else
			s_instructionAdress	<= i_instructionAdress;
		end if;
		if(rising_edge(i_clk)) then
			o_instructionAdress	<= s_instructionAdress;
		end if;
	end process;

end Behavioral;
