LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ROM_TB IS
   --  Port ( );
END ROM_TB;

ARCHITECTURE Behavioral OF ROM_TB IS
    Signal clk : std_logic;
    Signal rst : std_logic;    
    Signal en : std_logic;
    Signal rd : std_logic;
    Signal addy : std_logic_vector(15 downto 0);
    Signal dout : std_logic_vector(15 downto 0);

BEGIN
   ROM : ENTITY work.ROM PORT MAP(clk, rst, en, rd, addy, dout);
   
   clock: PROCESS 
   BEGIN
       clk <= '0';
       WAIT FOR 20 us;
       clk <= '1';
       WAIT FOR 20 us;
   END PROCESS;
   
   TESTS : PROCESS
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
          addy <= x"0002";
        wait;
   END PROCESS;
END Behavioral;