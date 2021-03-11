LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MEMORY_CONTROLLER_TB IS
   --  Port ( );
END MEMORY_CONTROLLER_TB;

ARCHITECTURE Behavioral OF MEMORY_CONTROLLER_TB IS
signal rst : STD_LOGIC;
signal clk : STD_LOGIC;
signal in_ar : STD_LOGIC_VECTOR(16 downto 0); 
signal in_ra : STD_LOGIC_VECTOR(2 downto 0); 
signal in_regwb : STD_LOGIC;
signal in_memwb : STD_LOGIC; 
signal out_reg_wb : STD_LOGIC; 
signal out_ar : std_logic_vector(16 downto 0);
signal out_ra : std_logic_vector(2 downto 0);
signal out_RAM_rst_a : STD_LOGIC;
signal out_RAM_en_a : STD_LOGIC;
signal out_RAM_wen_a : std_logic_vector(0 downto 0); 
signal out_RAM_addy_a : std_logic_vector(15 downto 0); 
signal out_RAM_din_a : std_logic_vector(15 downto 0);
signal out_RAM_dout_a : std_logic_vector(15 downto 0);

BEGIN
MEMORY_CONTROLLER_TB : ENTITY work.MEMORY_CONTROLLER PORT MAP(
      rst   =>       rst ,
      clk  =>  clk ,
      in_ar =>  in_ar,
      in_ra =>   in_ra,
      in_regwb =>   in_regwb,
      in_memwb =>    in_memwb,
      out_reg_wb =>     out_reg_wb,
      out_ar =>     out_ar,
      out_ra =>    out_ra,
      out_RAM_rst_a =>   out_RAM_rst_a,
      out_RAM_en_a =>   out_RAM_en_a,
      out_RAM_wen_a =>   out_RAM_wen_a,
      out_RAM_addy_a =>   out_RAM_addy_a,
      out_RAM_din_a =>    out_RAM_din_a,
      out_RAM_dout_a =>   out_RAM_dout_a
    );

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
      WAIT UNTIL (clk = '0' AND clk'event);
      WAIT UNTIL (clk = '1' AND clk'event);
      rst <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);
      in_ar <= "11111111110111111";
      in_ra <= "001";
      in_regwb <= '1';
      in_memwb <= '0';
      WAIT UNTIL (clk = '1' AND clk'event);

      WAIT UNTIL (clk = '1' AND clk'event);
  
      WAIT;
   END PROCESS;
END Behavioral;