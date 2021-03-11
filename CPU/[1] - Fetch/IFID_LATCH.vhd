LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY IFID_LATCH IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- matching output signals
      out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_rb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_rc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
   );
END IFID_LATCH;

ARCHITECTURE level_2 OF IFID_LATCH IS

   -- matching internals signals
   SIGNAL signal_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_ra : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_rb : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_rc : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

BEGIN
   --write operation 
   PROCESS (clk)
   BEGIN
      -- read on falling edge because RAM outputs on falling edge
      IF (rising_edge(clk)) THEN
         IF (rst = '1') THEN
            -- rst, set all internal latch variables to zero
            signal_opcode <= "0000000";
            signal_ra <= "000";
            signal_rb <= "000";
            signal_rc <= "000";
         ELSE
            -- on raising edge, input data and store
            signal_opcode <= input(15 DOWNTO 9);
            signal_ra <= input(8 DOWNTO 6);
            signal_rb <= input(5 DOWNTO 3);
            signal_rc <= input(2 DOWNTO 0);
         END IF;
      END IF;
   END PROCESS;
   -- async, output all internally stored values
   out_opcode <= signal_opcode;
   out_ra <= signal_ra;
   out_rb <= signal_rb;
   out_rc <= signal_rc;
END level_2;