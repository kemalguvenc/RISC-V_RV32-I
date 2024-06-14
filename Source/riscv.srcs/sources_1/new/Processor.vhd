library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
	port (
		i_clk								: in std_logic						:= '0';
		i_onOff								: in std_logic						:= '0';
		i_reset								: in std_logic						:= '0';

		o_registerOut						: out std_logic_vector(15 downto 0)	:= (others => '0');
		o_7SegmentDisplayForClk1			: out std_logic_vector(6 downto 0)	:= b"0111111";
		o_7SegmentDisplayForClk2			: out std_logic_vector(6 downto 0)	:= b"0111111";
		o_7SegmentDisplayForBranch			: out std_logic_vector(6 downto 0)	:= b"0111111"
	);
end Processor;

architecture Behavioral of Processor is

																										-- Components

component ClkCounter is
	port (
		i_clk   							: in std_logic;
		i_reset								: in std_logic;

		o_7SegmentDisplay1  				: out std_logic_vector(6 downto 0)	:= b"1000000";
		o_7SegmentDisplay2  				: out std_logic_vector(6 downto 0)	:= b"1000000"
	);
end component;

component WrongBranchCounter is
    port (
		i_clk								: in std_logic;
		i_reset								: in std_logic;
		i_wrong								: in std_logic;

		o_7SegmentDisplay					: out std_logic_vector(6 downto 0)	:= b"1000000"
    );
end component;

component BranchPredictioner is
	port (
		i_clk								: in std_logic;
		i_instruction						: in std_logic_vector(31 downto 0);
		i_programCounter					: in std_logic_vector(31 downto 0);
		i_branchResult						: in std_logic;

		o_newProgramCounter					: out std_logic_vector (31 downto 0);
		o_programCounterSelector			: out std_logic;
		o_kill_Instructions					: out std_logic;
		o_stopPipeline						: out std_logic
	);
end component;

component Program_Counter is
	port (
		i_clk				: in std_logic						:= '0';
		i_instructionAdress	: in std_logic_vector(31 downto 0)	:= x"00000000";
		i_reset				: in std_logic						:= '0';

		o_instructionAdress	: out std_logic_vector(31 downto 0)	:= x"00000000"
	);
end component;

component Instruction_Memory is
	port (
		i_dataAdress						: in std_logic_vector(31 downto 0);

		o_readData							: out std_logic_vector(31 downto 0)
	);
end component;

component Transfer_Layer_1to2 is
	port (
		i_clk								: in std_logic						:= '0';
		i_stop								: in std_logic						:= '0';

 		i_programCounter					: in std_logic_vector(31 downto 0)	:= x"00000000";
 		i_instruction						: in std_logic_vector(31 downto 0)	:= x"00000000";
 		i_killInstruction					: in std_logic						:= '0';

 		o_programCounter					: out std_logic_vector(31 downto 0)	:= x"00000000";
 		o_instruction						: out std_logic_vector(31 downto 0)	:= x"00000000";
 		o_killInstruction					: out std_logic						:= '0'
	);
end component;

component Control_Unit is
	port (
		i_opcode							: in std_logic_vector(6 downto 0);
		i_funct3							: in std_logic_vector(2 downto 0);
		i_funct7							: in std_logic_vector(6 downto 0);
		i_rs2								: in std_logic_vector(4 downto 0);

		o_operationSelecter					: out std_logic_vector(4 downto 0);
		o_firstOperandSelectorForAlu		: out std_logic;
		o_secondOperandSelectorForAlu		: out std_logic_vector(1 downto 0);
		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0);
		o_writeToDestinationRegister		: out std_logic;
		o_typeOfMemoryData					: out std_logic;
		o_sizeOfMemoryData					: out std_logic_vector(1 downto 0);
		o_writeToMemory						: out std_logic;
		o_instructionType					: out std_logic_vector(1 downto 0)
	);
end component;

component Register_File is
	port (
		i_clk								: in std_logic;
		i_rs1Adress							: in std_logic_vector(4 downto 0);
		i_rs2Adress							: in std_logic_vector(4 downto 0);
		i_rdAdress							: in std_logic_vector(4 downto 0);
		i_rdData							: in std_logic_vector(31 downto 0);
		i_controlWrite						: in std_logic;

		o_rs1Data							: out std_logic_vector(31 downto 0);
		o_rs2Data							: out std_logic_vector(31 downto 0);
		o_x2Data							: out std_logic_vector(15 downto 0)
	);
end component;

component DataForwarder is
	port ( 
		i_rs1A								: in std_logic_vector (4 downto 0);
		i_rs2A								: in std_logic_vector (4 downto 0);
		i_verificationForThird				: in std_logic;
		i_rdForThird						: in std_logic_vector (4 downto 0);
		i_dataForThird						: in std_logic_vector (31 downto 0);
		i_verificationForFourth				: in std_logic;
		i_rdForFourth						: in std_logic_vector (4 downto 0);
		i_dataForFourth						: in std_logic_vector (31 downto 0);
		i_verificationForFifth				: in std_logic;
		i_rdForFifth						: in std_logic_vector (4 downto 0);
		i_dataForFifth						: in std_logic_vector (31 downto 0);

		o_dataForwardForFirst				: out std_logic;
		o_dataForwardForSecond				: out std_logic;
		o_registerDataForFirst				: out std_logic_vector (31 downto 0);
		o_registerDataForSecond				: out std_logic_vector (31 downto 0)
		);
end component;

component Immediate_Expander is
	port (
		i_immediate							: in std_logic_vector(24 downto 0);
		i_instructionType					: in std_logic_vector(1 downto 0);

		o_output							: out std_logic_vector(31 downto 0)
	);
end component;

component Transfer_Layer_2To3 is
	port (
		i_clk								: in std_logic;
		i_operationSelecter					: in std_logic_vector(4 downto 0);
		i_firstOperandSelectorForAlu		: in std_logic;
		i_secondOperandSelectorForAlu		: in std_logic_vector(1 downto 0);
		i_dataOfDestinationRegisterSelector	: in std_logic_vector(1 downto 0);
		i_writeToDestinationRegister		: in std_logic;
		i_typeOfMemoryData					: in std_logic;
		i_sizeOfMemoryData					: in std_logic_vector(1 downto 0);
		i_writeToMemory						: in std_logic;
		i_programCounter					: in std_logic_vector(31 downto 0);
		i_rs1								: in std_logic_vector(31 downto 0);
		i_rs2								: in std_logic_vector(31 downto 0);
		i_immediate							: in std_logic_vector(31 downto 0);
		i_destinationRegister				: in std_logic_vector(4 downto 0);
		i_killInstruction					: in std_logic;

 		o_operationSelecter					: out std_logic_vector(4 downto 0);
		o_firstOperandSelectorForAlu		: out std_logic;
		o_secondOperandSelectorForAlu		: out std_logic_vector(1 downto 0);
		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0);
		o_writeToDestinationRegister		: out std_logic;
		o_typeOfMemoryData					: out std_logic;
		o_sizeOfMemoryData					: out std_logic_vector(1 downto 0);
		o_writeToMemory						: out std_logic;
		o_programCounter					: out std_logic_vector(31 downto 0);
		o_rs1								: out std_logic_vector(31 downto 0);
		o_rs2								: out std_logic_vector(31 downto 0);
		o_immediate							: out std_logic_vector(31 downto 0);
		o_destinationRegister				: out std_logic_vector(4 downto 0);
		o_killInstruction					: out std_logic
	);
end component;

component ALU is
	port (
		i_operandA							: in std_logic_vector (31 downto 0);
		i_operandB							: in std_logic_vector (31 downto 0);
		i_operation 						: in std_logic_vector (4 downto 0);

		o_output							: out std_logic_vector (31 downto 0);
		o_branch							: out std_logic
	);
end component;

component Transfer_Layer_3To4 is
	port (
		i_clk								: in std_logic;
		i_dataOfDestinationRegisterSelector	: in std_logic_vector(1 downto 0);
		i_writeToDestinationRegister		: in std_logic;
		i_typeOfMemoryData					: in std_logic;
		i_sizeOfMemoryData					: in std_logic_vector(1 downto 0);
		i_writeToMemory						: in std_logic;
		i_resultOfALU						: in std_logic_vector(31 downto 0);
		i_rs2								: in std_logic_vector(31 downto 0);
		i_immediate							: in std_logic_vector(31 downto 0);
		i_destinationRegister				: in std_logic_vector(4 downto 0);
		i_killInstruction					: in std_logic;

		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0);
		o_writeToDestinationRegister		: out std_logic;
		o_typeOfMemoryData					: out std_logic;
		o_sizeOfMemoryData					: out std_logic_vector(1 downto 0);
		o_writeToMemory						: out std_logic;
		o_resultOfALU						: out std_logic_vector(31 downto 0);
		o_rs2								: out std_logic_vector(31 downto 0);
		o_immediate							: out std_logic_vector(31 downto 0);
		o_destinationRegister				: out std_logic_vector(4 downto 0);
		o_killInstruction					: out std_logic
	);
end component;

component Data_Memory is
	port (
		i_clk								: in std_logic;
		i_address							: in std_logic_vector(31 downto 0);
		i_dataSize							: in std_logic_vector(1 downto 0);
		i_dataType							: in std_logic;
		i_readWriteControl					: in std_logic;
		i_data								: in std_logic_vector(31 downto 0);

		o_data								: out std_logic_vector(31 downto 0)
	);
end component;

component Transfer_Layer_4To5 is
	port (
		i_clk								: in std_logic;
		i_dataOfDestinationRegisterSelector	: in std_logic_vector(1 downto 0);
		i_writeToDestinationRegister		: in std_logic;
		i_memoryData						: in std_logic_vector(31 downto 0);
		i_resultOfALU						: in std_logic_vector(31 downto 0);
		i_immediate							: in std_logic_vector(31 downto 0);
		i_destinationRegister				: in std_logic_vector(4 downto 0);
		i_killInstruction					: in std_logic;

		o_dataOfDestinationRegisterSelector	: out std_logic_vector(1 downto 0);
		o_writeToDestinationRegister		: out std_logic;
		o_memoryData						: out std_logic_vector(31 downto 0);
		o_resultOfALU						: out std_logic_vector(31 downto 0);
		o_immediate							: out std_logic_vector(31 downto 0);
		o_destinationRegister				: out std_logic_vector(4 downto 0);
		o_killInstruction					: out std_logic
	);
end component;

-- Signals

signal s_outData							: std_logic_vector(15 downto 0)	:= (others => '0');
signal s_counterForClock1					: std_logic_vector(6 downto 0)	:=	b"1000000";
signal s_counterForClock2					: std_logic_vector(6 downto 0)	:= 	b"1000000";
signal s_counterForBranch					: std_logic_vector(6 downto 0)	:= 	b"1000000";
signal clk									: std_logic						:= '0';
signal s_reset								: std_logic						:= '0';

-- 1. Stage
signal s_programCounter						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_instruction						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_stop								: std_logic						:= '0';
signal s_killInstruction_1					: std_logic						:= '0';
signal s_predictedProgramCounter			: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_programCounterSelector				: std_logic						:= '0';
signal s_newProgramCounter					: std_logic_vector(31 downto 0)	:= x"00000000";

-- 2. Stage
signal s_programCounter_2					: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_instruction_2						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_killInstruction_2					: std_logic						:= '0';

signal s_operationSelecter_2				: std_logic_vector(4 downto 0)	:= b"00000";
signal s_firstOperandSelectorForAlu_2		: std_logic						:= '0';
signal s_secondOperandSelectorForAlu_2		: std_logic_vector(1 downto 0)	:= b"00";
signal s_dataOfDestinationRegisterSelector_2: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToDestinationRegister_2		: std_logic						:= '0';
signal s_typeOfMemoryData_2					: std_logic						:= '0';
signal s_sizeOfMemoryData_2					: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToMemory_2					: std_logic						:= '0';
signal s_instructionType					: std_logic_vector(1 downto 0)	:= b"00";
signal s_rs1Data							: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_rs2Data							: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_expandedImmediate_2				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_realRS1Data_2						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_realRS2Data_2						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_verificationForThird				: std_logic						:= '0';
signal s_dataForThird						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_verificationForFourth				: std_logic						:= '0';
signal s_dataForFourth						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_verificationForFifth				: std_logic						:= '0';
signal s_dataForFifth						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_dataForwardForFirst				: std_logic						:= '0';
signal s_dataForwardForSecond				: std_logic						:= '0';
signal s_registerDataForFirst				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_registerDataForSecond				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_updatedKillInstruction_2			: std_logic						:= '0';


-- 3. Stage
signal s_operationSelecter_3				: std_logic_vector(4 downto 0)	:= b"00000";
signal s_firstOperandSelectorForAlu_3		: std_logic						:= '0';
signal s_secondOperandSelectorForAlu_3		: std_logic_vector(1 downto 0)	:= b"00";
signal s_dataOfDestinationRegisterSelector_3: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToDestinationRegister_3		: std_logic						:= '0';
signal s_typeOfMemoryData_3					: std_logic						:= '0';
signal s_sizeOfMemoryData_3					: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToMemory_3					: std_logic						:= '0';
signal s_programCounter_3					: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_realRS1Data_3						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_realRS2Data_3						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_expandedImmediate_3				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_destinationRegister_3				: std_logic_vector(4 downto 0)	:= b"00000";
signal s_killInstruction_3					: std_logic						:= '0';

signal s_resultOfALU_3						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_operandA							: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_operandB							: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_updatedKillInstruction_3			: std_logic						:= '0';

-- 4. Stage
signal s_dataOfDestinationRegisterSelector_4: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToDestinationRegister_4		: std_logic						:= '0';
signal s_typeOfMemoryData_4					: std_logic						:= '0';
signal s_sizeOfMemoryData_4					: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToMemory_4					: std_logic						:= '0';
signal s_realRS2Data_4						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_killInstruction_4					: std_logic						:= '0';
signal s_resultOfALU_4						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_expandedImmediate_4				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_destinationRegister_4				: std_logic_vector(4 downto 0)	:= b"00000";

signal s_realWriteToMemory					: std_logic						:= '0';
signal s_memoryData_4						: std_logic_vector(31 downto 0)	:= x"00000000";

-- 5. Stage
signal s_dataOfDestinationRegisterSelector_5: std_logic_vector(1 downto 0)	:= b"00";
signal s_writeToDestinationRegister_5		: std_logic						:= '0';
signal s_memoryData_5						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_killInstruction_5					: std_logic						:= '0';

signal s_resultOfALU_5						: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_expandedImmediate_5				: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_destinationRegister_5				: std_logic_vector(4 downto 0)	:= b"00000";
signal s_rdData								: std_logic_vector(31 downto 0)	:= x"00000000";
signal s_realWriteRegister					: std_logic						:= '0';

-- 1 - 3 Stage
signal s_resultOfPrediction					: std_logic						:= '0';
signal s_programcounterForJALR				: std_logic_vector(31 downto 0)	:= x"00000000";

begin
	o_registerOut				<= s_outData;
	o_7SegmentDisplayForClk1	<= s_counterForClock1;
	o_7SegmentDisplayForClk2	<= s_counterForClock2;
	o_7SegmentDisplayForBranch	<= s_counterForBranch;
	clk							<= i_clk and i_onOff;
	s_reset						<= i_reset;
	process (all)
	begin
		-- MUX-2
		if s_programCounterSelector = '0' then
			s_newProgramCounter	<= s_predictedProgramCounter;
		else
			s_newProgramCounter <= s_programcounterForJALR;
		end if;

		-- MUX-VY1
		if s_dataForwardForFirst = '0' then
			s_realRS1Data_2	<= s_rs1Data;
		else
			s_realRS1Data_2 <= s_registerDataForFirst;
		end if;

		-- MUX-VY2
		if s_dataForwardForSecond = '0' then
			s_realRS2Data_2	<= s_rs2Data;
		else
			s_realRS2Data_2 <= s_registerDataForSecond;
		end if;

		-- OR - 2. Stage - Branch Control
		s_updatedKillInstruction_2	<= s_killInstruction_2 or s_killInstruction_1;

		-- OR - 3. Stage - Branch Control
		s_updatedKillInstruction_3	<= s_killInstruction_3 or s_killInstruction_1;

		-- AND - 3. Stage - Write Memory
		s_realWriteToMemory	<= s_writeToMemory_4 and not(s_killInstruction_4);

		-- Special ADD - 3. Stage - JALR
		s_programcounterForJALR		<= s_realRS1Data_3 + s_expandedImmediate_3;
		s_programcounterForJALR(0)	<= '0';

		-- AND - 3. Stage - Data Forward
		s_verificationForThird	<= s_dataOfDestinationRegisterSelector_3(0) and not(s_updatedKillInstruction_3) and s_writeToDestinationRegister_3;

		-- AND - 4. Stage - Data Forward
		s_verificationForFourth	<= not(s_killInstruction_4) and s_writeToDestinationRegister_4;

		-- AND - 5. Stage - Data Forward
		s_verificationForFifth	<= not(s_killInstruction_5) and s_writeToDestinationRegister_5;

		-- AND - 5. Stage - Write Register
		s_realWriteRegister	<= s_writeToDestinationRegister_5 and not(s_killInstruction_5);

		-- MUX-0
		if s_firstOperandSelectorForAlu_3 = '0' then
			s_operandA	<= s_realRS1Data_3;
		else
			s_operandA	<= s_programCounter_3;
		end if;

		-- MUX-1
		if s_secondOperandSelectorForAlu_3 = b"00" then
			s_operandB	<= s_realRS2Data_3;
		elsif s_secondOperandSelectorForAlu_3 = b"01" then
			s_operandB	<= s_expandedImmediate_3;
		else
			s_operandB	<= x"00000004";
		end if;

		-- MUX-4
		if s_dataOfDestinationRegisterSelector_3(1) = '0' then
			s_dataForThird	<= s_resultOfALU_3;
		else
			s_dataForThird	<= s_expandedImmediate_3;
		end if;

		-- MUX-5
		if s_dataOfDestinationRegisterSelector_4 = b"00" then
			s_dataForFourth	<= s_memoryData_4;
		elsif s_dataOfDestinationRegisterSelector_4 = b"01" then
			s_dataForFourth	<= s_resultOfALU_4;
		else
			s_dataForFourth	<= s_expandedImmediate_4;
		end if;

		-- MUX-3
		if s_dataOfDestinationRegisterSelector_5 = b"00" then
			s_rdData	<= s_memoryData_5;
		elsif s_dataOfDestinationRegisterSelector_5 = b"01" then
			s_rdData	<= s_resultOfALU_5;
		else
			s_rdData	<= s_expandedImmediate_5;
		end if;
	end process;

	CC : ClkCounter
	port map (
		i_clk   							=> clk,
		i_reset								=> s_reset,
		o_7SegmentDisplay1  				=> s_counterForClock1,
		o_7SegmentDisplay2  				=> s_counterForClock2
	);
	
	WBC : WrongBranchCounter
	port map(
		i_clk   							=> clk,
		i_reset								=> s_reset,
		i_wrong								=> s_killInstruction_1,

		o_7SegmentDisplay					=> s_counterForBranch
	);

	BP : BranchPredictioner
	port map (
		i_clk								=> clk,
		i_instruction						=> s_instruction,
		i_programCounter					=> s_programCounter,
		i_branchResult						=> s_resultOfPrediction,
		o_newProgramCounter					=> s_predictedProgramCounter,
		o_programCounterSelector			=> s_programCounterSelector,
		o_kill_Instructions					=> s_killInstruction_1,
		o_stopPipeline						=> s_stop
	);

	PC : Program_Counter
	port map (
		i_clk								=> clk,
		i_instructionAdress					=> s_newProgramCounter,
		i_reset								=> s_reset,
		o_instructionAdress					=> s_programCounter
	);

	IM : Instruction_Memory
	port map (
		i_dataAdress						=> s_programCounter,
		o_readData							=> s_instruction
	);

	TT_12 : Transfer_Layer_1to2
	port map (
		i_clk								=> clk,
		i_stop								=> s_stop,
		i_programCounter					=> s_programCounter,
		i_instruction						=> s_instruction,
		i_killInstruction					=> s_killInstruction_1,
		o_programCounter					=> s_programCounter_2,
		o_instruction						=> s_instruction_2,
		o_killInstruction					=> s_killInstruction_2
	);

	CU : Control_Unit
	port map (
		i_opcode							=> s_instruction_2(6 downto 0),
		i_funct3							=> s_instruction_2(14 downto 12),
		i_funct7							=> s_instruction_2(31 downto 25),
		i_rs2								=> s_instruction_2(24 downto 20),
		o_operationSelecter					=> s_operationSelecter_2,
		o_firstOperandSelectorForAlu		=> s_firstOperandSelectorForAlu_2,
		o_secondOperandSelectorForAlu		=> s_secondOperandSelectorForAlu_2,
		o_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_2,
		o_writeToDestinationRegister		=> s_writeToDestinationRegister_2,
		o_typeOfMemoryData					=> s_typeOfMemoryData_2,
		o_sizeOfMemoryData					=> s_sizeOfMemoryData_2,
		o_writeToMemory						=> s_writeToMemory_2,
		o_instructionType					=> s_instructionType
	);

	RF : Register_File
	port map (
		i_clk								=> clk,
		i_rs1Adress							=> s_instruction_2(19 downto 15),
		i_rs2Adress							=> s_instruction_2(24 downto 20),
		i_rdAdress							=> s_destinationRegister_5,
		i_rdData							=> s_rdData,
		i_controlWrite						=> s_realWriteRegister,
		o_rs1Data							=> s_rs1Data,
		o_rs2Data							=> s_rs2Data,
		o_x2Data							=> s_outData
	);

	DF : DataForwarder
	port map (
		i_rs1A								=> s_instruction_2(19 downto 15),
		i_rs2A								=> s_instruction_2(24 downto 20),
		i_verificationForThird				=> s_verificationForThird,
		i_rdForThird						=> s_destinationRegister_3,
		i_dataForThird						=> s_dataForThird,
		i_verificationForFourth				=> s_verificationForFourth,
		i_rdForFourth						=> s_destinationRegister_4,
		i_dataForFourth						=> s_dataForFourth,
		i_verificationForFifth				=> s_verificationForFifth,
		i_rdForFifth						=> s_destinationRegister_5,
		i_dataForFifth						=> s_rdData,
		o_dataForwardForFirst				=> s_dataForwardForFirst,
		o_dataForwardForSecond				=> s_dataForwardForSecond,
		o_registerDataForFirst				=> s_registerDataForFirst,
		o_registerDataForSecond				=> s_registerDataForSecond
	);

	IE : Immediate_Expander
	port map (
		i_immediate							=> s_instruction_2(31 downto 7),
		i_instructionType					=> s_instructionType,
		o_output							=> s_expandedImmediate_2
	);

	TL_23 : Transfer_Layer_2To3
	port map (
		i_clk								=> clk,
		i_operationSelecter					=> s_operationSelecter_2,
		i_firstOperandSelectorForAlu		=> s_firstOperandSelectorForAlu_2,
		i_secondOperandSelectorForAlu		=> s_secondOperandSelectorForAlu_2,
		i_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_2,
		i_writeToDestinationRegister		=> s_writeToDestinationRegister_2,
		i_typeOfMemoryData					=> s_typeOfMemoryData_2,
		i_sizeOfMemoryData					=> s_sizeOfMemoryData_2,
		i_writeToMemory						=> s_writeToMemory_2,
		i_programCounter					=> s_programCounter_2,
		i_rs1								=> s_realRS1Data_2,
		i_rs2								=> s_realRS2Data_2,
		i_immediate							=> s_expandedImmediate_2,
		i_destinationRegister				=> s_instruction_2(11 downto 7),
		i_killInstruction					=> s_updatedKillInstruction_2,
		o_operationSelecter					=> s_operationSelecter_3,
		o_firstOperandSelectorForAlu		=> s_firstOperandSelectorForAlu_3,
		o_secondOperandSelectorForAlu		=> s_secondOperandSelectorForAlu_3,
		o_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_3,
		o_writeToDestinationRegister		=> s_writeToDestinationRegister_3,
		o_typeOfMemoryData					=> s_typeOfMemoryData_3,
		o_sizeOfMemoryData					=> s_sizeOfMemoryData_3,
		o_writeToMemory						=> s_writeToMemory_3,
		o_programCounter					=> s_programCounter_3,
		o_rs1								=> s_realRS1Data_3,
		o_rs2								=> s_realRS2Data_3,
		o_immediate							=> s_expandedImmediate_3,
		o_destinationRegister				=> s_destinationRegister_3,
		o_killInstruction					=> s_killInstruction_3
	);

	ALUU : ALU
	port map (
		i_operandA							=> s_operandA,
		i_operandB							=> s_operandB,
		i_operation 						=> s_operationSelecter_3,
		o_output							=> s_resultOfALU_3,
		o_branch							=> s_resultOfPrediction
	);

	TL_34 : Transfer_Layer_3To4
	port map (
		i_clk								=> clk,
		i_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_3,
		i_writeToDestinationRegister		=> s_writeToDestinationRegister_3,
		i_typeOfMemoryData					=> s_typeOfMemoryData_3,
		i_sizeOfMemoryData					=> s_sizeOfMemoryData_3,
		i_writeToMemory						=> s_writeToMemory_3,
		i_resultOfALU						=> s_resultOfALU_3,
		i_rs2								=> s_realRS2Data_3,
		i_immediate							=> s_expandedImmediate_3,
		i_destinationRegister				=> s_destinationRegister_3,
		i_killInstruction					=> s_updatedKillInstruction_3,
		o_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_4,
		o_writeToDestinationRegister		=> s_writeToDestinationRegister_4,
		o_typeOfMemoryData					=> s_typeOfMemoryData_4,
		o_sizeOfMemoryData					=> s_sizeOfMemoryData_4,
		o_writeToMemory						=> s_writeToMemory_4,
		o_resultOfALU						=> s_resultOfALU_4,
		o_rs2								=> s_realRS2Data_4,
		o_immediate							=> s_expandedImmediate_4,
		o_destinationRegister				=> s_destinationRegister_4,
		o_killInstruction					=> s_killInstruction_4
	);

	DM : Data_Memory
	port map (
		i_clk								=> clk,
		i_address							=> s_resultOfALU_4,
		i_dataSize							=> s_sizeOfMemoryData_4,
		i_dataType							=> s_typeOfMemoryData_4,
		i_readWriteControl					=> s_realWriteToMemory,
		i_data								=> s_realRS2Data_4,
		o_data								=> s_memoryData_4
	);

	TL_45 : Transfer_Layer_4To5
	port map (
		i_clk								=> clk,
		i_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_4,
		i_writeToDestinationRegister		=> s_writeToDestinationRegister_4,
		i_memoryData						=> s_memoryData_4,
		i_resultOfALU						=> s_resultOfALU_4,
		i_immediate							=> s_expandedImmediate_4,
		i_destinationRegister				=> s_destinationRegister_4,
		i_killInstruction					=> s_killInstruction_4,
		o_dataOfDestinationRegisterSelector	=> s_dataOfDestinationRegisterSelector_5,
		o_writeToDestinationRegister		=> s_writeToDestinationRegister_5,
		o_memoryData						=> s_memoryData_5,
		o_resultOfALU						=> s_resultOfALU_5,
		o_immediate							=> s_expandedImmediate_5,
		o_destinationRegister				=> s_destinationRegister_5,
		o_killInstruction					=> s_killInstruction_5
	);


end Behavioral;
