LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.ALL;

ENTITY DECODE_STAGE_TB IS END DECODE_STAGE_TB;

ARCHITECTURE behavioural OF DECODE_STAGE_TB IS
    COMPONENT DECODE_STAGE PORT (
        rst      : in  std_logic;
        opcode   : in  std_logic_vector( 6 downto 0);
        ra       : in  std_logic_vector( 2 downto 0);
        rb       : in  std_logic_vector( 2 downto 0);
        rc       : in  std_logic_vector( 2 downto 0);
        RF1d     : in  std_logic_vector(16 downto 0);
        RF2d     : in  std_logic_vector(16 downto 0);
        RF1a     : out std_logic_vector( 2 downto 0);
        RF2a     : out std_logic_vector( 2 downto 0);
        RD1      : out std_logic_vector(16 downto 0);
        RD2      : out std_logic_vector(16 downto 0);
        alumode  : out std_logic_vector( 2 downto 0);
        memwb    : out std_logic;
        regwb    : out std_logic;
        usr_flag : out std_logic;
        rdst     : out std_logic_vector( 2 downto 0)
        );
    END COMPONENT;
    signal rst      : std_logic := '0';
    signal opcode   : std_logic_vector( 6 downto 0) := (others => '0');
    signal ra       : std_logic_vector( 2 downto 0) := (others => '0');
    signal rb       : std_logic_vector( 2 downto 0) := (others => '0');
    signal rc       : std_logic_vector( 2 downto 0) := (others => '0');
    signal RF1d     : std_logic_vector(16 downto 0) := (others => '0');
    signal RF2d     : std_logic_vector(16 downto 0) := (others => '0');
    signal RF1a     : std_logic_vector( 2 downto 0) := (others => '0');
    signal RF2a     : std_logic_vector( 2 downto 0) := (others => '0');
    signal RD1      : std_logic_vector(16 downto 0) := (others => '0');
    signal RD2      : std_logic_vector(16 downto 0) := (others => '0');
    signal alumode  : std_logic_vector( 2 downto 0) := (others => '0');
    signal memwb    : std_logic := '0';
    signal regwb    : std_logic := '0';
    signal usr_flag : std_logic := '0';
    signal rdst     : std_logic_vector( 2 downto 0);
    signal clk : std_logic := '0';
BEGIN
    u0 : DECODE_STAGE PORT MAP
    (
        rst      ,--=> rst,  
        opcode   ,--=> opcode,
        ra       ,--=> ra,
        rb       ,--=> rb,
        rc       ,--=> rc,
        RF1d     ,--=> s_rd_data1,
        RF2d     ,--=> s_rd_data2,
        RF1a     ,--=> s_rd_index1, 
        RF2a     ,--=> s_rd_index2,
        RD1      ,--=> RD1,
        RD2      ,--=> RD2,
        alumode  ,--=> alumode,
        memwb    ,--=> memwb,
        regwb    ,--=> regwb,
        usr_flag ,--=> usr_flag,
        rdst     --=> rdst
    );
--    rf_0 : entity work.register_file port map 
--    (
--        rst       => rst         ,
--        clk       => clk         ,
--        rd_index1 => s_rd_index1 ,
--        rd_index2 => s_rd_index2 ,
--        rd_data1  => s_rd_data1  ,
--        rd_data2  => s_rd_data2  ,
--        wr_index  => s_wr_index  ,
--        wr_data   => s_wr_data   ,
--        wr_enable => s_wr_enable
--    );
--    signal clk         : std_logic;
--    signal s_rd_index1 : std_logic_vector( 2 downto 0) := (others => '0');
--    signal s_rd_index2 : std_logic_vector( 2 downto 0) := (others => '0');
--    signal s_rd_data1  : std_logic_vector(16 downto 0) := (others => '0');
--    signal s_rd_data2  : std_logic_vector(16 downto 0) := (others => '0');
--    signal s_wr_index  : std_logic_vector( 2 downto 0) := (others => '0');
--    signal s_wr_data   : std_logic_vector(16 downto 0) := (others => '0');
--    signal s_wr_enable : std_logic := '0';

    PROCESS BEGIN
        clk <= '0';
        WAIT FOR 10 us;
        clk <= '1';
        WAIT FOR 10 us;
    END PROCESS;
    PROCESS BEGIN
        rst      <= '1';
        opcode   <= (others => '0');
        ra       <= (others => '0');
        rb       <= (others => '0');
        rc       <= (others => '0');
        RF1d     <= (others => '0');
        RF2d     <= (others => '0');
        WAIT UNTIL (clk = '1' AND clk'event);
        WAIT UNTIL (clk = '0' AND clk'event);
        rst <= '0';
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000001";
        ra       <= "000";
        rb       <= "001";
        rc       <= "010";
        RF1d     <= '0'&X"00FF";
        RF2d     <= '0'&X"FF00";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000010";
        ra       <= "001";
        rb       <= "010";
        rc       <= "011";
        RF1d     <= '0'&X"FF00";
        RF2d     <= '0'&X"00FF";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000011";
        ra       <= "010";
        rb       <= "011";
        rc       <= "100";
        RF1d     <= '0'&X"0002";
        RF2d     <= '0'&X"0003";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000100";
        ra       <= "001";
        rb       <= "010";
        rc       <= "011";
        RF1d     <= '0'&X"FF00";
        RF2d     <= '0'&X"00FF";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000101";
        ra       <= "111";
        rb       <= "001";
        rc       <= "010";
        RF1d     <= '0'&X"FFFF";
        RF2d     <= '0'&X"0000";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000110";
        ra       <= "010";
        rb       <= "001";
        rc       <= "101";
        RF1d     <= '0'&X"FFFF";
        RF2d     <= '0'&X"0000";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0000111";
        ra       <= "111";
        rb       <= "000";
        rc       <= "100";
        RF1d     <= '0'&X"AAAA";
        RF2d     <= '0'&X"0000";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0100000";
        ra       <= "111";
        rb       <= "000";
        rc       <= "000";
        RF1d     <= '0'&X"5555";
        RF2d     <= '0'&X"AAAA";
        WAIT UNTIL (clk = '1' AND clk'event);
        opcode   <= "0100001";
        ra       <= "000";
        rb       <= "111";
        rc       <= "111";
        RF1d     <= '0'&X"A5A5";
        RF2d     <= '0'&X"5A5A";
        WAIT;
    END PROCESS;
END behavioural;