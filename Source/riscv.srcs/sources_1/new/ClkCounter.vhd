library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ClkCounter is
	port (
		i_clk				: in std_logic						:= '0';
		i_reset				: in std_logic						:= '0';

		o_7SegmentDisplay1  : out std_logic_vector(6 downto 0)	:= b"1000000";
		o_7SegmentDisplay2  : out std_logic_vector(6 downto 0)	:= b"1000000"
	);
end ClkCounter;

architecture Behaviandal of ClkCounter is

signal counter	: integer range 0 to 99	:= 0;
signal value1	: integer range 0 to 9	:= 0;
signal value2	: integer range 0 to 9	:= 0;

begin
	value1	<= counter mod 10;
	value2	<= counter / 10;

	process (i_clk)
	begin
		if rising_edge(i_clk) then
			if i_reset = '1' then
				counter	<= 0;
			else
				counter	<= counter + 1;
			end if;

			if value1 /= 1 and value1 /= 4 then
				o_7SegmentDisplay1(0)	<= '0';
			else
				o_7SegmentDisplay1(0)	<= '1';
			end if;
			if value1 /= 5 and value1 /= 6 then
				o_7SegmentDisplay1(1)	<= '0';
			else
				o_7SegmentDisplay1(1)	<= '1';
			end if;
			if value1 /= 2  then
				o_7SegmentDisplay1(2)	<= '0';
			else
				o_7SegmentDisplay1(2)	<= '1';
			end if;
			if value1 /= 1 and value1 /= 4 and value1 /= 7 then
				o_7SegmentDisplay1(3)	<= '0';
			else
				o_7SegmentDisplay1(3)	<= '1';
			end if;
			if value1 = 0 or value1 = 2 or value1 = 6 or value1 = 8 then
				o_7SegmentDisplay1(4)	<= '0';
			else
				o_7SegmentDisplay1(4)	<= '1';
			end if;
			if value1 /= 1 and value1 /= 2 and value1 /= 3 and value1 /= 7 then
				o_7SegmentDisplay1(5)	<= '0';
			else
				o_7SegmentDisplay1(5)	<= '1';
			end if;
			if value1 /= 0 and value1 /= 1 and value1 /= 7 then
				o_7SegmentDisplay1(6)	<= '0';
			else
				o_7SegmentDisplay1(6)	<= '1';
			end if;



			if value2 /= 1 and value2 /= 4 then
				o_7SegmentDisplay2(0)	<= '0';
			else
				o_7SegmentDisplay2(0)	<= '1';
			end if;
			if value2 /= 5 and value2 /= 6 then
				o_7SegmentDisplay2(1)	<= '0';
			else
				o_7SegmentDisplay2(1)	<= '1';
			end if;
			if value2 /= 2  then
				o_7SegmentDisplay2(2)	<= '0';
			else
				o_7SegmentDisplay2(2)	<= '1';
			end if;
			if value2 /= 1 and value2 /= 4 and value2 /= 7 then
				o_7SegmentDisplay2(3)	<= '0';
			else
				o_7SegmentDisplay2(3)	<= '1';
			end if;
			if value2 = 0 or value2 = 2 or value2 = 6 or value2 = 8 then
				o_7SegmentDisplay2(4)	<= '0';
			else
				o_7SegmentDisplay2(4)	<= '1';
			end if;
			if value2 /= 1 and value2 /= 2 and value2 /= 3 and value2 /= 7 then
				o_7SegmentDisplay2(5)	<= '0';
			else
				o_7SegmentDisplay2(5)	<= '1';
			end if;
			if value2 /= 0 and value2 /= 1 and value2 /= 7 then
				o_7SegmentDisplay2(6)	<= '0';
			else
				o_7SegmentDisplay2(6)	<= '1';
			end if;
		end if;
	end process;

end Behaviandal;
