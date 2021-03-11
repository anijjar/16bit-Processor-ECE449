LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY EXECUTE_STAGE_TB IS END EXECUTE_STAGE_TB;

ARCHITECTURE behavioural OF EXECUTE_STAGE_TB IS
    COMPONENT EXECUTE_STAGE PORT (
        rst       : in  std_logic;
        usr_input : in  std_logic_vector(15 downto 0);
        usr_flag  : in  std_logic;
        RD1       : in  std_logic_vector(16 downto 0);
        RD2       : in  std_logic_vector(16 downto 0);
        alumode   : in  std_logic_vector( 2 downto 0);
        AR        : out std_logic_vector(16 downto 0);
        z_flag    : out std_logic;
        n_flag    : out std_logic;
        in_memwb  : in  std_logic;
        out_memwb : out std_logic;
        in_regwb  : in  std_logic;
        out_regwb : out std_logic;
        in_rdst   : in  std_logic_vector( 2 downto 0);
        out_rdst  : out std_logic_vector( 2 downto 0)
        );
    END COMPONENT;
    signal rst       : std_logic := '0';
    signal clk       : std_logic := '0';
    signal usr_input : std_logic_vector(15 downto 0) := (others => '0');
    signal usr_flag  : std_logic := '0';
    signal RD1       : std_logic_vector(16 downto 0) := (others => '0');
    signal RD2       : std_logic_vector(16 downto 0) := (others => '0');
    signal alumode   : std_logic_vector( 2 downto 0) := (others => '0');
    signal AR        : std_logic_vector(16 downto 0) := (others => '0');
    signal z_flag    : std_logic := '0';
    signal n_flag    : std_logic := '0';
    signal in_memwb  : std_logic := '0';
    signal out_memwb : std_logic := '0';
    signal in_regwb  : std_logic := '0';
    signal out_regwb : std_logic := '0';
    signal in_rdst   : std_logic_vector( 2 downto 0) := (others => '0');
    signal out_rdst  : std_logic_vector( 2 downto 0) := (others => '0');
BEGIN
    u0 : EXECUTE_STAGE PORT MAP
    (
        rst       ,
        usr_input ,
        usr_flag  ,
        RD1       ,
        RD2       ,
        alumode   ,
        AR        ,
        z_flag    ,
        n_flag    ,
        in_memwb  ,
        out_memwb ,
        in_regwb  ,
        out_regwb ,
        in_rdst   ,
        out_rdst    
    );
    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst <= '1';
        usr_input <= (others => '0');
        usr_flag  <= '0';
        RD1       <= (others => '0');
        RD2       <= (others => '0');
        alumode   <= (others => '0');
        in_memwb  <= '0';
        in_regwb  <= '0';
        in_rdst   <= (others => '0');
        WAIT UNTIL (clk = '0' AND clk'event);
        WAIT UNTIL (clk = '1' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "001";
        in_memwb  <= '0';
        in_regwb  <= '1';
        in_rdst   <= "110";
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "010";
        in_memwb  <= '1';
        in_regwb  <= '0';
        in_rdst   <= "101";
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "011";
        in_rdst   <= "100";
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "100";
        in_rdst   <= "011";
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "101";
        in_rdst   <= "010";
        WAIT UNTIL (clk = '1' AND clk'event);
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "110";
        in_rdst   <= "001";
        WAIT UNTIL (clk = '1' AND clk'event);
        usr_input <= (others => '1');
        usr_flag  <= '1';
        RD1       <= '0'&X"0001";
        RD2       <= '0'&X"0002";
        alumode   <= "001";
        in_rdst   <= "001";
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT;
    END PROCESS;
END behavioural;