LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY PC IS
    PORT (
        clk    : in  std_logic;
        rst    : in  std_logic;
        state  : in  std_logic_vector(1 downto 0);
        input  : in  std_logic_vector(15 downto 0);
        output : out std_logic_vector(15 downto 0)
        );
END PC;

ARCHITECTURE behavioural OF PC IS
    SIGNAL pc : std_logic_vector(15 downto 0) := X"0000";
BEGIN
    PROCESS(clk, rst, state, input)
    BEGIN
        if (rising_edge(clk)) THEN
            case state is
               -- increment PC
               when "00" =>
               pc <= std_logic_vector(unsigned(pc) + X"0002"); -- 2 for btye addressable
               -- do not increment PC
               when "01" =>
                  -- no action required
               -- Set PC to external value (for jumps)
               when "10" =>
                  pc <= input;
               -- reset, set PC to program start
               when "11" =>
                  pc <= X"0000";
               when others =>
            end case;
        END if;
    END PROCESS; 

    output <= pc;

END behavioural;