LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MEMWB_Latch IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        -- any input signals
        in_mem_data : in std_logic_vector(15 downto 0);
        in_wb_opr : in std_logic_vector(15 downto 0);
        in_ar : in std_logic_vector(15 downto 0);
        in_ra : in std_logic_vector(15 downto 0);
        -- matching output signals
        out_mem_data : out std_logic_vector(15 downto 0);
        out_wb_opr : in std_logic_vector(15 downto 0);
        out_ar : in std_logic_vector(15 downto 0);
        out_ra : in std_logic_vector(15 downto 0)
        );        
END MEMWB_Latch;

ARCHITECTURE behav OF MEMWB_Latch IS
    -- matching internals signals
    SIGNAL signal_mem_data : std_logic_vector(15 downto 0) <= X"0000";
    SIGNAL signal_wb_opr : std_logic_vector(15 downto 0) <= X"0000";
    SIGNAL signal_ar : std_logic_vector(15 downto 0) <= X"0000";
    SIGNAL signal_ra : std_logic_vector(15 downto 0) <= X"0000";
BEGIN
    --write operation 
    PROCESS(clk)
    BEGIN
        if (rising_edge(clk)) THEN
            if (rst = '1') THEN
               -- rst, set all internal latch variables to zero
               signal_mem_data <= X"0000";
               signal_wb_opr <= X"0000";
               signal_ar <= X"0000";
               signal_ra <= X"0000";
            else
               -- on raising edge, input data and store
               signal_mem_data <= in_mem_data;
               signal_wb_opr <= in_wb_opr;
               signal_ar <= in_ar;
               signal_ra <= in_ra;
            END if;
        END if;
    END PROCESS;
    -- async, output all internally stored values
   out_mem_data <= signal_mem_data;
   out_wb_opr <= signal_wb_opr;
   out_ar <= signal_ar;
   out_ra <= out_ra;

END behavioural;