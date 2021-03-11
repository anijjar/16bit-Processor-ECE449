LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PC_TB IS
   --  Port ( );
END PC_TB;

ARCHITECTURE Behavioral OF PC_TB IS
   signal clk    :  std_logic;
   signal rst    :  std_logic;
   signal state  :  std_logic_vector(1 downto 0);
   signal input  :  std_logic_vector(15 downto 0);
   signal output :  std_logic_vector(15 downto 0);

BEGIN
   PC_TB : ENTITY work.PC PORT MAP(
      clk  => clk,
      rst  => rst,
      state => state,
      input => input,
      output => output, 
   );

   clock : PROCESS
   BEGIN
      CLK <= '0';
      WAIT FOR 10 us;
      CLK <= '1';
      WAIT FOR 10 us;
   END PROCESS;

   RAM_TESTS : PROCESS
   BEGIN
      rst <= '1';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      rst <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event); -- increment PC
      state <= "00";
      WAIT UNTIL (CLK = '1' AND CLK'event); -- do not increment PC
      state <= "01";
      WAIT UNTIL (CLK = '1' AND CLK'event); -- Set PC to external value (for jumps)
      state <= "10";
      input <= x"0005";
      WAIT UNTIL (CLK = '1' AND CLK'event); -- reset, set PC to program start
      state <= "11";
      WAIT;
   END PROCESS;
END Behavioral;