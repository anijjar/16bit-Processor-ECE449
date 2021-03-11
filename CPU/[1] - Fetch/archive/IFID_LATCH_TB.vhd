LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IFID_LATCH_TB IS
   --  Port ( );
END IFID_LATCH_TB;

ARCHITECTURE Behavioral OF IFID_LATCH_TB IS

   signal rst :  STD_LOGIC;
   signal clk :  STD_LOGIC;
   signal input :  STD_LOGIC_VECTOR(15 DOWNTO 0);
   signal out_opcode :  STD_LOGIC_VECTOR(6 DOWNTO 0);
   signal out_ra :  STD_LOGIC_VECTOR(2 DOWNTO 0);
   signal out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   signal out_rc :  STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
   IFID_LATCH_TB : ENTITY work.IFID_LATCH PORT MAP(
      rst => rst,
      clk => clk,
      input => input,
      out_opcode => out_opcode,
      out_ra => out_ra,
      out_rb => out_rb,
      out_rc => out_rc 
   );

   clock : PROCESS
   BEGIN
      CLK <= '1';
      WAIT FOR 10 us;
      CLK <= '0';
      WAIT FOR 10 us;
   END PROCESS;

   RAM_TESTS : PROCESS
   BEGIN
      rst <= '1';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      rst <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event);
      input <= x"0003";
      WAIT UNTIL (CLK = '1' AND CLK'event);
      input <= x"0004";
      WAIT UNTIL (CLK = '1' AND CLK'event);
      input <= x"0005";
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      input <= x"000A";
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      input <= x"000F";
      WAIT UNTIL (CLK = '1' AND CLK'event);
      input <= x"0CFF";
      WAIT;
   END PROCESS;
END Behavioral;