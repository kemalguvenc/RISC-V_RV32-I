library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_DataForwarder is
end TestBench_DataForwarder;

architecture Behavioral of TestBench_DataForwarder is

component DataForwarder is
	port ( 
		i_rs1A					: in std_logic_vector (4 downto 0);
		i_rs2A					: in std_logic_vector (4 downto 0);
		i_verificationForThird	: in std_logic;
		i_rdForThird			: in std_logic_vector (4 downto 0);
		i_dataForThird			: in std_logic_vector (31 downto 0);
		i_verificationForFourth	: in std_logic;
		i_rdForFourth			: in std_logic_vector (4 downto 0);
		i_dataForFourth			: in std_logic_vector (31 downto 0);
		i_verificationForFifth	: in std_logic;
		i_rdForFifth			: in std_logic_vector (4 downto 0);
		i_dataForFifth			: in std_logic_vector (31 downto 0);

		o_dataForwardForFirst	: out std_logic;
		o_dataForwardForSecond	: out std_logic;
		o_registerDataForFirst	: out std_logic_vector (31 downto 0);
		o_registerDataForSecond	: out std_logic_vector (31 downto 0)
		);
end component;

signal rs1A					: std_logic_vector (4 downto 0)	:= (others => '0');
signal rs2A					: std_logic_vector (4 downto 0)	:= (others => '0');
signal verificationForThird	: std_logic						:= '0';
signal rdForThird			: std_logic_vector (4 downto 0)	:= (others => '0');
signal dataForThird			: std_logic_vector (31 downto 0):= (others => '0');
signal verificationForFourth: std_logic						:= '0';
signal rdForFourth			: std_logic_vector (4 downto 0)	:= (others => '0');
signal dataForFourth		: std_logic_vector (31 downto 0):= (others => '0');
signal verificationForFifth	: std_logic						:= '0';
signal rdForFifth			: std_logic_vector (4 downto 0)	:= (others => '0');
signal dataForFifth			: std_logic_vector (31 downto 0):= (others => '0');

signal dataForwardForFirst	: std_logic						:= '0';
signal dataForwardForSecond	: std_logic						:= '0';
signal registerDataForFirst	: std_logic_vector (31 downto 0):= (others => '0');
signal registerDataForSecond: std_logic_vector (31 downto 0):= (others => '0');

begin

	DF : DataForwarder
	port map(
		i_rs1A					=> rs1A,
		i_rs2A					=> rs2A,
		i_verificationForThird	=> verificationForThird,
		i_rdForThird			=> rdForThird,
		i_dataForThird			=> dataForThird,
		i_verificationForFourth	=> verificationForFourth,
		i_rdForFourth			=> rdForFourth,
		i_dataForFourth			=> dataForFourth,
		i_verificationForFifth	=> verificationForFifth,
		i_rdForFifth			=> rdForFifth,
		i_dataForFifth			=> dataForFifth,
				
		o_dataForwardForFirst	=> dataForwardForFirst,
		o_dataForwardForSecond	=> dataForwardForSecond,
		o_registerDataForFirst	=> registerDataForFirst,
		o_registerDataForSecond	=> registerDataForSecond
	);

	test : process
	begin
		wait for 20 ns;

		rs1A					<= b"00000";
		rs2A					<= b"00001";
		dataForThird			<= x"10101010";
		dataForFourth			<= x"01010101";
		dataForFifth			<= x"11001100";

		verificationForThird	<= '1';
		verificationForFourth	<= '1';
		verificationForFifth	<= '1';
		-- 1
		rdForThird				<= b"00000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '1' or dataForwardForSecond /= '0' or registerDataForFirst /= x"10101010"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		rdForThird				<= b"00010";
		rdForFourth				<= b"00000";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '1' or dataForwardForSecond /= '0' or registerDataForFirst /= x"01010101"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		rdForThird				<= b"10000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"00000";
		wait for 20 ns;

		if dataForwardForFirst /= '1' or dataForwardForSecond /= '0' or registerDataForFirst /= x"11001100"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		-- 2
		verificationForThird	<= '0';
		verificationForFourth	<= '1';
		verificationForFifth	<= '1';
		rdForThird				<= b"00000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0'  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		verificationForThird	<= '1';
		verificationForFourth	<= '0';
		verificationForFifth	<= '1';
		rdForThird				<= b"00010";
		rdForFourth				<= b"00000";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0' then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		verificationForThird	<= '1';
		verificationForFourth	<= '1';
		verificationForFifth	<= '0';
		rdForThird				<= b"10000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"00000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0' then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		rs1A					<= b"00001";
		rs2A					<= b"00000";

		verificationForThird	<= '1';
		verificationForFourth	<= '1';
		verificationForFifth	<= '1';
		-- 3
		rdForThird				<= b"00000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '1' or registerDataForSecond /= x"10101010"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		rdForThird				<= b"00010";
		rdForFourth				<= b"00000";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '1' or registerDataForSecond /= x"01010101"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		rdForThird				<= b"10000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"00000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '1' or registerDataForSecond /= x"11001100"  then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		-- 4
		verificationForThird	<= '0';
		verificationForFourth	<= '1';
		verificationForFifth	<= '1';
		rdForThird				<= b"00000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0' then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		verificationForThird	<= '1';
		verificationForFourth	<= '0';
		verificationForFifth	<= '1';
		rdForThird				<= b"00010";
		rdForFourth				<= b"00000";
		rdForFifth				<= b"10000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0' then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		verificationForThird	<= '1';
		verificationForFourth	<= '1';
		verificationForFifth	<= '0';
		rdForThird				<= b"10000";
		rdForFourth				<= b"00010";
		rdForFifth				<= b"00000";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '0' then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;

		-- 5
		verificationForThird	<= '1';
		verificationForFourth	<= '1';
		verificationForFifth	<= '1';
		rs1A					<= b"00000";
		rs2A					<= b"00001";

		rdForThird				<= b"00000";
		rdForFourth				<= b"00000";
		rdForFifth				<= b"00000";
		wait for 20 ns;

		if dataForwardForFirst /= '1' or dataForwardForSecond /= '0' or registerDataForFirst /= x"10101010" then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;
		
		rdForThird				<= b"00001";
		rdForFourth				<= b"00001";
		rdForFifth				<= b"00001";
		wait for 20 ns;

		if dataForwardForFirst /= '0' or dataForwardForSecond /= '1' or registerDataForSecond /= x"10101010" then
			assert false
			report "Simulation Failed"
			severity failure;
		end if;
		
		assert false
			report "Simulation Done"
			severity failure;
	end process;

end Behavioral;
