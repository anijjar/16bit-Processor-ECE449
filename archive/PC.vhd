LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY PC IS
    PORT (
        clk    : in STD_LOGIC;
        state  : in  std_logic_vector(1 downto 0);
        input  : in  std_logic_vector(12 downto 0);
        output : out std_logic_vector(12 downto 0)
        );
END PC;

ARCHITECTURE behavioural OF PC IS
    SIGNAL pc : std_logic_vector(12 downto 0) := (others => '0'); -- RAM address shouyld be at most 13 bits long
BEGIN
    PROCESS(clk, state, input, pc)
    BEGIN
    if(rising_edge(clk)) then --removing this causes 2 jumps per clock cycle
      case state is
         -- do not increment
         when "00" =>
            -- no action required
         -- increment PC
         when "01" =>
             pc <= std_logic_vector(unsigned(pc) + 1);
         -- Set PC to external value (for jumps)
         when "10" =>
            pc <= input;
         -- reset, set PC to program start
         when "11" =>
            pc <= '0' & X"000";
         when others => null;
       end case;
    end if;
     output <= pc;
    END PROCESS;

END behavioural;