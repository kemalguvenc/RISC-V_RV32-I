library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_Immediate_Expander is
end TestBench_Immediate_Expander;

architecture Behavioral of TestBench_Immediate_Expander is

component Immediate_Expander is
	port(
		i_immediate			: in std_logic_vector(24 downto 0);
		i_instructionType	: in std_logic_vector(1 downto 0);

		o_output			: out std_logic_vector(31 downto 0)
	);
end component;

signal immediate		: std_logic_vector(24 downto 0);
signal instructionType	: std_logic_vector(1 downto 0);
signal output			: std_logic_vector(31 downto 0);

begin

	IG : Immediate_Expander
	port map(
		i_immediate			=> immediate,
		i_instructionType	=> instructionType,

		o_output			=> output
	);

	test : process
	begin
		immediate		<= x"064" & b"00011" & b"000" & b"10101";					-- From ADDI Instruction (imm[11:0] - rs1 - funct3 - rd) -> imm = (00000064)h
		instructionType	<= b"00";													-- I Type Instruction
		wait for 20 ns;

		immediate		<= b"0000101" & b"00001" & b"10000" & b"001" & b"00101";	-- From SH Instruction (imm[11:5] - rs2 - rs1 - funct3 - imm[4:0]) -> imm = (000000a5)h
		instructionType	<= b"01";													-- S Type Instruction
		wait for 20ns;
		
		immediate		<= x"F5C40" & b"00100";										-- From LUI Instruction (imm[31:12] - rd) -> imm = (F5C40000)h
		instructionType	<= b"10";													-- U Type Instruction
		wait for 20ns;

		assert false
			report "Simulation Done"
			severity failure;
	end process;

end Behavioral;
