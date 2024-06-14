library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Register_File is
	port (
		i_clk				: in std_logic						:= '0';
		i_rs1Adress			: in std_logic_vector(4 downto 0)	:= (others => '0');
		i_rs2Adress			: in std_logic_vector(4 downto 0)	:= (others => '0');
		i_rdAdress			: in std_logic_vector(4 downto 0)	:= (others => '0');
		i_rdData			: in std_logic_vector(31 downto 0)	:= (others => '0');
		i_controlWrite		: in std_logic						:= '0';

		o_rs1Data			: out std_logic_vector(31 downto 0)	:= (others => '0');
		o_rs2Data			: out std_logic_vector(31 downto 0)	:= (others => '0');
		o_x2Data			: out std_logic_vector(15 downto 0)	:= (others => '0')
	);
end Register_File;

architecture Behavioral of Register_File is

	type RegisterArray is array (0 to 31) of std_logic_vector(31 downto 0);
	signal Registers	: RegisterArray	:= (others => (others => '0'));

begin

	o_rs1Data	<= Registers(conv_integer(i_rs1Adress));
	o_rs2Data	<= Registers(conv_integer(i_rs2Adress));
	o_x2Data	<= Registers(3)(15 downto 0);
	
	process(all)
	begin
		if rising_edge(i_clk) then
			if i_controlWrite = '1' and i_rdAdress /= 0 then
				Registers(conv_integer(i_rdAdress)) <= i_rdData;
			end if;
		end if;
	end process;

end Behavioral;
