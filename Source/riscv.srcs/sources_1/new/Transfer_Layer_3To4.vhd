library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Transfer_Layer_3To4 is
	port (
		i_clk								: in std_logic						:= '0';
		i_dataOfDestinationRegisterSelector	: in std_logic_vector(1 downto 0)	:= (others => '0');
		i_writeToDestinationRegister		: in std_logic						:= '0';
		i_typeOfMemoryData					: in std_logic						:= '0';
		i_sizeOfMemoryData					: in std_logic_vector(1 downto 0)	:= (others => '0');
		i_writeToMemory						: in std_logic						:= '0';
		i_resultOfALU						: in std_logic_vector(31 downto 0)	:= (others => '0');
		i_rs2								: in std_logic_vector(31 downto 0)	:= (others => '0');
		i_immediate							: in std_logic_vector(31 downto 0)	:= (others => '0');
		i_destinationRegister				: in std_logic_vector(4 downto 0)	:= (others => '0');
		i_killInstruction					: in std_logic						:= '0';

		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0)	:= (others => '0');
		o_writeToDestinationRegister		: out std_logic						:= '0';
		o_typeOfMemoryData					: out std_logic						:= '0';
		o_sizeOfMemoryData					: out std_logic_vector(1 downto 0)	:= (others => '0');
		o_writeToMemory						: out std_logic						:= '0';
		o_resultOfALU						: out std_logic_vector(31 downto 0)	:= (others => '0');
		o_rs2								: out std_logic_vector(31 downto 0)	:= (others => '0');
		o_immediate							: out std_logic_vector(31 downto 0)	:= (others => '0');
		o_destinationRegister				: out std_logic_vector(4 downto 0)	:= (others => '0');
		o_killInstruction					: out std_logic						:= '0'
	);
end Transfer_Layer_3To4;

architecture Behavioral of Transfer_Layer_3To4 is

begin

	process (i_clk)
	begin
		if rising_edge(i_clk) then
			o_dataOfDestinationRegisterSelector	<= i_dataOfDestinationRegisterSelector;
			o_writeToDestinationRegister		<= i_writeToDestinationRegister;
			o_typeOfMemoryData					<= i_typeOfMemoryData;
			o_sizeOfMemoryData					<= i_sizeOfMemoryData;
			o_writeToMemory						<= i_writeToMemory;
			o_resultOfALU						<= i_resultOfALU;
			o_rs2								<= i_rs2;
			o_immediate							<= i_immediate;
			o_destinationRegister				<= i_destinationRegister;
			o_killInstruction					<= i_killInstruction;
		end if;
	end process;

end Behavioral;
