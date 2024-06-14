library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_Processor is
end TestBench_Processor;

architecture Behavioral of TestBench_Processor is

	component Processor is
		port (
			i_clk								: in std_logic						:= '0';
			i_onOff								: in std_logic						:= '0';
			i_reset								: in std_logic						:= '0';
	
			o_registerOut						: out std_logic_vector(15 downto 0)	:= (others => '0');
			o_7SegmentDisplayForClk1			: out std_logic_vector(6 downto 0)	:= b"0111111";
			o_7SegmentDisplayForClk2			: out std_logic_vector(6 downto 0)	:= b"0111111";
			o_7SegmentDisplayForBranch			: out std_logic_vector(6 downto 0)	:= b"0111111"
		);
	end component;

	signal s_clk							: std_logic 					:= '0';
	signal s_registerOut					: std_logic_vector(15 downto 0)	:= (others => '0');
	signal s_7SegmentDisplayForClk1 		: std_logic_vector(6 downto 0)	:= (others => '1');
	signal s_7SegmentDisplayForClk2			: std_logic_vector(6 downto 0)	:= (others => '1');
	signal s_7SegmentDisplayForBranch		: std_logic_vector(6 downto 0)	:= (others => '1');
	signal s_onOff							: std_logic						:= '0';
	signal s_reset							: std_logic						:= '0';	

begin

	P : Processor
	port map (
		i_clk						=> s_clk,
		i_onOff						=> s_onOff,
		i_reset						=> s_reset,
		o_registerOut				=> s_registerOut,
		o_7SegmentDisplayForClk1	=> s_7SegmentDisplayForClk1,
		o_7SegmentDisplayForClk2	=> s_7SegmentDisplayForClk2,
		o_7SegmentDisplayForBranch	=> s_7SegmentDisplayForBranch
	);

	process
	begin
		wait for 40ns;

		s_onOff		<= '1';
		for i in 0 to 39 loop
			s_clk	<= '1';
			wait for 20ns;
			s_clk	<= '0';
			wait for 20ns;
		end loop;
		
		assert false
			report "Simulation Done"
			severity failure;
	end process;

end Behavioral;
