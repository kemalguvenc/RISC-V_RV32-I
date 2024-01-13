library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MemoryDataGenerator is
    port (
		i_input			: in std_logic_vector (31 downto 0);
		i_outputWidth	: in std_logic_vector (2 downto 0);

		o_output	    : out std_logic_vector (31 downto 0)
	);
end MemoryDataGenerator;

architecture Behavioral of MemoryDataGenerator is

begin

    process (i_outputWidth)
    begin
        if i_outputWidth = 0 then
            o_output <= x"000000" & i_input(7 downto 0);
        elsif i_outputWidth = 1 then
            o_output <= x"FFFFFF" & i_input(7 downto 0);
        elsif i_outputWidth = 2 then
            o_output <= x"0000" & i_input(15 downto 0);
        elsif i_outputWidth = 3 then
            o_output <= x"FFFF" & i_input(15 downto 0);
        else 
            o_output <= i_input;
        end if;
    end process;
    
end Behavioral;
