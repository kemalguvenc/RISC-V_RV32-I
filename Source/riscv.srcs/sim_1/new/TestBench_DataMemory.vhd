library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_DataMemory is
end TestBench_DataMemory;

architecture Behavioral of TestBench_DataMemory is

component Data_Memory is
	port (
		i_clk				: in std_logic;
		i_address			: in std_logic_vector(31 downto 0);
		i_dataSize			: in std_logic_vector(1 downto 0);
		i_dataType			: in std_logic;
		i_readWriteControl	: in std_logic;
		i_data				: in std_logic_vector(31 downto 0);

		o_data				: out std_logic_vector(31 downto 0)
	);
end component;

signal clk				: std_logic						:= '0';
signal address			: std_logic_vector(31 downto 0)	:= (others => '0');
signal dataSize			: std_logic_vector(1 downto 0)	:= (others => '0');
signal dataType			: std_logic						:= '0';
signal readWriteControl	: std_logic						:= '0';
signal i_data			: std_logic_vector(31 downto 0)	:= (others => '0');
signal o_data			: std_logic_vector(31 downto 0)	:= (others => '0');

begin

	DM : Data_Memory
	port map(
		i_clk				=> clk,
		i_address			=> address,
		i_dataSize			=> dataSize,
		i_dataType			=> dataType,
		i_readWriteControl	=> readWriteControl,
		i_data				=> i_data,
		o_data				=> o_data
	);

	test : process
	begin
		wait for 20 ns;
		
		address				<= x"00000000";
		dataSize			<= b"10";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"00000000";
		dataSize			<= b"00";
		i_data				<= x"10101010";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"00000001";
		dataSize			<= b"01";
		i_data				<= x"10101010";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"00000003";
		dataSize			<= b"10";
		i_data				<= x"10101010";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"00000007";
		dataSize			<= b"10";
		i_data				<= x"01010101";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"0000000B";
		dataSize			<= b"01";
		i_data				<= x"01010101";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"0000000D";
		dataSize			<= b"00";
		i_data				<= x"01010101";
		readWriteControl	<= '1';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;
		
		address				<= x"0000000D";
		dataSize			<= b"00";
		dataType			<= '0';
		readWriteControl	<= '0';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;
		
		address				<= x"00000000";
		dataSize			<= b"00";
		dataType			<= '0';
		readWriteControl	<= '0';
		clk					<= '1';
		wait for 10 ns;
		clk					<= '0';
		wait for 10 ns;

		address				<= x"00000001";
		dataSize			<= b"01";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"00000003";
		dataSize			<= b"10";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;
		
		address				<= x"00000007";
		dataSize			<= b"00";
		dataType			<= '1';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"0000000B";
		dataSize			<= b"01";
		dataType			<= '1';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"0000000D";
		dataSize			<= b"10";
		dataType			<= '1';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"0000000D";
		dataSize			<= b"10";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"00000001";
		dataSize			<= b"00";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"00000002";
		dataSize			<= b"01";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"00000005";
		dataSize			<= b"10";
		dataType			<= '0';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"0000000A";
		dataSize			<= b"00";
		dataType			<= '1';
		readWriteControl	<= '0';
		wait for 20 ns;

		address				<= x"0000000C";
		dataSize			<= b"01";
		dataType			<= '1';
		readWriteControl	<= '0';
		wait for 20 ns;


		assert false
		report "Simulation Done"
		severity failure;

	end process;

end Behavioral;
