library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity BranchPredictioner is
    port (
		i_clk			: in std_logic;
		i_instruction	: in std_logic_vector (31 downto 0);

		o_output    	: out std_logic_vector (31 downto 0)
	);
end BranchPredictioner;

architecture Behavioral of BranchPredictioner is

signal opcode		: std_logic_vector(6 downto 0)  := i_instruction(6 downto 0);
signal destination	: std_logic_vector(31 downto 0)	:= '0' & i_instruction(11 downto 8) & i_instruction(30 downto 25) & i_instruction(7) & i_instruction(31) & b"0000000000000000000";

begin

    process (opcode, destination)
    begin
        if(opcode = 1100011 and destination < 0) then
			o_output <= destination;
		else
			o_output <= x"00000004";
		end if;
    end process;

end Behavioral;
