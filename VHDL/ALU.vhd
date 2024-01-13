library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ALU is
    port (
		i_operandA	: in std_logic_vector (31 downto 0);
		i_operandB	: in std_logic_vector (31 downto 0);
		i_operation : in std_logic_vector (3 downto 0);

		o_output	: out std_logic_vector (31 downto 0);
		o_isTrue	: out std_logic
	);
end ALU;

architecture Behavioral of ALU is

signal s_shamt		: integer := conv_integer(unsigned(i_operandB));

begin

	process (i_operation)
	begin
		if i_operation = 0 then
			o_output	<= i_operandA + i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 1 then
			o_output	<= i_operandA + i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 2 then
			o_output	<= i_operandA - i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 3 then
			o_output	<= i_operandA AND i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 4 then
			o_output	<= i_operandA OR i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 5 then
			o_output	<= i_operandA XOR i_operandB;
			o_isTrue	<= '0';
		elsif i_operation = 6 then
			o_output	<= o_output sll s_shamt;
			o_isTrue	<= '0';
		elsif i_operation = 7 then
			o_output	<= o_output srl s_shamt;
			o_isTrue	<= '0';
		elsif i_operation = 8 then
			o_output	<= to_stdlogicvector(to_bitvector(o_output) sra s_shamt);
			o_isTrue	<= '0';
		elsif i_operation = 9 then
			if(signed(i_operandA) < signed(i_operandB)) then
				o_output <= x"00000001";
				o_isTrue	<= '1';
			else 
				o_output <= x"00000000";
				o_isTrue	<= '0';
			end if;
		elsif i_operation = 10 then
			if(unsigned(i_operandA) < unsigned(i_operandB)) then
				o_output <= x"00000001";
				o_isTrue	<= '1';
			else 
				o_output <= x"00000000";
				o_isTrue	<= '0';
			end if;
		elsif i_operation = 11 then
			if(signed(i_operandA) >= signed(i_operandB)) then
				o_output <= x"00000001";
				o_isTrue	<= '1';
			else 
				o_output <= x"00000000";
				o_isTrue	<= '0';
			end if;
		elsif i_operation = 12 then
			if(unsigned(i_operandA) >= unsigned(i_operandB)) then
				o_output <= x"00000001";
				o_isTrue	<= '1';
			else 
				o_output <= x"00000000";
				o_isTrue	<= '0';
			end if;
		elsif i_operation = 13 then
			if(i_operandA = i_operandB) then
				o_output <= x"00000001";
				o_isTrue	<= '1';
			else 
				o_output <= x"00000000";
				o_isTrue	<= '0';
			end if;
		end if;
	end process;
end Behavioral;
