LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY level_0_tb IS
   --  Port ( );
END level_0_tb;

ARCHITECTURE Behavioral OF level_0_tb IS
    signal clk        :  std_logic;
    signal in_rst_ld  :  std_logic;
    signal in_rst_ex  :  std_logic;
    signal usr_output :  std_logic_vector(15 downto 0);
    signal usr_input  :  std_logic_vector(15 downto 0);
BEGIN

sys: ENTITY work.System PORT map (
    clk      => clk,          
    rst_ex   => in_rst_ld,           
    rst_ld   => in_rst_ex,           
    input    => usr_input,
    output   => usr_output          
);       

   clock : PROCESS
   BEGIN
      CLK <= '1';
      WAIT FOR 100 us;
      CLK <= '0';
      WAIT FOR 100 us;
   END PROCESS;
   
   SYSTEM_TESTS : PROCESS
   BEGIN
      in_rst_ex <= '1';
      in_rst_ld <= '0';
      usr_input <= X"0001";
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      in_rst_ex <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      WAIT;
   END PROCESS;
END Behavioral;