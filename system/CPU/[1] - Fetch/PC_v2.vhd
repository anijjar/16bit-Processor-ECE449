LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY PC_V2 IS
    PORT (
        clk    : IN STD_LOGIC;
        in_pc  : in  std_logic_vector(15 downto 0);
        out_pc : out std_logic_vector(15 downto 0)
        );        
END PC_V2;

ARCHITECTURE behavioural OF PC_V2 IS
    -- matching internals signals
    SIGNAL signal_pc : std_logic_vector(15 downto 0) := (others => '0');
    BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            signal_pc <= in_pc;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_pc <= signal_pc;
END behavioural;