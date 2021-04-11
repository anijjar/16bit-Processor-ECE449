LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MEMWB_LATCH IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      in_m1 : IN STD_LOGIC;
      --   in_reg_wb    : IN  STD_LOGIC;
      in_ar : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      --   in_rb        : in  std_logic_vector( 2 downto 0);
      --   in_usr_flag  : IN  STD_LOGIC;
      --   in_fwd_flag  : in  std_logic_vector( 1 downto 0);
      --   in_ra_data   : IN  STD_LOGIC_VECTOR(16 DOWNTO 0); 
      --   in_dr2       : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_output_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      -- in_ram_mem : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- matching output signals
      out_m1 : OUT STD_LOGIC;
      -- out_reg_wb : OUT STD_LOGIC;
      -- out_ar : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- out_rb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- out_usr_flag : OUT STD_LOGIC;
      -- out_fwd_flag : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      -- out_ra_data : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      -- out_dr2 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      out_output_data : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
      -- out_ram_mem : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END MEMWB_LATCH;

ARCHITECTURE level_2 OF MEMWB_LATCH IS
   -- matching internals signals
   -- SIGNAL signal_reg_wb : STD_LOGIC := '0';
   SIGNAL signal_ar : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_ra : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
   -- SIGNAL signal_rb : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
   -- SIGNAL signal_usr_flag : STD_LOGIC := '0';
   -- SIGNAL signal_ra_data : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');   
   SIGNAL signal_output_data : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   -- SIGNAL signal_fwd_flag : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_m1 : STD_LOGIC := '0';
   -- SIGNAL signal_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   -- SIGNAL signal_ram_mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
   --write operation 
   PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         IF (rst = '1') THEN
            -- rst, set all internal latch variables to zero
            -- signal_reg_wb <= '0';
            signal_ar <= (OTHERS => '0');
            signal_ra <= "000";
            -- signal_rb <= "000";
            -- signal_usr_flag <= '0';
            -- signal_ra_data <= (OTHERS => '0');
            signal_output_data <= (OTHERS => '0');
            -- signal_fwd_flag <= "00";
            signal_m1 <= '0';
            -- signal_dr2 <= (OTHERS => '0');
            signal_opcode <= (OTHERS => '0');
            -- signal_ram_mem <= (OTHERS => '0');
         ELSE
            -- on raising edge, input data and store
            -- signal_reg_wb <= in_reg_wb;
            signal_ar <= in_ar;
            signal_ra <= in_ra;
            -- signal_rb <= in_rb;
            -- signal_usr_flag <= in_usr_flag;
            -- signal_ra_data <= in_ra_data;
            signal_output_data <= in_output_data;
            -- signal_fwd_flag <= in_fwd_flag;
            signal_m1 <= in_m1;
            -- signal_dr2 <= in_dr2;
            signal_opcode <= in_opcode;
            -- signal_ram_mem <= in_ram_mem;
         END IF;
      END IF;
   END PROCESS;
   -- async, output all internally stored values
   -- out_reg_wb <= signal_reg_wb;
   out_ar <= signal_ar;
   out_ra <= signal_ra;
   -- out_rb <= signal_rb;
   -- out_usr_flag <= signal_usr_flag;
   -- out_ra_data <= signal_ra_data;
   out_output_data <= signal_output_data;
   -- out_fwd_flag <= signal_fwd_flag;
   out_m1 <= signal_m1;
   -- out_dr2 <= signal_dr2;
   out_opcode <= signal_opcode;
   -- out_ram_mem <= signal_ram_mem;
END level_2;