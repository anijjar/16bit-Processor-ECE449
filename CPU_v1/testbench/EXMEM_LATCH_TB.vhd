LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY EXMEM_LATCH_TB IS END EXMEM_LATCH_TB;

ARCHITECTURE behavioural OF EXMEM_LATCH_TB IS
    COMPONENT EXMEM_LATCH PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_ar       : in  std_logic_vector(16 downto 0); --ALU RESULT
        in_regwb    : in  std_logic; -- REGISTER OPRAND
        in_memwb    : in  std_logic; -- MEMORY OPRAND
        in_ra       : in  std_logic_vector(2  downto 0);
        -- matching output signals
        out_ar      : out std_logic_vector(16 downto 0);
        out_regwb   : out std_logic;
        out_memwb   : out std_logic;
        out_ra      : out std_logic_vector(2  downto 0)
        );
    END COMPONENT;
    signal rst         : STD_LOGIC := '0';
    signal clk         : STD_LOGIC := '0';
    signal in_ar       : std_logic_vector(16 downto 0) := (others => '0'); 
    signal in_regwb    : std_logic := '0'; 
    signal in_memwb    : std_logic := '0'; 
    signal in_ra       : std_logic_vector(2  downto 0) := (others => '0');
    signal out_ar      : std_logic_vector(16 downto 0) := (others => '0');
    signal out_regwb   : std_logic := '0';
    signal out_memwb   : std_logic := '0';
    signal out_ra      : std_logic_vector(2  downto 0) := (others => '0');
BEGIN
    u0 : EXMEM_LATCH PORT MAP
    (
        rst         , 
        clk         , 
        in_ar       ,
        in_regwb    , 
        in_memwb    ,
        in_ra       ,
        out_ar      ,
        out_regwb   ,
        out_memwb   ,
        out_ra      
    );
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst <= '1';
        in_ar       <= (others => '0');
        in_regwb    <= '0'; 
        in_memwb    <= '0';
        in_ra       <= (others => '0');
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '0' AND clk'event);
        in_ar       <= '0'&X"00FF";
        in_regwb    <= '1'; 
        in_memwb    <= '1';
        in_ra       <= "101";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_ar       <= '0'&X"FF00";
        in_regwb    <= '0'; 
        in_memwb    <= '0';
        in_ra       <= "010";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_ar       <= '0'&X"00FF";
        in_regwb    <= '1'; 
        in_memwb    <= '1';
        in_ra       <= "101";
        WAIT;
    END PROCESS;
END behavioural;