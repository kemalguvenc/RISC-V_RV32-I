library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Program_Counter is
	port (
		i_clk				: in std_logic;
		i_instructionAdress	: in std_logic_vector(31 downto 0);

		o_instructionAdress	: out std_logic_vector(31 downto 0)
	);
end Program_Counter;

architecture Behavioral of Program_Counter is

begin

	process (i_clk)
	begin
		o_instructionAdress	<= i_instructionAdress;
	end process;

end Behavioral;
