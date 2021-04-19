LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY IDEX_LATCH IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_dr1 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_dr2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_alumode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_m1 : IN STD_LOGIC;
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_rb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_rc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- matching output signals
      out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      out_dr1 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_dr2 : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_alumode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_m1 : OUT STD_LOGIC;
      out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_rb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_rc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
   );
END IDEX_LATCH;

ARCHITECTURE behavioural OF IDEX_LATCH IS

   -- matching internals signals
   SIGNAL signal_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_alumode : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_ra : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
   SIGNAL signal_rb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
   SIGNAL signal_rc : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
   SIGNAL signal_m1 : STD_LOGIC := '0';
BEGIN
   --write operation 
   PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         IF (rst = '1') THEN
            -- rst, set all internal latch variables to zero
            signal_opcode <= (OTHERS => '0');
            signal_dr1 <= (OTHERS => '0');
            signal_dr2 <= (OTHERS => '0');
            signal_alumode <= "000";
            signal_ra <= "000";
            signal_rb <= "000";
            signal_rc <= "000";
            signal_m1 <= '0';
         ELSE
            -- on raising edge, input data and store
            signal_opcode <= in_opcode;
            signal_dr1 <= in_dr1;
            signal_dr2 <= in_dr2;
            signal_alumode <= in_alumode;
            signal_ra <= in_ra;
            signal_rb <= in_rb;
            signal_rc <= in_rc;
            signal_m1 <= in_m1;
         END IF;
      END IF;
   END PROCESS;
   -- async, output all internally stored values
   out_opcode <= signal_opcode;
   out_dr1 <= signal_dr1;
   out_dr2 <= signal_dr2;
   out_alumode <= signal_alumode;
   out_ra <= signal_ra;
   out_rb <= signal_rb;
   out_rc <= signal_rc;
   out_m1 <= signal_m1;

END behavioural;