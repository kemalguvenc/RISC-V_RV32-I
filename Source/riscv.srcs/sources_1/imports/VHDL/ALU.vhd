library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ALU is
	port (
		i_operandA	: in std_logic_vector (31 downto 0)		:= (others => '0');
		i_operandB	: in std_logic_vector (31 downto 0)		:= (others => '0');
		i_operation : in std_logic_vector (4 downto 0)		:= (others => '0');

		o_output	: out std_logic_vector (31 downto 0)	:= (others => '0');
		o_branch	: out std_logic							:= '0'
	);
end ALU;

architecture Behavioral of ALU is

signal s_shamt		: std_logic_vector(4 downto 0)	:= b"00000";
signal temp			: std_logic_vector(31 downto 0)	:= x"00000000";

begin
	s_shamt	<= i_operandB(4 downto 0);

	process (all)
		variable count      : integer := 0;
	begin
		if i_operation = 0 then														-- Add Operation
			o_output	<= i_operandA + i_operandB;

		elsif i_operation = 1 then													-- Substract Operation
			o_output	<= i_operandA - i_operandB;

		elsif i_operation = 2 then													-- AND Operation
			o_output	<= i_operandA AND i_operandB;

		elsif i_operation = 3 then													-- OR Operation
			o_output	<= i_operandA OR i_operandB;

		elsif i_operation = 4 then													-- XOR Operation
			o_output	<= i_operandA XOR i_operandB;

		elsif i_operation = 5 then													-- Shift Left (Logical) Operation
			--o_output	<= i_operandA sll conv_integer(s_shamt);
			if(conv_integer(s_shamt) /= 0) then
			o_output(31 downto conv_integer(s_shamt))	<= i_operandA((31 - conv_integer(s_shamt)) downto 0);
			o_output((conv_integer(s_shamt) - 1) downto 0) <= (others=>'0');
			end if;

		elsif i_operation = 6 then													-- Shift Right (Logical) Operation
			--o_output	<= i_operandA srl conv_integer(s_shamt);
			if(conv_integer(s_shamt) /= 0) then
			o_output((31 - conv_integer(s_shamt)) downto 0)	<= i_operandA(31 downto conv_integer(s_shamt));
			o_output(31 downto (32 - conv_integer(s_shamt))) <= (others=>'0');
			end if;

		elsif i_operation = 7 then													-- Shift Right (Arithmetic) Operation
			--o_output	<= to_stdlogicvector(to_bitvector(i_operandA) sra conv_integer(s_shamt));
			if(conv_integer(s_shamt) /= 0) then
			o_output((31 - conv_integer(s_shamt)) downto 0)	<= i_operandA(31 downto conv_integer(s_shamt));
			o_output(31 downto (32 - conv_integer(s_shamt))) <= (others=>i_operandA(31));
			end if;

		elsif i_operation = 8 then													-- Less Than (Branch - Signed) Operation
			if(i_operandA(31) = '1' and i_operandB(31) = '0') then
				o_output	<= x"00000001";
				o_branch	<= '1';
			elsif(i_operandA(31) = '0' and i_operandB(31) = '1') then
				o_output	<= x"00000000";
				o_branch	<= '0';
			elsif(i_operandA < i_operandB) then
				o_output	<= x"00000001";
				o_branch	<= '1';
			else 
				o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 9 then													-- Less Than (Branch - Unsigned) Operation
			if(i_operandA < i_operandB) then
				o_output	<= x"00000001";
				o_branch	<= '1';
			else 
				o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 10 then													-- Equal or Greater Than (Branch - Signed) Operation
			if(i_operandA(31) = '1' and i_operandB(31) = '0') then
			--	o_output	<= x"00000000";
				o_branch	<= '0';
			elsif(i_operandA(31) = '0' and i_operandB(31) = '1') then
			--	o_output	<= x"00000001";
				o_branch	<= '1';
			elsif(i_operandA >= i_operandB) then
			--	o_output	<= x"00000001";
				o_branch	<= '1';
			else 
			--	o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 11 then													-- Equal or Greater Than (Branch - Unsigned) Operation
			if(i_operandA >= i_operandB) then
			--	o_output	<= x"00000001";
				o_branch	<= '1';
			else 
			--	o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 12 then													-- Equal (Branch) Operation
			if(i_operandA = i_operandB) then
			--	o_output	<= x"00000001";
				o_branch	<= '1';
			else 
			--	o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 13 then													-- Not Equal (Branch) Operation
			if(i_operandA /= i_operandB) then
			--	o_output	<= x"00000001";
				o_branch	<= '1';
			else 
			--	o_output	<= x"00000000";
				o_branch	<= '0';
			end if;

		elsif i_operation = 14 then													-- Hamming Distance Operation
			temp	<= i_operandA XOR i_operandB;
			count	:= 0;
			
			for i in 0 to 31 loop
				if temp(i) = '1' then
					count := count + 1;
				end if;
			end loop;
			
			o_output <= std_logic_vector(conv_std_logic_vector(count, 32));

		elsif i_operation = 15 then													-- pkg Operation
			o_output	<= i_operandB(15 downto 0) & i_operandA(15 downto 0);

		elsif i_operation = 16 then													-- rvrs Operation
			for i in 0 to 31 loop
				o_output(i) <= i_operandA(31 - i);
			end loop;

		elsif i_operation = 17 then													-- sladd Operation
			temp(31 downto 1) <= i_operandA(30 downto 0);
			temp(0) <= '0';
			--temp		<= i_operandA sll 1;
			o_output	<= temp + i_operandB;

		elsif i_operation = 18 then													-- cntz Operation
			if i_operandA = x"00000000" then
				o_output	<= x"00000010";
			elsif i_operandA(0) = '1' then
				o_output	<= x"00000000";
			else
				count	:= 0;

				for i in 0 to 31 loop
					if i_operandA(i) = '0' then
						count := count + 1;
					elsif i_operandA(i) = '1' then
						o_output <= std_logic_vector(conv_std_logic_vector(count, 32));
						exit;
					end if;
				end loop;
			end if;
			
		elsif i_operation = 19 then													-- cntp Operation
			count	:= 0;
			
			for i in 0 to 31 loop
				if temp(i) = '1' then
					count := count + 1;
				end if;
			end loop;
			
			o_output <= std_logic_vector(conv_std_logic_vector(count, 32));
		end if;
	end process;
end Behavioral;
