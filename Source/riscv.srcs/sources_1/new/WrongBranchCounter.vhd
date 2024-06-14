library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WrongBranchCounter is
    port (
		i_clk				: in std_logic						:= '0';
		i_reset				: in std_logic						:= '0';
		i_wrong				: in std_logic						:= '0';

		o_7SegmentDisplay	: out std_logic_vector(6 downto 0)	:= b"1000000"
    );
end WrongBranchCounter;

architecture Behavioral of WrongBranchCounter is

signal counter	: integer range 0 to 99	:= 0;
signal value	: integer range 0 to 9	:= 0;

begin
    value	<= counter mod 10;

	process (i_clk)
	begin
		if rising_edge(i_clk) then
			if i_reset = '1' then
				counter	<= 0;
			end if;
			if i_wrong = '1' then
				counter	<= counter + 1;

				if value /= 1 and value /= 4 then
					o_7SegmentDisplay(0)	<= '0';
				else
					o_7SegmentDisplay(0)	<= '1';
				end if;
				if value /= 5 and value /= 6 then
					o_7SegmentDisplay(1)	<= '0';
				else
					o_7SegmentDisplay(1)	<= '1';
				end if;
				if value /= 2  then
					o_7SegmentDisplay(2)	<= '0';
				else
					o_7SegmentDisplay(2)	<= '1';
				end if;
				if value /= 1 and value /= 4 and value /= 7 then
					o_7SegmentDisplay(3)	<= '0';
				else
					o_7SegmentDisplay(3)	<= '1';
				end if;
				if value = 0 or value = 2 or value = 6 or value = 8 then
					o_7SegmentDisplay(4)	<= '0';
				else
					o_7SegmentDisplay(4)	<= '1';
				end if;
				if value /= 1 and value /= 2 and value /= 3 and value /= 7 then
					o_7SegmentDisplay(5)	<= '0';
				else
					o_7SegmentDisplay(5)	<= '1';
				end if;
				if value /= 0 and value /= 1 and value /= 7 then
					o_7SegmentDisplay(6)	<= '0';
				else
					o_7SegmentDisplay(6)	<= '1';
				end if;
			end if;
		end if;
	end process;

end Behavioral;
