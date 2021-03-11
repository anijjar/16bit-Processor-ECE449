LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY MEMWB_LATCH_TB IS END MEMWB_LATCH_TB;

ARCHITECTURE behavioural OF MEMWB_LATCH_TB IS
    COMPONENT MEMWB_LATCH PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_reg_wb : IN STD_LOGIC;
        in_ar : in std_logic_vector(16 downto 0);
        in_ra : in std_logic_vector(2 downto 0);
        -- matching output signals
        out_reg_wb : out STD_LOGIC;
        out_ar : out std_logic_vector(16 downto 0);
        out_ra : out std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    signal rst         : std_logic := '0';
    signal clk         : std_logic := '0';
    signal in_reg_wb   : std_logic := '0';
    signal in_ar       : std_logic_vector(16 downto 0) := (others => '0');
    signal in_ra       : std_logic_vector(2 downto 0) := (others => '0');
    signal out_reg_wb  : std_logic := '0';
    signal out_ar      : std_logic_vector(16 downto 0) := (others => '0');
    signal out_ra      : std_logic_vector(2 downto 0) := (others => '0');
BEGIN
    u0 : MEMWB_LATCH PORT MAP
    (
        rst         , 
        clk         , 
        in_reg_wb   ,
        in_ar       ,
        in_ra       ,
        out_reg_wb  ,    
        out_ar      ,
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
        in_reg_wb   <= '0';
        in_ar       <= (others => '0');
        in_ra       <= (others => '0');
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '0' AND clk'event);
        in_reg_wb   <= '1';
        in_ar       <= '0'&X"00FF";
        in_ra       <= "101";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_reg_wb   <= '0';
        in_ar       <= '0'&X"FF00";
        in_ra       <= "010";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_reg_wb   <= '1';
        in_ar       <= '0'&X"00FF";
        in_ra       <= "101";
        WAIT;
    END PROCESS;
END behavioural;