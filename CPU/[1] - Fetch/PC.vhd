-- LIBRARY ieee;
-- USE ieee.std_logic_1164.ALL;

-- ENTITY PC IS
--    GENERIC (
--       N : INTEGER := 16
--    );
--    PORT (
--       clk : IN STD_LOGIC;
--       rst : IN STD_LOGIC;

--       input : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
--       output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
--    );        
-- END PC;

-- ARCHITECTURE behav OF PC IS
--    SIGNAL reg : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
-- BEGIN
--    PROCESS (clk, rst)
--    BEGIN
--       IF (rising_edge(clk)) THEN
--          IF (rst = '1') THEN
--             reg <= (OTHERS => '0');
--          END IF
--          ELSE 
--             reg <= input;
--       END IF
--    END PROCESS
--    --asynchronously output the register contents
--    output <= reg;
-- END behav;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use IEEE.numeric_std.all;

ENTITY PC_16 IS
    PORT (
        clk  : in  std_logic;
        con  : in  std_logic_vector(1 downto 0);
        pc_i : in  std_logic_vector(15 downto 0);
        pc_o : out std_logic_vector(15 downto 0)
        );
END PC_16;

ARCHITECTURE behavioural OF PC_16 IS
    SIGNAL pc : std_logic_vector(15 downto 0) := X"0000";
BEGIN
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            case con is
                -- increment PC
                when "00" =>
                pc <= std_logic_vector(unsigned(pc) + X"0002"); -- 2 for btye addressable
                -- do not increment PC
                when "01" =>
                    -- no action required
                -- Set PC to external value (for jumps)
                when "10" =>
                    pc <= pc_i;
                -- reset, set PC to program start
                when "11" =>
                    pc <= X"0000";
                when others =>
            end case;
        END if;
    END PROCESS; 

    pc_o <= pc;

END behavioural;