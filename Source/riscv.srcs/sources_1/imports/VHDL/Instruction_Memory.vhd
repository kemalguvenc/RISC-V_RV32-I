library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Memory is
	port (
		i_dataAdress		: in std_logic_vector(31 downto 0)	:= (others => '0');

		o_readData			: out std_logic_vector(31 downto 0)	:= (others => '0')
	);
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

type MemoryArray is array (0 to 1*(2**10 - 1)) of std_logic_vector (7 downto 0);
signal memory		: MemoryArray	:= (others => (others => '0') );

begin
	memory(0 to 19)	<= (
		x"93", x"00", x"10", x"00",
		x"23", x"00", x"10", x"00",
		x"03", x"01", x"00", x"00",
		x"33", x"00", x"00", x"00",
		x"23", x"00", x"21", x"00"
		--x"93", x"00", x"60", x"00",	-- addi x1,x0,6
		--x"b3", x"80", x"10", x"00",	-- add x1,x1,x1
		--x"b3", x"80", x"10", x"00",	-- add x1,x1,x1
		--x"b3", x"80", x"10", x"00",	-- add x1,x1,x1
		--x"13", x"01", x"20", x"00",	-- addi x2,x0,2
		--x"b3", x"81", x"20", x"00",	-- add x3,x1,x2
		--x"b3", x"81", x"20", x"40",	-- sub x3,x1,x2
		--x"b3", x"f1", x"20", x"00",	-- and x3,x1,x2
		--x"b3", x"e1", x"20", x"00",	-- or x3,x1,x2
		--x"b3", x"c1", x"20", x"00",	-- xor x3,x1,x2
		--x"b3", x"91", x"20", x"00",	-- sll x3,x1,x2
		--x"b3", x"d1", x"20", x"00",	-- srl x3,x1,x2
		--x"b3", x"a1", x"20", x"00",	-- slt x3,x1,x2
		--x"93", x"81", x"40", x"00",	-- addi x3,x1,4
		--x"93", x"f1", x"40", x"00",	-- andi x3,x1,4
		--x"93", x"e1", x"40", x"00",	-- ori x3,x1,4
		--x"93", x"c1", x"40", x"00",	-- xori x3,x1,4
		--x"93", x"91", x"40", x"00",	-- slli x3,x1,4
		--x"93", x"d1", x"40", x"00",	-- srli x3,x1,4
		--x"93", x"a1", x"40", x"00",	-- slti x3,x1,4
		--x"b3", x"91", x"20", x"0a",	-- hmdst x3,x1,x2
		--x"b3", x"c1", x"20", x"08",	-- pkg x3,x1,x2
		--x"93", x"d1", x"80", x"6b",	-- rvrs x3,x1
		--x"b3", x"a1", x"20", x"20",	-- sladd x3,x1,x2
		--x"93", x"91", x"10", x"60",	-- cntz x3,x1
		--x"93", x"91", x"20", x"60"	-- cntp x3,x1

		--x"b7", x"11", x"10", x"10", -- lui x3,0x10101
		--x"93", x"81", x"01", x"01", -- addi x3,x3,0x010
		--x"00", x"01", x"82", x"b3", -- add x5,x3,x0
		--x"23", x"00", x"30", x"00", -- sb x3,0(x0)
		--x"93", x"d1", x"81", x"00", -- srli x3,x3,8
		--x"a3", x"00", x"30", x"00", -- sb x3,1(x0)
		--x"93", x"d1", x"81", x"00", -- srli x3,x3,8
		--x"23", x"01", x"30", x"00", -- sb x3,2(x0)
		--x"93", x"d1", x"81", x"00", -- srli x3,x3,8
		--x"a3", x"01", x"30", x"00", -- sb x3,3(x0)
		--x"03", x"22", x"00", x"00", -- lw x4,0(x0)
		--x"b3", x"21", x"52", x"00", -- slt x3,x4,x5
		--x"b7", x"a1", x"a0", x"a0", -- lui x3,0xA0A0A
		--x"93", x"81", x"01", x"0a", -- addi x3,x3,0x0A0
		--x"00", x"01", x"82", x"b3", -- add x5,x3,x0
		--x"23", x"12", x"30", x"00", -- sh x3,4(x0)
		--x"93", x"d1", x"01", x"01", -- srli x3,x3,16
		--x"23", x"13", x"30", x"00", -- sh x3,6(x0)
		--x"03", x"22", x"00", x"00", -- lw x4,0(x0)
		--x"b3", x"21", x"52", x"00", -- slt x3,x4,x5
		--x"b7", x"11", x"11", x"11", -- lui x3,0x11111
		--x"93", x"81", x"11", x"11", -- addi x3,x3,0x111
		--x"00", x"01", x"82", x"b3", -- add x5,x3,x0
		--x"23", x"24", x"30", x"00", -- sw x3,8(x0)
		--x"03", x"22", x"00", x"00", -- lw x4,0(x0)
		--x"b3", x"21", x"52", x"00", -- slt x3,x4,x5
		--x"83", x"01", x"00", x"00", -- lb x3,0(x0)
		--x"83", x"11", x"40", x"00", -- lh x3,4(x0)
		--x"83", x"21", x"80", x"00", -- lw x3,8(x0)
		--x"97", x"01", x"00", x"00" -- auipc x3,0

		--x"93", x"01", x"00", x"00", -- addi x3,x0,0
		--x"13", x"02", x"10", x"00", -- addi x4,x0,1
		--x"93", x"02", x"b0", x"00", -- addi x5,x0,11
		--x"b3", x"81", x"41", x"00", -- add x3,x3,x4
		--x"13", x"02", x"12", x"00", -- addi x4,x4,1
		--x"e3", x"1c", x"52", x"fe"  -- bne x4,x5,loop
	);

	o_readData 	 <= memory(conv_integer(i_dataAdress) + 3) & memory(conv_integer(i_dataAdress) + 2) & memory(conv_integer(i_dataAdress) + 1) & memory(conv_integer(i_dataAdress));
end Behavioral;
