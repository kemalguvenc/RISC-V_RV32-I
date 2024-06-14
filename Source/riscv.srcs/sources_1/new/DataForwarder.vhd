library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataForwarder is
	port ( 
		i_rs1A					: in std_logic_vector (4 downto 0)		:= (others => '0');
		i_rs2A					: in std_logic_vector (4 downto 0)		:= (others => '0');
		i_verificationForThird	: in std_logic							:= '0';
		i_rdForThird			: in std_logic_vector (4 downto 0)		:= (others => '0');
		i_dataForThird			: in std_logic_vector (31 downto 0)		:= (others => '0');
		i_verificationForFourth	: in std_logic							:= '0';
		i_rdForFourth			: in std_logic_vector (4 downto 0)		:= (others => '0');
		i_dataForFourth			: in std_logic_vector (31 downto 0)		:= (others => '0');
		i_verificationForFifth	: in std_logic							:= '0';
		i_rdForFifth			: in std_logic_vector (4 downto 0)		:= (others => '0');
		i_dataForFifth			: in std_logic_vector (31 downto 0)		:= (others => '0');

		o_dataForwardForFirst	: out std_logic							:= '0';
		o_dataForwardForSecond	: out std_logic							:= '0';
		o_registerDataForFirst	: out std_logic_vector (31 downto 0)	:= (others => '0');
		o_registerDataForSecond	: out std_logic_vector (31 downto 0)	:= (others => '0')
		);
end DataForwarder;

architecture Behavioral of DataForwarder is

begin

	rs1 : process(all)
	begin
		if i_verificationForThird = '1' and i_rs1A = i_rdForThird then
			o_registerDataForFirst	<= i_dataForThird;
			o_dataForwardForFirst	<= '1';
		elsif i_verificationForFourth = '1' and i_rs1A = i_rdForFourth then
			o_registerDataForFirst	<= i_dataForFourth;
			o_dataForwardForFirst	<= '1';
		elsif i_verificationForFifth = '1' and i_rs1A = i_rdForFifth then
			o_registerDataForFirst	<= i_dataForFifth;
			o_dataForwardForFirst	<= '1';
		else
			o_dataForwardForFirst	<= '0';
		end if;
	end process;

	rs2 : process(all)
	begin
		if i_verificationForThird = '1' and i_rs2A = i_rdForThird then
			o_registerDataForSecond	<= i_dataForThird;
			o_dataForwardForSecond	<= '1';
		elsif i_verificationForFourth = '1' and i_rs2A = i_rdForFourth then
			o_registerDataForSecond	<= i_dataForFourth;
			o_dataForwardForSecond	<= '1';
		elsif i_verificationForFifth = '1' and i_rs2A = i_rdForFifth then
			o_registerDataForSecond	<= i_dataForFifth;
			o_dataForwardForSecond	<= '1';
		else
			o_dataForwardForSecond	<= '0';
		end if;
	end process;

end Behavioral;
