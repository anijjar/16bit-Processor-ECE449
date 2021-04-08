
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY EXMEM_LATCH IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_m1 : IN STD_LOGIC;
        in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_ar       : in  std_logic_vector(16 downto 0); --ALU RESULT
        in_regwb    : in  std_logic; -- REGISTER OPRAND
        in_memwb        : in  std_logic; -- MEMORY OPRAND
        in_memrd : IN STD_LOGIC;
        in_ra       : in  std_logic_vector(2  downto 0);
        in_usr_flag : in  std_logic;
        in_ra_data : in std_logic_vector(16 downto 0); -- for the output instruction
        in_fwd_flag       : in  std_logic_vector(1 downto 0);
        in_dr1 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        in_dr2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        in_rb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- matching output signals
        out_m1      : out STD_LOGIC;
        out_opcode  : out STD_LOGIC_VECTOR(6 DOWNTO 0);
        out_ar      : out std_logic_vector(16 downto 0);
        out_regwb   : out std_logic;
        out_memwb   : out std_logic;
        out_memrd   : out STD_LOGIC;
        out_ra      : out std_logic_vector(2  downto 0);
        out_usr_flag : out std_logic;
        out_ra_data : out std_logic_vector(16 downto 0); -- for the output instruction
        out_fwd_flag : out std_logic_vector(1 downto 0);
        out_dr1     : out STD_LOGIC_VECTOR(16 DOWNTO 0);
        out_dr2     : out STD_LOGIC_VECTOR(16 DOWNTO 0);
        out_rb      : out STD_LOGIC_VECTOR(2 DOWNTO 0)
        );        
END EXMEM_LATCH;

ARCHITECTURE behavioural OF EXMEM_LATCH IS

    -- matching internals signals
    SIGNAL signal_ar      : std_logic_vector(16 downto 0) := (others => '0');
    SIGNAL signal_regwb   : std_logic := '0';
    SIGNAL signal_memwb   : std_logic := '0';
    SIGNAL signal_ra      : std_logic_vector(2  downto 0) := "000";
    SIGNAL signal_usr_flag: std_logic := '0';
    SIGNAL signal_ra_data      : std_logic_vector(16 downto 0) := (others => '0');
    SIGNAL signal_fwd_flag      : std_logic_vector(1 downto 0) := (others => '0');
    signal signal_m1      :  STD_LOGIC := '0';
    signal signal_opcode  :  STD_LOGIC_VECTOR(6 DOWNTO 0) := (others => '0');
    signal signal_memrd   :  STD_LOGIC := '0';
    signal signal_dr1     :  STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');
    signal signal_dr2     :  STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');
    signal signal_rb      :  STD_LOGIC_VECTOR( 2 DOWNTO 0) := (others => '0');
    BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
                -- rst, set all internal latch variables to zero
                signal_ar     <= (others => '0');
                signal_regwb   <= '0';
                signal_memwb   <= '0';
                signal_usr_flag   <= '0';
                signal_ra      <= "000";
                signal_ra_data     <= (others => '0');
                signal_fwd_flag <= "00";
                signal_m1        <= '0';           
                signal_opcode    <= (others => '0');               
                signal_memrd     <= '0';           
                --signal_fwd_flag  <= (others => '0');
                signal_dr1       <= (others => '0');
                signal_dr2       <= (others => '0'); 
                signal_rb        <= (others => '0');           
            else
                -- on raising edge, input data and store
                signal_ar     <= in_ar;
                signal_regwb   <= in_regwb;
                signal_memwb   <= in_memwb;
                signal_ra      <= in_ra;
                signal_usr_flag <= in_usr_flag;
                signal_ra_data     <= in_ra_data;
                signal_fwd_flag <= in_fwd_flag;
                signal_m1        <= in_m1;
                signal_opcode    <= in_opcode;
                signal_memrd     <= in_memrd;
                --signal_fwd_flag  <= in_fwd_flag;
                signal_dr1       <= in_dr1;
                signal_dr2       <= in_dr2;
                signal_rb        <= in_rb;
                END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
    out_ar     <= signal_ar;
    out_regwb   <= signal_regwb;
    out_memwb   <= signal_memwb;
    out_ra      <= signal_ra;
    out_usr_flag <= signal_usr_flag;
    out_ra_data     <= signal_ra_data;
    out_fwd_flag <= signal_fwd_flag;
    out_m1        <= signal_m1;
    out_opcode    <= signal_opcode;
    out_memrd     <= signal_memrd;
    --out_fwd_flag  <= signal_fwd_flag;
    out_dr1       <= signal_dr1;
    out_dr2       <= signal_dr2;
    out_rb        <= signal_rb;

END behavioural;