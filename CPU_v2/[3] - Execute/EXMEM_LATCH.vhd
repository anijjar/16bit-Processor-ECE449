
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY EXMEM_LATCH IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_ar       : in  std_logic_vector(16 downto 0); --ALU RESULT
        in_regwb    : in  std_logic; -- REGISTER OPRAND
        in_memwb        : in  std_logic; -- MEMORY OPRAND
        in_ra       : in  std_logic_vector(2  downto 0);
        in_usr_flag : in  std_logic;
        in_ra_data : in std_logic_vector(16 downto 0); -- for the output instruction
        -- matching output signals
        out_ar      : out std_logic_vector(16 downto 0);
        out_regwb   : out std_logic;
        out_memwb   : out std_logic;
        out_ra      : out std_logic_vector(2  downto 0);
        out_usr_flag : out std_logic;
        out_ra_data : out std_logic_vector(16 downto 0) -- for the output instruction
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
            else
                -- on raising edge, input data and store
                signal_ar     <= in_ar;
                signal_regwb   <= in_regwb;
                signal_memwb   <= in_memwb;
                signal_ra      <= in_ra;
                signal_usr_flag <= in_usr_flag;
                signal_ra_data     <= in_ra_data;
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

END behavioural;