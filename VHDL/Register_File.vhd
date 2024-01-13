library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Register_File is
    port ( 
		i_clk		: in std_logic;
		i_rs1Adress	: in std_logic_vector(4 downto 0);
		i_rs2Adress	: in std_logic_vector(4 downto 0);
		i_rdAdress	: in std_logic_vector(4 downto 0);
		i_rdData	: in std_logic_vector(31 downto 0);
		i_control	: in std_logic;

		o_rsData1	: out std_logic_vector(31 downto 0);
		o_rsData2	: out std_logic_vector(31 downto 0);
		o_forwardingRS1	:out std_logic;
		o_forwardingRS2	:out std_logic
    );
end Register_File;

architecture Behavioral of Register_File is

	type RegisterArray is array (0 to 31) of std_logic_vector(31 downto 0);
	signal Registers	: RegisterArray	:= (others => (others => '0'));
	
	signal backupRS1   : std_logic_vector(4 downto 0);
	signal backupRS2   : std_logic_vector(4 downto 0);

begin

	process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_control = '1' and i_rdAdress /= 0 then
				Registers(conv_integer(i_rdAdress)) <= i_rdData;
			end if;
			backupRS1 <= i_rs1Adress;
			backupRS2 <= i_rs2Adress;
		end if;
	end process;

	o_rsData1 <= Registers(conv_integer(i_rs1Adress));
	o_rsData2 <= Registers(conv_integer(i_rs2Adress));

	process (i_rs1Adress, backupRS1, i_rs2Adress, backupRS2)
	begin
		if(i_rs1Adress = backupRS1) then
			o_forwardingRS1 <= '1';
		end if;
		if i_rs2Adress = backupRS2 then
			o_forwardingRS2 <= '1';
		end if;
	end process;

end Behavioral;
