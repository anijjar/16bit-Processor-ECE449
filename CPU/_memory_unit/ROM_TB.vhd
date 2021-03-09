LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ROM_TB IS
   --  Port ( );
END ROM_TB;

ARCHITECTURE Behavioral OF ROM_TB IS
   SIGNAL clk : STD_LOGIC;
   SIGNAL rst : STD_LOGIC;
   SIGNAL en : STD_LOGIC;
   SIGNAL rd : STD_LOGIC;
   SIGNAL addy : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL dout : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
   ROM : ENTITY work.ROM PORT MAP(Clock => clk, Reset => rst, Enable => en, Read => rd, Address => addy, Data_out => dout);

   clock : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR 10 us;
      clk <= '1';
      WAIT FOR 10 us;
   END PROCESS;

   ROM_TEST : PROCESS
   BEGIN
      rst <= '1';
      en <= '0';
      rd <= '0';
      addy <= x"0000";
      WAIT UNTIL (clk = '0' AND clk'event);
      WAIT UNTIL (clk = '1' AND clk'event);
      rst <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '1';
      rd <= '1';
      addy <= x"0001";
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '0';
      rd <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '1';
      rd <= '1';
      addy <= x"0002";
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '0';
      rd <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '1';
      rd <= '1';
      addy <= x"0003";
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '0';
      rd <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      en <= '1';
      rd <= '1';
      addy <= x"0004";
      WAIT;
   END PROCESS;
END Behavioral;