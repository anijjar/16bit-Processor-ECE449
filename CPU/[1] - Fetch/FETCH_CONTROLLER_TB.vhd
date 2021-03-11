LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FETCH_CONTROLLER_TB IS
   --  Port ( );
END FETCH_CONTROLLER_TB;

ARCHITECTURE Behavioral OF FETCH_CONTROLLER_TB IS
signal clk    : STD_LOGIC;
signal stall    : STD_LOGIC;
signal rst_ex : std_logic; 
signal rst_ld : std_logic; 
signal output :  STD_LOGIC_VECTOR(15 DOWNTO 0); 
signal rom_output :  STD_LOGIC_VECTOR(15 DOWNTO 0);
signal ram_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal ram_addrb :  STD_LOGIC_VECTOR(15 DOWNTO 0);
signal ram_rstb  :  STD_LOGIC;
signal ram_enb   :  STD_LOGIC;
signal rom_data   :  std_logic_vector(15 downto 0);
signal rom_adr    :  std_logic_vector(15 downto 0);
signal rom_rd_en  :  std_logic;
signal rom_rst    :  std_logic;
signal rom_rd     :  std_logic;

BEGIN
FETCH_CONTROLLER_TB : ENTITY work.FETCH_CONTROLLER PORT MAP(
   clk => clk,
   stall => stall,
   rst_ex =>  rst_ex,
   rst_ld =>  rst_ld,
   output  =>  output,
   rom_output =>  rom_output,
   ram_data =>  ram_data,
   ram_addrb =>  ram_addrb,
   ram_rstb =>  ram_rstb,
   ram_enb =>  ram_enb,
   rom_data =>  rom_data,
   rom_adr =>  rom_adr,
   rom_rd_en =>  rom_rd_en,
   rom_rst =>  rom_rst,
   rom_rd =>  rom_rd
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
      rst_ld <= '1';
      stall <= '0';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      rst_ld <= '0';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event); -- wait some clock cycles and see
      rst_ex <= '1';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      rst_ex <= '0';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event); -- wait some clock cycles and see
      stall <= '1';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      stall <= '0';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '0' AND CLK'event); -- wait some clock cycles and see
      -- WAIT UNTIL (CLK = '1' AND CLK'event); -- test ram
      -- ram_addrb
      -- ram_rstb
      -- ram_enb
      -- WAIT UNTIL (CLK = '1' AND CLK'event); -- test ROM
      -- rom_adr
      -- rom_rd_en
      -- rom_rst
      -- rom_rd

      WAIT;
   END PROCESS;
END Behavioral;