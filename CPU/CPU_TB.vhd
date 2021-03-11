LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY System_TB IS
   --  Port ( );
END System_TB;

ARCHITECTURE Behavioral OF System_TB IS
   signal clk    : IN STD_LOGIC;    
   signal rst_ex : IN STD_LOGIC; 
   signal rst_ld : IN STD_LOGIC;
   signal input  : IN STD_LOGIC_VECTOR( 15 downto 0);
   signal output : OUT STD_LOGIC_VECTOR( 15 downto 0);

BEGIN
   System : ENTITY work.System PORT MAP(
      clk     => clk,    
      rst_ex  => rst_ex,     
      rst_ld  => rst_ld,     
      input  => input,
      output  => output     
   );

   clock : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR 10 us;
      clk <= '1';
      WAIT FOR 10 us;
   END PROCESS;

   SYSTEM_TESTS : PROCESS
   BEGIN
      rst_ex <= '0';
      rst_ld <= '0';
      input <= X"000F";

      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      rst_ex <= '1';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      rst_ex <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      WAIT;
   END PROCESS;
END Behavioral;