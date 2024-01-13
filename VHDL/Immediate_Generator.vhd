library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Immediate_Generator is
    port (
		i_immediate			: in std_logic_vector (24 downto 0);
		i_instructionType	: in std_logic_vector (2 downto 0);

		o_output	: out std_logic_vector (31 downto 0)
	);
end Immediate_Generator;

architecture Behavioral of Immediate_Generator is

begin

	process (i_instructionType, i_immediate)
	begin
		if i_instructionType = 0 then
			if(i_immediate(24) = '0') then
				o_output <= x"00000" & i_immediate(24 downto 13);
			else
				o_output <= x"FFFFF" & i_immediate(24 downto 13);
			end if;
		elsif i_instructionType = 1 then
			if(i_immediate(24) = '0') then
				o_output <= x"00000" & i_immediate(24 downto 18) & i_immediate(4 downto 0);
			else
				o_output <= x"FFFFF" & i_immediate(24 downto 18) & i_immediate(4 downto 0);
			end if;
		elsif i_instructionType = 2 then
			if(i_immediate(24) = '0') then
				o_output <= b"0000000000000000000" & i_immediate(24) & i_immediate(0) & i_immediate(23 downto 18) & i_immediate(4 downto 1) & b"0";
			else
				o_output <= b"1111111111111111111" & i_immediate(24) & i_immediate(0) & i_immediate(23 downto 18) & i_immediate(4 downto 1) & b"0";
			end if;
		elsif i_instructionType = 3 then
			if(i_immediate(24) = '0') then
				o_output <= x"000" & i_immediate(24 downto 5);
			else
				o_output <= x"000" & i_immediate(24 downto 5);
			end if;
		else
			if(i_immediate(24) = '0') then
				o_output <= x"FFF" & i_immediate(24) & i_immediate(12 downto 5) & i_immediate(13) & i_immediate(23 downto 14);
			else
				o_output <= x"FFF" & i_immediate(24) & i_immediate(12 downto 5) & i_immediate(13) & i_immediate(23 downto 14);
			end if;
		end if;
	end process;
end Behavioral;
