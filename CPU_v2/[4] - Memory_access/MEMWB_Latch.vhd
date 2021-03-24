LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MEMWB_LATCH IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_reg_wb : IN STD_LOGIC;
        in_ar : in std_logic_vector(16 downto 0);
        in_ra : in std_logic_vector(2 downto 0);
        in_usr_flag : IN STD_LOGIC;
        in_ra_data : in std_logic_vector(16 downto 0); -- for the output instruction
        -- matching output signals
        out_reg_wb : out STD_LOGIC;
        out_ar : out std_logic_vector(16 downto 0);
        out_ra : out std_logic_vector(2 downto 0);
        out_usr_flag : out STD_LOGIC;
        out_ra_data : out std_logic_vector(16 downto 0) -- for the output instruction
        );        
END MEMWB_LATCH;

ARCHITECTURE level_2 OF MEMWB_LATCH IS
    -- matching internals signals
    SIGNAL signal_reg_wb : std_logic := '0';
    SIGNAL signal_ar : std_logic_vector(16 downto 0) := (others => '0');
    SIGNAL signal_ra : std_logic_vector(2 downto 0) := (others => '0');
    SIGNAL signal_usr_flag : std_logic := '0';
    SIGNAL signal_ra_data : std_logic_vector(16 downto 0); -- for the output instruction
BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
               -- rst, set all internal latch variables to zero
               signal_reg_wb <= '0';
               signal_ar <= (others => '0');
               signal_ra <= "000";
               signal_usr_flag <= '0';
               signal_ra_data <= (others => '0');
            else
               -- on raising edge, input data and store
               signal_reg_wb <= in_reg_wb;
               signal_ar <= in_ar;
               signal_ra <= in_ra;
               signal_usr_flag <= in_usr_flag;
               signal_ra_data <= in_ra_data;
            END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
   out_reg_wb <= signal_reg_wb;
   out_ar <= signal_ar;
   out_ra <= signal_ra;
   out_usr_flag <= signal_usr_flag;
   out_ra_data <= signal_ra_data;
END level_2;