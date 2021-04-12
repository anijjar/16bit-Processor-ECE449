LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY IFID_LATCH IS
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      in_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      in_pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      in_pc2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- matching output signals
      out_opcode : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      out_data : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      out_pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      out_pc2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END IFID_LATCH;

ARCHITECTURE level_2 OF IFID_LATCH IS

   -- matching internals signals
   SIGNAL signal_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_data : STD_LOGIC_VECTOR(8 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_pc : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
   SIGNAL signal_pc2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
   --write operation 
   PROCESS (clk)
   BEGIN
      -- read on falling edge because RAM outputs on falling edge
      IF (rising_edge(clk)) THEN
         IF (rst = '1') THEN
            -- rst, set all internal latch variables to zero
            signal_opcode <= (OTHERS => '0');
            signal_data <= (OTHERS => '0');
            signal_pc <= (OTHERS => '0');
            signal_pc2 <= (OTHERS => '0');
         ELSE
            -- on raising edge, input data and store
            signal_opcode <= in_input(15 DOWNTO 9);
            signal_data <= in_input(8 DOWNTO 0);
            signal_pc <= in_pc;
            signal_pc2 <= in_pc2;
         END IF;
      END IF;
   END PROCESS;
   -- async, output all internally stored values
   out_opcode <= signal_opcode;
   out_data <= signal_data;
   out_pc <= signal_pc;
   out_pc2 <= signal_pc2;
END level_2;