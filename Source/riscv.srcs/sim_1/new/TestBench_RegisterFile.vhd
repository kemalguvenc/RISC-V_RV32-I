library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_RegisterFile is
end TestBench_RegisterFile;

architecture Behavioral of TestBench_RegisterFile is

component Register_File is
	port(
		i_rs1Adress		: in std_logic_vector(4 downto 0);
		i_rs2Adress		: in std_logic_vector(4 downto 0);
		i_rdAdress		: in std_logic_vector(4 downto 0);
		i_rdData		: in std_logic_vector(31 downto 0);
		i_controlWrite	: in std_logic;

		o_rs1Data		: out std_logic_vector(31 downto 0);
		o_rs2Data		: out std_logic_vector(31 downto 0)
	);
end component;

signal rs1Adress	: std_logic_vector(4 downto 0)	:= "00000";
signal rs2Adress	: std_logic_vector(4 downto 0)	:= "00000";
signal rdAdress		: std_logic_vector(4 downto 0)	:= "00000";
signal rdData		: std_logic_vector(31 downto 0)	:= x"00000000";
signal controlWrite	: std_logic						:= '0';
signal rs1Data		: std_logic_vector(31 downto 0);
signal rs2Data		: std_logic_vector(31 downto 0);

begin

	RF : Register_File
	port map(
		i_rs1Adress		=> rs1Adress,
		i_rs2Adress		=> rs2Adress,
		i_rdAdress		=> rdAdress	,
		i_rdData		=> rdData,
		i_controlWrite	=> controlWrite,
		o_rs1Data		=> rs1Data,
		o_rs2Data		=> rs2Data
	);

	test : process
	begin
		
		wait for 10 ns;

		rs1Adress		<= "00011";			-- 3.Register
		rs2Adress		<= "01001";			-- 9.Register

		rdAdress		<= "00011";			-- 3.Register
		rdData			<= x"12345678";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		rdAdress		<= "01001";			-- 9.Register
		rdData			<= x"87654321";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		rs1Adress		<= "00011";			-- 3.Register
		rs2Adress		<= "11110";			-- 30.Register

		rdAdress		<= "00011";			-- 3.Register
		rdData			<= x"18273645";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		rdAdress		<= "11110";			-- 30.Register
		rdData			<= x"11111111";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		rs1Adress		<= "00000";			-- 0.Register
		rs2Adress		<= "10101";			-- 21.Register

		rdAdress		<= "00000";			-- 0.Register
		rdData			<= x"18273645";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		rdAdress		<= "10101";			-- 21.Register
		rdData			<= x"10101010";
		controlWrite	<= '1';
		wait for 10 ns;
		controlWrite	<= '0';
		wait for 10 ns;

		assert false
			report "Simulation Done"
			severity failure;

	end process;

end Behavioral;
