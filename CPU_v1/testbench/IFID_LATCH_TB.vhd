LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY IFID_LATCH_TB IS END IFID_LATCH_TB;

ARCHITECTURE behavioural OF IFID_LATCH_TB IS
    COMPONENT IFID_LATCH PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- matching output signals
        out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_rb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_rc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    signal rst          : STD_LOGIC := '0';
    signal clk          : STD_LOGIC := '0';
    signal input        : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal out_opcode   : STD_LOGIC_VECTOR( 6 DOWNTO 0) := (others => '0');
    signal out_ra       : STD_LOGIC_VECTOR( 2 DOWNTO 0) := (others => '0');
    signal out_rb       : STD_LOGIC_VECTOR( 2 DOWNTO 0) := (others => '0');
    signal out_rc       : STD_LOGIC_VECTOR( 2 DOWNTO 0) := (others => '0');
BEGIN
    u0 : IFID_LATCH PORT MAP
    (
        rst         , 
        clk         , 
        input       ,
        out_opcode  ,
        out_ra      ,
        out_rb      , 
        out_rc      
    );
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst <= '1';
        input       <= (others => '0');
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '0' AND clk'event);
        input <= X"FE38";
        WAIT UNTIL (clk = '0' AND clk'event);
        input <= X"01C7";
        WAIT UNTIL (clk = '0' AND clk'event);
        input <= X"FE38";
        WAIT;
    END PROCESS;
END behavioural;