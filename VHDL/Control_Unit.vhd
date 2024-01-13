library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control_Unit is
	port (
		i_opcode					: in std_logic_vector(5 downto 0);
		i_funct3					: in std_logic_vector(2 downto 0);
		i_funct7					: in std_logic_vector(6 downto 0);

		o_selecterFunction			: out std_logic_vector(3 downto 0);
		o_instructionType			: out std_logic_vector(2 downto 0);
		o_writeDestinationRegister	: out std_logic;
		o_writeMemory				: out std_logic;
		o_sizeMemoryData			: out std_logic_vector(1 downto 0);
		o_selectOperandALU			: out std_logic_vector(1 downto 0);
		o_dataDestinationRegister	: out std_logic_vector(1 downto 0);
		o_isJump					: out std_logic;
		o_widthMemoryData			: out std_logic_vector(1 downto 0);
		o_isJALR					: out std_logic;
		o_rs1PC				       	: out std_logic
	);
end Control_Unit;

architecture Behavioral of Control_Unit is

begin 
 
	process (i_opcode, i_funct3, i_funct7) 
	begin 
		if i_opcode = b"0110111" then 										-- LUI
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_dataDestinationRegister	<= b"10";
			o_isJump					<= '0';
			o_isJALR					<= '0';
		elsif i_opcode = b"0010111" then 									-- AUIPC
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"01";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC						<= '0';
		elsif i_opcode = b"1101111" then 									-- JAL
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"101";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"01";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '0';
		elsif i_opcode = b"1100111" and i_funct3 = b"000" then 				-- JALR
			o_selecterFunction			<= b"0001";
			o_instructionType			<= b"101";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"01";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '1';
			o_rs1PC					<= '0';
		elsif i_opcode = b"1100011" and i_funct3 = b"000" then 				-- BEQ
			o_selecterFunction			<= b"1101";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"1100011" and i_funct3 = b"001" then 				-- BNE
			o_selecterFunction			<= b"1101";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"1100011" and i_funct3 = b"100" then 				-- BLT
			o_selecterFunction			<= b"1001";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"1100011" and i_funct3 = b"101" then 				-- BGE
			o_selecterFunction			<= b"1011";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"1100011" and i_funct3 = b"110" then 				-- BLTU
			o_selecterFunction			<= b"1010";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"1100011" and i_funct3 = b"111" then 				-- BGEU
			o_selecterFunction			<= b"1100";
			o_instructionType			<= b"100";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"00";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0000011" and i_funct3 = b"000" then 				-- LB
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_sizeMemoryData			<= b"00";
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"00";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0000011" and i_funct3 = b"001" then 				-- LH
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_sizeMemoryData			<= b"01";
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"00";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0000011" and i_funct3 = b"010" then 				-- LW
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_sizeMemoryData			<= b"10";
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"00";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0000011" and i_funct3 = b"100" then 				-- LBU
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_sizeMemoryData			<= b"00";
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"00";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0000011" and i_funct3 = b"101" then 				-- LHU
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_sizeMemoryData			<= b"01";
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"00";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0100011" and i_funct3 = b"000" then 				-- SB
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"010";
			o_writeDestinationRegister	<= '0';
			o_writeMemory				<= '1';
			o_selectOperandALU			<= b"10";
			o_isJump					<= '0';
			o_widthMemoryData			<= b"00";
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0100011" and i_funct3 = b"001" then 				-- SH
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"010";
			o_writeDestinationRegister	<= '0';
			o_writeMemory				<= '1';
			o_selectOperandALU			<= b"10";
			o_isJump					<= '0';
			o_widthMemoryData			<= b"01";
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0100011" and i_funct3 = b"010" then 				-- SW
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"010";
			o_writeDestinationRegister	<= '0';
			o_writeMemory				<= '1';
			o_selectOperandALU			<= b"10";
			o_isJump					<= '0';
			o_widthMemoryData			<= b"10";
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"000" then 				-- ADDI
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"010" then 				-- SLTI
			o_selecterFunction			<= b"1001";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"011" then 				-- SLTIU
			o_selecterFunction			<= b"1010";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"100" then 				-- XORI
			o_selecterFunction			<= b"0101";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"110" then 				-- ORI
			o_selecterFunction			<= b"0010";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"111" then 				-- ANDI
			o_selecterFunction			<= b"0011";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"001" and i_funct7 = b"0000000" then 				-- SLLI
			o_selecterFunction			<= b"0110";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"101" and i_funct7 = b"0000000" then 				-- SRLI
			o_selecterFunction			<= b"0111";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0010011" and i_funct3 = b"101" and i_funct7 = b"0100000" then 				-- SRAI
			o_selecterFunction			<= b"1000";
			o_instructionType			<= b"001";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"000" and i_funct7 = b"0000000" then 				-- ADD
			o_selecterFunction			<= b"0000";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"000" and i_funct7 = b"0100000" then 				-- SUB
			o_selecterFunction			<= b"0010";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"001" and i_funct7 = b"0000000" then 				-- SLL
			o_selecterFunction			<= b"0110";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"010" and i_funct7 = b"0000000" then 				-- SLT
			o_selecterFunction			<= b"1010";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"011" and i_funct7 = b"0000000" then 				-- SLTU
			o_selecterFunction			<= b"1001";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"100" and i_funct7 = b"0000000" then 				-- XOR
			o_selecterFunction			<= b"0101";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"101" and i_funct7 = b"0000000" then 				-- SRL
			o_selecterFunction			<= b"0111";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"101" and i_funct7 = b"0100000" then 				-- SRA
			o_selecterFunction			<= b"1000";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"110" and i_funct7 = b"0000000" then 				-- OR
			o_selecterFunction			<= b"0100";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		elsif i_opcode = b"0110011" and i_funct3 = b"111" and i_funct7 = b"0000000" then 				-- AND
			o_selecterFunction			<= b"0011";
			o_instructionType			<= b"000";
			o_writeDestinationRegister	<= '1';
			o_writeMemory				<= '0';
			o_selectOperandALU			<= b"10";
			o_dataDestinationRegister	<= b"01";
			o_isJump					<= '0';
			o_isJALR					<= '0';
			o_rs1PC					<= '1';
		end if;
	end process;

end Behavioral;
