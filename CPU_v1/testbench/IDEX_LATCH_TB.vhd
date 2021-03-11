LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY IDEX_LATCH_TB IS END IDEX_LATCH_TB;

ARCHITECTURE behavioural OF IDEX_LATCH_TB IS
    COMPONENT IDEX_LATCH PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_dr1       : in  std_logic_vector(16 downto 0);
        in_dr2       : in  std_logic_vector(16 downto 0);
        in_alumode   : in  std_logic_vector(2  downto 0);
        in_regwb     : in  std_logic;
        in_memwb     : in  std_logic;
        in_usr_flag  : in  std_logic;
        in_ra        : in  std_logic_vector(2  downto 0);
        -- matching output signals
        out_dr1      : out std_logic_vector(16 downto 0);
        out_dr2      : out std_logic_vector(16 downto 0);
        out_alumode  : out std_logic_vector(2  downto 0);
        out_regwb    : out std_logic;
        out_memwb    : out std_logic;
        out_usr_flag : out std_logic;
        out_ra       : out std_logic_vector(2  downto 0)
        );
    END COMPONENT;
    signal rst          : STD_LOGIC := '0';
    signal clk          : STD_LOGIC := '0';
    signal in_dr1       : std_logic_vector(16 downto 0) := (others => '0');
    signal in_dr2       : std_logic_vector(16 downto 0) := (others => '0');
    signal in_alumode   : std_logic_vector(2  downto 0) := (others => '0');
    signal in_regwb     : std_logic := '0';
    signal in_memwb     : std_logic := '0';
    signal in_usr_flag  : std_logic := '0';
    signal in_ra        : std_logic_vector(2  downto 0) := (others => '0');
    signal out_dr1      : std_logic_vector(16 downto 0) := (others => '0');
    signal out_dr2      : std_logic_vector(16 downto 0) := (others => '0');
    signal out_alumode  : std_logic_vector(2  downto 0) := (others => '0');
    signal out_regwb    : std_logic := '0';
    signal out_memwb    : std_logic := '0';
    signal out_usr_flag : std_logic := '0';
    signal out_ra       : std_logic_vector(2  downto 0) := (others => '0');
BEGIN
    u0 : IDEX_LATCH PORT MAP
    (
        rst, 
        clk, 
        in_dr1       ,
        in_dr2       ,
        in_alumode   ,
        in_regwb     ,
        in_memwb     ,
        in_usr_flag  ,
        in_ra        ,
        out_dr2      ,
        out_alumode  ,
        out_regwb    ,
        out_memwb    ,
        out_usr_flag ,
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
        in_dr1       <= (others => '0');
        in_dr2       <= (others => '0');
        in_alumode   <= (others => '0');
        in_regwb     <= '0';
        in_memwb     <= '0';
        in_usr_flag  <= '0';
        in_ra        <= (others => '0');
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '0' AND clk'event);
        in_dr1       <= '0'&X"00FF";
        in_dr2       <= '0'&X"FF00";
        in_alumode   <= "010";
        in_regwb     <= '1';
        in_memwb     <= '0';
        in_usr_flag  <= '1';
        in_ra        <= "101";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_dr1       <= '0'&X"FF00";
        in_dr2       <= '0'&X"00FF";
        in_alumode   <= "101";
        in_regwb     <= '0';
        in_memwb     <= '1';
        in_usr_flag  <= '0';
        in_ra        <= "010";
        WAIT UNTIL (clk = '0' AND clk'event);
        in_dr1       <= '0'&X"00FF";
        in_dr2       <= '0'&X"FF00";
        in_alumode   <= "010";
        in_regwb     <= '1';
        in_memwb     <= '0';
        in_usr_flag  <= '1';
        in_ra        <= "101";
        WAIT;
    END PROCESS;
END behavioural;