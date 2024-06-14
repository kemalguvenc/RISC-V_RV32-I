library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Immediate_Expander is
	port (
		i_immediate			: in std_logic_vector(24 downto 0)	:= (others => '0');
		i_instructionType	: in std_logic_vector(1 downto 0)	:= (others => '0');

		o_output			: out std_logic_vector(31 downto 0)	:= (others => '0') 
	);
end Immediate_Expander;

architecture Behavioral of Immediate_Expander is

begin

	process (i_instructionType, i_immediate)
	begin
		if i_instructionType = b"00" then															-- I Type Instruction
			if(i_immediate(24) = '0') then
				o_output <= x"00000" & i_immediate(24 downto 13);
			else
				o_output <= x"FFFFF" & i_immediate(24 downto 13);
			end if;
		elsif i_instructionType = b"01" then														-- S Type Instruction
			if(i_immediate(24) = '0') then
				o_output <= x"00000" & i_immediate(24 downto 18) & i_immediate(4 downto 0);
			else
				o_output <= x"FFFFF" & i_immediate(24 downto 18) & i_immediate(4 downto 0);
			end if;
		else																						-- U Type Instruction
			o_output <= i_immediate(24 downto 5) & x"000";

		end if;
	end process;
end Behavioral;
