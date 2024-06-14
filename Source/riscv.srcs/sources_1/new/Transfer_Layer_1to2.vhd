library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Transfer_Layer_1to2 is
	port (
		i_clk				: in std_logic						:= '0';
		i_stop				: in std_logic						:= '0';

 		i_programCounter	: in std_logic_vector(31 downto 0)	:= x"00000000";
 		i_instruction		: in std_logic_vector(31 downto 0)	:= x"00000000";
 		i_killInstruction	: in std_logic						:= '0';

 		o_programCounter	: out std_logic_vector(31 downto 0)	:= x"00000000";
 		o_instruction		: out std_logic_vector(31 downto 0)	:= x"00000000";
 		o_killInstruction	: out std_logic						:= '0'
	);
end Transfer_Layer_1to2;

architecture Behavioral of Transfer_Layer_1to2 is

begin

	process (i_clk, i_stop)
	begin
		if rising_edge(i_clk) and i_stop = '0' then
			o_programCounter	<= i_programCounter;
			o_instruction		<= i_instruction;
			o_killInstruction	<= i_killInstruction;
		end if;
	end process;

end Behavioral;
