LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WRITE_BACK_CONTROLLER_TB IS
   --  Port ( );
END WRITE_BACK_CONTROLLER_TB;

ARCHITECTURE level_2 OF WRITE_BACK_CONTROLLER_TB IS
signal rst : STD_LOGIC;
signal clk : STD_LOGIC;
signal in_reg_wb : STD_LOGIC;
signal in_ar : std_logic_vector(16 downto 0);
signal in_ra : std_logic_vector(2 downto 0);
signal out_cpu : std_logic_vector(15 downto 0);
signal out_ar : std_logic_vector(16 downto 0);
signal out_ra : std_logic_vector(2 downto 0);
signal out_ra_wen : std_logic;

BEGIN
WRITE_BACK_CONTROLLER_TB : ENTITY work.WRITE_BACK_CONTROLLER PORT MAP(
   rst => rst,
   clk => clk,
   in_reg_wb => in_reg_wb,
   in_ar => in_ar,
   in_ra => in_ra,
   out_cpu => out_cpu,
   out_ar => out_ar,
   out_ra => out_ra,
   out_ra_wen => out_ra_wen
);

   clock : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR 10 us;
      clk <= '1';
      WAIT FOR 10 us;
   END PROCESS;

   TEST : PROCESS
   BEGIN
      rst <= '1';
      WAIT UNTIL (clk = '0' AND clk'event);
      WAIT UNTIL (clk = '1' AND clk'event);
      rst <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      in_ar <= "11111111110111111";
      in_ra <= "111";
      in_reg_wb <= '1';
      WAIT UNTIL (clk = '1' AND clk'event);
      in_ar <= "11111111110111111";
      in_ra <= "111";
      in_reg_wb <= '0';
      WAIT;
   END PROCESS;
END level_2;
