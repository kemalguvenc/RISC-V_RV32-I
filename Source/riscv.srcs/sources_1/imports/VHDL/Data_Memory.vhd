library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Memory is
	port (
		i_clk				: in std_logic						:= '0';					-- Clock Signal
		i_address			: in std_logic_vector(31 downto 0)	:= (others => '0');
		i_dataSize			: in std_logic_vector(1 downto 0)	:= (others => '0');		-- 00/01/10/11	=> 8/16/32/Undefined
		i_dataType			: in std_logic						:= '0';					-- 0/1			=> Unsigned/Signed		Just For Reading
		i_readWriteControl	: in std_logic						:= '0';					-- 0/1			=> Read/Write
		i_data				: in std_logic_vector(31 downto 0)	:= (others => '0');		-- Just For Writing

		o_data				: out std_logic_vector(31 downto 0)	:= (others => '0') 		-- Just For Reading
	);
end Data_Memory;

architecture Behavioral of Data_Memory is

type MemoryArray is array (0 to 1*(2**8 - 1)) of std_logic_vector (7 downto 0);

signal s_memoryModule	: std_logic_vector(1 downto 0)	:= (others => '0');
signal memory0			: MemoryArray					:= (others => (others => '0') );
signal memory1			: MemoryArray					:= (others => (others => '0') );
signal memory2			: MemoryArray					:= (others => (others => '0') );
signal memory3			: MemoryArray					:= (others => (others => '0') );
signal s_mainaddress	: std_logic_vector(29 downto 0)	:= (others => '0');
signal s_addressPart0	: std_logic_vector(29 downto 0)	:= (others => '0');
signal s_addressPart1	: std_logic_vector(29 downto 0)	:= (others => '0');
signal s_addressPart2	: std_logic_vector(29 downto 0)	:= (others => '0');
signal s_addressPart3	: std_logic_vector(29 downto 0)	:= (others => '0');
signal s_readedData		: std_logic_vector(31 downto 0)	:= (others => '0');
signal s_writedData		: std_logic_vector(31 downto 0)	:= (others => '0');
signal s_size			: std_logic_vector(1 downto 0)	:= (others => '0');

begin
	s_memoryModule	<= i_address(1 downto 0);
	s_mainaddress	<= x"00000" & b"00" & i_address(9 downto 2);
	s_writedData	<= i_data;
	s_size			<= i_dataSize;

	process(all)
	begin
		case s_memoryModule is
			when b"00" => 
				s_addressPart0	<= s_mainaddress;
				s_addressPart1	<= s_mainaddress;
				s_addressPart2	<= s_mainaddress;
				s_addressPart3	<= s_mainaddress;
				s_readedData	<= memory3(conv_integer(s_addressPart3)) & memory2(conv_integer(s_addressPart2)) & memory1(conv_integer(s_addressPart1)) & memory0(conv_integer(s_addressPart0));
			when b"01" => 
				s_addressPart0	<= s_mainaddress + 1;
				s_addressPart1	<= s_mainaddress;
				s_addressPart2	<= s_mainaddress;
				s_addressPart3	<= s_mainaddress;
				s_readedData	<= memory0(conv_integer(s_addressPart0)) & memory3(conv_integer(s_addressPart3)) & memory2(conv_integer(s_addressPart2)) & memory1(conv_integer(s_addressPart1));
			when b"10" => 
				s_addressPart0	<= s_mainaddress + 1;
				s_addressPart1	<= s_mainaddress + 1;
				s_addressPart2	<= s_mainaddress;
				s_addressPart3	<= s_mainaddress;
				s_readedData	<= memory1(conv_integer(s_addressPart1)) & memory0(conv_integer(s_addressPart0)) & memory3(conv_integer(s_addressPart3)) & memory2(conv_integer(s_addressPart2));
			when b"11" => 
				s_addressPart0	<= s_mainaddress + 1;
				s_addressPart1	<= s_mainaddress + 1;
				s_addressPart2	<= s_mainaddress + 1;
				s_addressPart3	<= s_mainaddress;
				s_readedData	<= memory2(conv_integer(s_addressPart2)) & memory1(conv_integer(s_addressPart1)) & memory0(conv_integer(s_addressPart0)) & memory3(conv_integer(s_addressPart3));
			when others =>
		end case;
	end process;

	reading : process (all)
	begin
		if(i_readWriteControl = '0') then									-- Load
			if(s_size = b"10") then											-- 32 Bit
				o_data <= s_readedData;

			elsif(i_dataType = '0') then									-- Unsigned
				if(s_size = b"00") then										-- 8 Bit
					o_data(7 downto 0)	<= s_readedData(7 downto 0);
					o_data(31 downto 8)	<= (others => '0');

				else														-- 16 Bit
					o_data(15 downto 0)	<= s_readedData(15 downto 0);
					o_data(31 downto 16)<= (others => '0');
				end if;

			elsif(i_dataType = '1') then									-- Signed
				if(s_size = b"00") then										-- 8 Bit
					o_data(7 downto 0) <= s_readedData(7 downto 0);
					o_data(31 downto 8) <= (others => s_readedData(7));

				else														-- 16 Bit
					o_data(15 downto 0) <= s_readedData(15 downto 0);
					o_data(31 downto 16) <= (others => s_readedData(15));
				end if;
			end if;
		end if;
	end process;

	writing : process(i_clk)
	begin
		if(rising_edge(i_clk)) then
			if i_readWriteControl = '1' then
				if(s_size = b"00") then										-- 8 Bit Writing
					case s_memoryModule is
						when b"00" => 
							memory0(conv_integer(s_addressPart0))	<= s_writedData(7 downto 0);
						when b"01" => 
							memory1(conv_integer(s_addressPart1))	<= s_writedData(7 downto 0);
						when b"10" => 
							memory2(conv_integer(s_addressPart2))	<= s_writedData(7 downto 0);
						when b"11" => 
							memory3(conv_integer(s_addressPart3))	<= s_writedData(7 downto 0);
						when others =>
					end case;
				elsif(s_size = b"01") then									-- 16 Bit Writing
					case s_memoryModule is
						when b"00" => 
							memory0(conv_integer(s_addressPart0))	<= s_writedData(7 downto 0);
							memory1(conv_integer(s_addressPart1))	<= s_writedData(15 downto 8);
						when b"01" => 
							memory1(conv_integer(s_addressPart1))	<= s_writedData(7 downto 0);
							memory2(conv_integer(s_addressPart2))	<= s_writedData(15 downto 8);
						when b"10" => 
							memory2(conv_integer(s_addressPart2))	<= s_writedData(7 downto 0);
							memory3(conv_integer(s_addressPart3))	<= s_writedData(15 downto 8);
						when b"11" => 
							memory3(conv_integer(s_addressPart3))	<= s_writedData(7 downto 0);
							memory0(conv_integer(s_addressPart0))	<= s_writedData(15 downto 8);
						when others =>
					end case;
				elsif(s_size = b"10") then									-- 32 Bit Writing
					case s_memoryModule is
						when b"00" => 
							memory0(conv_integer(s_addressPart0))	<= s_writedData(7 downto 0);
							memory1(conv_integer(s_addressPart1))	<= s_writedData(15 downto 8);
							memory2(conv_integer(s_addressPart2))	<= s_writedData(23 downto 16);
							memory3(conv_integer(s_addressPart3))	<= s_writedData(31 downto 24);
						when b"01" => 
							memory1(conv_integer(s_addressPart1))	<= s_writedData(7 downto 0);
							memory2(conv_integer(s_addressPart2))	<= s_writedData(15 downto 8);
							memory3(conv_integer(s_addressPart3))	<= s_writedData(23 downto 16);
							memory0(conv_integer(s_addressPart0))	<= s_writedData(31 downto 24);
						when b"10" => 
							memory2(conv_integer(s_addressPart2))	<= s_writedData(7 downto 0);
							memory3(conv_integer(s_addressPart3))	<= s_writedData(15 downto 8);
							memory0(conv_integer(s_addressPart0))	<= s_writedData(23 downto 16);
							memory1(conv_integer(s_addressPart1))	<= s_writedData(31 downto 24);
						when b"11" => 
							memory3(conv_integer(s_addressPart3))	<= s_writedData(7 downto 0);
							memory0(conv_integer(s_addressPart0))	<= s_writedData(15 downto 8);
							memory1(conv_integer(s_addressPart1))	<= s_writedData(23 downto 16);
							memory2(conv_integer(s_addressPart2))	<= s_writedData(31 downto 24);
						when others =>
					end case;
				end if;				
			end if;
		end if;
	end process;

end Behavioral;
