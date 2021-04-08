LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY IDEX_LATCH IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_opcode    : in  std_logic_vector( 6 downto 0);
        in_dr1       : in  std_logic_vector(16 downto 0);
        in_dr2       : in  std_logic_vector(16 downto 0);
        in_alumode   : in  std_logic_vector( 2 downto 0);
        in_regwb     : in  std_logic;
        in_memwb     : in  std_logic;
        in_m1        : in  std_logic;
        in_memrd     : in  std_logic;
        in_usr_flag  : in  std_logic;
        in_ra        : in  std_logic_vector(2  downto 0);
        in_rb        : in  std_logic_vector(2  downto 0);
        in_rc        : in  std_logic_vector(2  downto 0);
        in_passthru       : in  std_logic_vector(16 downto 0);
        in_passthru_flag  : in  std_logic;
        in_fwd_flag       : in  std_logic_vector(1 downto 0);
        -- matching output signals
        out_opcode    : out std_logic_vector( 6 downto 0);
        out_dr1      : out std_logic_vector(16 downto 0);
        out_dr2      : out std_logic_vector(16 downto 0);
        out_alumode  : out std_logic_vector(2  downto 0);
        out_regwb    : out std_logic;
        out_memwb    : out std_logic;
        out_m1        : out std_logic;
        out_memrd     : out std_logic;
        out_usr_flag : out std_logic;
        out_ra       : out std_logic_vector(2  downto 0);
        out_rb       : out std_logic_vector(2  downto 0);
        out_rc       : out std_logic_vector(2  downto 0);
        out_passthru      : out std_logic_vector(16 downto 0);
        out_passthru_flag : out std_logic;
        out_fwd_flag      : out std_logic_vector(1 downto 0)
        );        
END IDEX_LATCH;

ARCHITECTURE behavioural OF IDEX_LATCH IS

    -- matching internals signals
    SIGNAL signal_opcode   : std_logic_vector( 6  downto 0) := (others => '0');
    SIGNAL signal_dr1      : std_logic_vector(16 downto 0) := (others => '0');
    SIGNAL signal_dr2      : std_logic_vector(16 downto 0) := (others => '0');
    SIGNAL signal_alumode  : std_logic_vector(2  downto 0) := (others => '0');
    SIGNAL signal_regwb    : std_logic := '0';
    SIGNAL signal_memwb    : std_logic := '0';
    SIGNAL signal_usr_flag : std_logic := '0';
    SIGNAL signal_ra       : std_logic_vector(2  downto 0) := "000";
    SIGNAL signal_rb       : std_logic_vector(2  downto 0) := "000";
    SIGNAL signal_rc       : std_logic_vector(2  downto 0) := "000";
    SIGNAL signal_passthru      : std_logic_vector(16  downto 0) := (others => '0');
    SIGNAL signal_passthru_flag : std_logic := '0';
    SIGNAL signal_fwd_flag      : std_logic_vector(1 downto 0) := (others => '0');
    SIGNAL signal_m1       : std_logic := '0';
    SIGNAL signal_memrd    : std_logic := '0';
    BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_opcode   <= (others => '0');
                signal_dr1      <= (others => '0');
                signal_dr2      <= (others => '0');
                signal_alumode  <= "000";
                signal_regwb    <= '0';
                signal_memwb    <= '0';
                signal_ra       <= "000";
                signal_rb       <= "000";
                signal_rc       <= "000";
                signal_usr_flag <= '0';
                signal_passthru <= (others => '0');
                signal_passthru_flag <= '0';
                signal_fwd_flag <= "00";
                signal_m1 <= '0';
                signal_memrd <= '0';
            else
                -- on raising edge, input data and store
                signal_opcode   <= in_opcode;
                signal_dr1      <= in_dr1;
                signal_dr2      <= in_dr2;
                signal_alumode  <= in_alumode;
                signal_regwb    <= in_regwb;
                signal_memwb    <= in_memwb;
                signal_ra       <= in_ra;
                signal_rb       <= in_rb;
                signal_rc       <= in_rc;
                signal_usr_flag <= in_usr_flag;
                signal_passthru <= in_passthru;
                signal_passthru_flag <= in_passthru_flag;
                signal_fwd_flag <= in_fwd_flag;
                signal_m1 <= in_m1;
                signal_memrd <= in_memrd;
                END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_opcode   <= signal_opcode;
    out_dr1      <= signal_dr1;
    out_dr2      <= signal_dr2;
    out_alumode  <= signal_alumode;
    out_regwb    <= signal_regwb;
    out_memwb    <= signal_memwb;
    out_ra       <= signal_ra;
    out_rb       <= signal_rb;
    out_rc       <= signal_rc;
    out_usr_flag <= signal_usr_flag;
    out_passthru <= signal_passthru;
    out_passthru_flag <= signal_passthru_flag;
    out_fwd_flag <= signal_fwd_flag;
    out_m1 <= signal_m1;
    out_memrd <= signal_memrd;

END behavioural;