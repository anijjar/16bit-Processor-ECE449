LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY level_1_tb IS
   --  Port ( );
END level_1_tb;

ARCHITECTURE Behavioral OF level_1_tb IS
signal clk            :  std_logic;
signal in_rst_ld      :  std_logic;
signal in_rst_ex      :  std_logic;
signal in_ram_douta   :  std_logic_vector(15 downto 0);
signal out_ram_dina   :  std_logic_vector(15 downto 0);
signal out_ram_addra  :  std_logic_vector(9 downto 0);
signal out_ram_wea    :  std_logic_vector(0 downto 0);
signal out_ram_rsta   :  std_logic;
signal out_ram_ena    :  std_logic;
signal in_ram_doutb   :  std_logic_vector(15 downto 0);
signal out_ram_enb    :  std_logic;
signal out_ram_addrb  :  std_logic_vector(9 downto 0);
signal out_ram_rstb   :  std_logic;
signal in_rom_data    :  std_logic_vector(15 downto 0);
signal out_rom_adr    :  std_logic_vector(9 downto 0);
signal out_rom_rd_en  :  std_logic;
signal out_rom_rst    :  std_logic;
signal out_rom_rd     :  std_logic;
signal usr_output   :  std_logic_vector(15 downto 0);
signal usr_input   :  std_logic_vector(15 downto 0);
BEGIN
CPU_0 : ENTITY work.CPU port map (
   clk            => clk, 
   in_rst_ld => in_rst_ld,
   in_rst_ex => in_rst_ex,
   in_ram_douta => in_ram_douta,
   out_ram_dina => out_ram_dina,
   out_ram_addra => out_ram_addra,
   out_ram_wea => out_ram_wea,
   out_ram_rsta => out_ram_rsta,
   out_ram_ena => out_ram_ena,
   in_ram_doutb => in_ram_doutb,
   out_ram_enb => out_ram_enb,
   out_ram_addrb => out_ram_addrb,
   out_ram_rstb => out_ram_rstb,
   in_rom_data => in_rom_data,
   out_rom_adr => out_rom_adr,
   out_rom_rd_en => out_rom_rd_en,
   out_rom_rst => out_rom_rst,
   out_rom_rd  => out_rom_rd  ,
   usr_input => usr_input,
   usr_output => usr_output
);   

RAM_tb : ENTITY work.RAM PORT MAP(
   Clock => clk, 
   Reset_a => out_ram_rsta, 
   Reset_b => out_ram_rstb, 
   Enable_a => out_ram_ena, 
   Enable_b => out_ram_enb, 
   Write_en_a => out_ram_wea, 
   Address_a => out_ram_addra,
   Address_b => out_ram_addrb, 
   data_in_a => out_ram_dina, 
   Data_out_a => in_ram_douta,
   Data_out_b => in_ram_doutb
);
ROM_tb : ENTITY work.ROM PORT MAP(
   Clock  => clk,
   Reset => out_rom_rst,
   Enable => out_rom_rd_en,
   Read=> out_rom_rd,
   Address => out_rom_adr,
   Data_out => in_rom_data
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
     in_rst_ex <= '0';
     in_rst_ld <= '0';
     usr_input <= X"FFFF";
     WAIT UNTIL (CLK = '0' AND CLK'event);
     WAIT UNTIL (CLK = '1' AND CLK'event);
     in_rst_ex <= '1';
     WAIT UNTIL (CLK = '1' AND CLK'event); 
     in_rst_ex <= '0';
     WAIT;
   END PROCESS;
END Behavioral;