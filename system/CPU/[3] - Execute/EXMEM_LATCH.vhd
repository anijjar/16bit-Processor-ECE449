
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY EXMEM_LATCH IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_m1 : IN STD_LOGIC;
      in_ar : IN STD_LOGIC_VECTOR(16 DOWNTO 0); --ALU RESULT
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_dr1 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_dr2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_rc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- matching output signals
      out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      out_m1 : OUT STD_LOGIC;
      out_ar : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_dr1 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_rc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_dr2 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
   );
END EXMEM_LATCH;

ARCHITECTURE behavioural OF EXMEM_LATCH IS

   -- matching internals signals
   SIGNAL signal_ar : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_ra : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
   SIGNAL signal_m1 : STD_LOGIC := '0';
   SIGNAL signal_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_rc : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
BEGIN
   --write operation 
   PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         IF (rst = '1') THEN
            -- rst, set all internal latch variables to zero
            signal_ar <= (OTHERS => '0');
            signal_ra <= "000";
            signal_m1 <= '0';
            signal_opcode <= (OTHERS => '0');
            signal_dr1 <= (OTHERS => '0');
            signal_dr2 <= (OTHERS => '0');
            signal_rc <= (OTHERS => '0');
         ELSE
            -- on raising edge, input data and store
            signal_ar <= in_ar;
            signal_ra <= in_ra;
            signal_m1 <= in_m1;
            signal_opcode <= in_opcode;
            signal_dr1 <= in_dr1;
            signal_dr2 <= in_dr2;
            signal_rc <= in_rc;
         END IF;
      END IF;
   END PROCESS;
   -- async, output all internally stored values
   out_ar <= signal_ar;
   out_ra <= signal_ra;
   out_m1 <= signal_m1;
   out_opcode <= signal_opcode;
   out_dr1 <= signal_dr1;
   out_dr2 <= signal_dr2;
   out_rc <= signal_rc;

END behavioural;