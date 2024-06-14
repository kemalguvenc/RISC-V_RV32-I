library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control_Unit is
	port (
		i_opcode							: in std_logic_vector(6 downto 0)	:= (others => '0');
		i_funct3							: in std_logic_vector(2 downto 0)	:= (others => '0');
		i_funct7							: in std_logic_vector(6 downto 0)	:= (others => '0');
		i_rs2								: in std_logic_vector(4 downto 0)	:= (others => '0');

		o_operationSelecter					: out std_logic_vector(4 downto 0)	:= (others => '0');		-- Selects a operation for ALU.
		o_firstOperandSelectorForAlu		: out std_logic						:= '0';					-- Selects first operand of ALU. First operand can be RS1(0) or PC(1).
		o_secondOperandSelectorForAlu		: out std_logic_vector(1 downto 0)	:= (others => '0');		-- Selects second operand of ALU. Second operand can be RS2(00), Immediate(01) or 4(10).
		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0)	:= (others => '0');		-- Selects the data to be written to the destination register. The data can be result of ALU(01), Immediate(11) or memory data(00).
		o_writeToDestinationRegister		: out std_logic						:= '0';					-- Allows writing to destination register.
		o_typeOfMemoryData					: out std_logic						:= '0';					-- Sets the type of data to be read from the data memory. Types can be unsigned(0) or signed(1).
		o_sizeOfMemoryData					: out std_logic_vector(1 downto 0)	:= (others => '0');		-- Sets the size of data to be read or written from the data memory. Sizes can be 8 Bit(00), 16 Bit (01) or 32 Bit(10).
		o_writeToMemory						: out std_logic						:= '0';					-- Allows writing to data memory.
		o_instructionType					: out std_logic_vector(1 downto 0)	:= (others => '0')		-- Gives information to Immediate Expander for expanding value properly. Instruction types can be I(00), S(01) or U(10).
	);
end Control_Unit;

architecture Behavioral of Control_Unit is

begin 
 
	process (all) 
	begin 
		if i_opcode = b"0110111" then 																			-- LUI
		--	o_operationSelecter					<= 
		--	o_firstOperandSelectorForAlu		<= 
		--	o_secondOperandSelectorForAlu		<= 
			o_dataOfDestinationRegisterSelector	<= b"11";		-- Immediate
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"10";		-- U
		elsif i_opcode = b"0010111" then 																		-- AUIPC
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '1';			-- PC
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"10";		-- U
		elsif i_opcode = b"1101111" then 																		-- JAL
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '1';			-- PC
			o_secondOperandSelectorForAlu		<= b"10";		-- 4
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100111" and i_funct3 = b"000" then 													-- JALR
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '1';			-- PC
			o_secondOperandSelectorForAlu		<= b"10";		-- 4
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"1100011" and i_funct3 = b"000" then 													-- BEQ
			o_operationSelecter					<= b"01100";	-- BEQ
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100011" and i_funct3 = b"001" then 													-- BNE
			o_operationSelecter					<= b"01101";	-- BNE
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100011" and i_funct3 = b"100" then 													-- BLT
			o_operationSelecter					<= b"01000";	-- BLT
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100011" and i_funct3 = b"101" then 													-- BGE
			o_operationSelecter					<= b"01010";	-- BGE
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100011" and i_funct3 = b"110" then 													-- BLTU
			o_operationSelecter					<= b"01001";	-- BLTU
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"1100011" and i_funct3 = b"111" then 													-- BGEU
			o_operationSelecter					<= b"01011";	-- BGEU
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0000011" and i_funct3 = b"000" then 													-- LB
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"00";		-- Memory Data
			o_writeToDestinationRegister		<= '1';
			o_typeOfMemoryData					<= '1';			-- Signed
			o_sizeOfMemoryData					<= b"00";		-- 8 Bit
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0000011" and i_funct3 = b"001" then 													-- LH
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"00";		-- Memory Data
			o_writeToDestinationRegister		<= '1';
			o_typeOfMemoryData					<= '1';			-- Signed
			o_sizeOfMemoryData					<= b"01";		-- 16 Bit
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0000011" and i_funct3 = b"010" then 													-- LW
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"00";		-- Memory Data
			o_writeToDestinationRegister		<= '1';
			o_typeOfMemoryData					<= '1';			-- Signed
			o_sizeOfMemoryData					<= b"10";		-- 32 Bit
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0000011" and i_funct3 = b"100" then 													-- LBU
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"00";		-- Memory Data
			o_writeToDestinationRegister		<= '1';
			o_typeOfMemoryData					<= '0';			-- Unsigned
			o_sizeOfMemoryData					<= b"00";		-- 8 Bit
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0000011" and i_funct3 = b"101" then 													-- LHU
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"00";		-- Memory Data
			o_writeToDestinationRegister		<= '1';
			o_typeOfMemoryData					<= '0';			-- Unsigned
			o_sizeOfMemoryData					<= b"01";		-- 16 Bit
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0100011" and i_funct3 = b"000" then 													-- SB
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
			o_sizeOfMemoryData					<= b"00";		-- 8 Bit
			o_writeToMemory						<= '1';
			o_instructionType					<= b"01";		-- S
		elsif i_opcode = b"0100011" and i_funct3 = b"001" then 													-- SH
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
			o_sizeOfMemoryData					<= b"01";		-- 16 Bit
			o_writeToMemory						<= '1';
			o_instructionType					<= b"01";		-- S
		elsif i_opcode = b"0100011" and i_funct3 = b"010" then 													-- SW
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
		--	o_dataOfDestinationRegisterSelector	<= 
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
			o_sizeOfMemoryData					<= b"10";		-- 32 Bit
			o_writeToMemory						<= '1';
			o_instructionType					<= b"01";		-- S
		elsif i_opcode = b"0010011" and i_funct3 = b"000" then 													-- ADDI
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"010" then 													-- SLTI
			o_operationSelecter					<= b"01000";	-- SLT
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"011" then 													-- SLTIU
			o_operationSelecter					<= b"01001";	-- SLTU
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"100" then 													-- XORI
			o_operationSelecter					<= b"00100";	-- XOR
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"110" then 													-- ORI
			o_operationSelecter					<= b"00011";	-- OR
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"111" then 													-- ANDI
			o_operationSelecter					<= b"00010";	-- AND
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"001" and i_funct7 = b"0000000" then 						-- SLLI
			o_operationSelecter					<= b"00101";	-- SLL
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"101" and i_funct7 = b"0000000" then 						-- SRLI
			o_operationSelecter					<= b"00110";	-- SRL
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0010011" and i_funct3 = b"101" and i_funct7 = b"0100000" then 						-- SRAI
			o_operationSelecter					<= b"00111";	-- SRA
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"01";		-- Immediate
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
			o_instructionType					<= b"00";		-- I
		elsif i_opcode = b"0110011" and i_funct3 = b"000" and i_funct7 = b"0000000" then 						-- ADD
			o_operationSelecter					<= b"00000";	-- ADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"000" and i_funct7 = b"0100000" then 						-- SUB
			o_operationSelecter					<= b"00001";	-- SUB
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"001" and i_funct7 = b"0000000" then 						-- SLL
			o_operationSelecter					<= b"00101";	-- SLL
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"010" and i_funct7 = b"0000000" then 						-- SLT
			o_operationSelecter					<= b"01000";	-- SLT
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"011" and i_funct7 = b"0000000" then 						-- SLTU
			o_operationSelecter					<= b"01001";	-- SLTU
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"100" and i_funct7 = b"0000000" then 						-- XOR
			o_operationSelecter					<= b"00100";	-- XOR
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"101" and i_funct7 = b"0000000" then 						-- SRL
			o_operationSelecter					<= b"00110";	-- SRL
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"101" and i_funct7 = b"0100000" then 						-- SRA
			o_operationSelecter					<= b"00111";	-- SRA
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"110" and i_funct7 = b"0000000" then 						-- OR
			o_operationSelecter					<= b"00011";	-- OR
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"111" and i_funct7 = b"0000000" then 						-- AND
			o_operationSelecter					<= b"00010";	-- AND
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"001" and i_funct7 = b"0000101" then 						-- HMDST
			o_operationSelecter					<= b"01110";	-- HMDST
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"100" and i_funct7 = b"0000100" then 						-- PKG
			o_operationSelecter					<= b"01111";	-- PKG
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0010011" and i_funct3 = b"101" and i_funct7 = b"0110101" and i_rs2 = b"11000" then	-- RVRS
			o_operationSelecter					<= b"10000";	-- RVRS
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0110011" and i_funct3 = b"010" and i_funct7 = b"0010000" then 						-- SLADD
			o_operationSelecter					<= b"10001";	-- SLADD
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0010011" and i_funct3 = b"001" and i_funct7 = b"0110000" and i_rs2 = b"00001" then 	-- CNTZ
			o_operationSelecter					<= b"10010";	-- CNTZ
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		elsif i_opcode = b"0010011" and i_funct3 = b"001" and i_funct7 = b"0110000" and i_rs2 = b"00010" then 	-- CNTP
			o_operationSelecter					<= b"10011";	-- CNTP
			o_firstOperandSelectorForAlu		<= '0';			-- RS1
			o_secondOperandSelectorForAlu		<= b"00";		-- RS2
			o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '1';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		else
		--	o_operationSelecter					<= b"10011";	-- CNTP
		--	o_firstOperandSelectorForAlu		<= '0';			-- RS1
		--	o_secondOperandSelectorForAlu		<= b"00";		-- RS2
		--	o_dataOfDestinationRegisterSelector	<= b"01";		-- Result of ALU
			o_writeToDestinationRegister		<= '0';
		--	o_typeOfMemoryData					<= 
		--	o_sizeOfMemoryData					<= 
			o_writeToMemory						<= '0';
		--	o_instructionType					<= 
		end if;
	end process;

end Behavioral;
