library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Processor is
end Processor;

architecture Behavioral of Processor is

--------------------------------------------------------------------------------
-- Birimlerin Tanımlanması
--------------------------------------------------------------------------------

component registerFile is
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
end component registerFile;

component ControlUnit is
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
end component ControlUnit;

component BranchPredictioner is
    port (
		i_clk			: in std_logic;
		i_instruction	: in std_logic_vector (31 downto 0);

		o_output    	: out std_logic_vector (31 downto 0)
	);
end component BranchPredictioner;

begin

--------------------------------------------------------------------------------
-- Birimlerin Oluşturulması
--------------------------------------------------------------------------------

c_BranchPredictioner : BranchPredictioner
port map(
i_clk				=> '0',
i_instruction	=> x"00000000"
);

c_controlUnit   : ControlUnit
port map(
	i_opcode					=> b"000000",
	i_funct3					=> b"000",
	i_funct7					=> b"0000000"
);

c_registerFile:registerFile
port map(
i_clk		=> '0',
i_rs1Adress	=> b"00000",
i_rs2Adress	=> b"00000",
i_rdAdress	=> b"00000",
i_rdData	=> x"00000000",
i_control	=> '0'
);


end Behavioral;
