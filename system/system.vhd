LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY System IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      btnU : IN STD_LOGIC;
      btnD : IN STD_LOGIC;
      btnL : IN STD_LOGIC;
      btnR : IN STD_LOGIC;
      btnC : IN STD_LOGIC;
      leds : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      dip_switches : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      seven_segment : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      digit_select : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      clock : IN STD_LOGIC;
      display_clock : IN STD_LOGIC;
      ack_signal : OUT STD_LOGIC; -- to output(0);
      in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 5)
   );
END System;
--Main file of the Chip
--Contains the RAM, ROM, CPU, and display_controller
--Ack_signal is tied to pin-0 of the CPU outputs
--only top 10 bits of the input are used
--display port of the CPU is mapped to the display controller
--display controller is reset on reset and ex signal. (BTN down)
ARCHITECTURE level_0 OF System IS
   -- CPU unit     
   SIGNAL CPU_ram_dina : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL CPU_ram_addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL CPU_ram_addrb : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL CPU_ram_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
   SIGNAL CPU_ram_rsta : STD_LOGIC;
   SIGNAL CPU_ram_rstb : STD_LOGIC;
   SIGNAL CPU_ram_ena : STD_LOGIC;
   SIGNAL CPU_ram_enb : STD_LOGIC;
   SIGNAL CPU_ram_douta : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL CPU_ram_doutb : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL CPU_rom_data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL CPU_rom_adr : STD_LOGIC_VECTOR(9 DOWNTO 0);
   SIGNAL CPU_rom_rd_en : STD_LOGIC;
   SIGNAL CPU_rom_rst : STD_LOGIC;
   SIGNAL CPU_rom_rd : STD_LOGIC;
   SIGNAL input : STD_LOGIC_VECTOR(15 DOWNTO 0);

   SIGNAL output : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL display : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN
   input <= in_port(15 downto 5) & "00000";
   ack_signal <= output(0);

   RAM_0 : ENTITY work.RAM PORT MAP(
      Clock => clock,
      Reset_a => CPU_ram_rsta,
      Reset_b => CPU_ram_rstb,
      Enable_a => CPU_ram_ena,
      Enable_b => CPU_ram_enb,
      Write_en_a => CPU_ram_wea,
      Address_a => CPU_ram_addra,
      Address_b => CPU_ram_addrb,
      data_in_a => CPU_ram_dina,
      Data_out_a => CPU_ram_douta,
      Data_out_b => CPU_ram_doutb
      );

   ROM_0 : ENTITY work.ROM PORT MAP(
      Clock => clock,
      Reset => CPU_rom_rst,
      Enable => CPU_rom_rd_en,
      Read => CPU_rom_rd, -- dont change
      Address => CPU_rom_adr,
      Data_out => CPU_rom_data
      );

   CPU_0 : ENTITY work.CPU PORT MAP(
      in_rst_ld => btnU,
      in_rst_ex => btnD,
      clk => clock,
      in_ram_douta => CPU_ram_douta,
      in_ram_doutb => CPU_ram_doutb,
      in_rom_data => CPU_rom_data,
      out_ram_dina => CPU_ram_dina,
      out_ram_addra => CPU_ram_addra,
      out_ram_addrb => CPU_ram_addrb,
      out_ram_wea => CPU_ram_wea,
      out_ram_rsta => CPU_ram_rsta,
      out_ram_rstb => CPU_ram_rstb,
      out_ram_ena => CPU_ram_ena,
      out_ram_enb => CPU_ram_enb,
      out_rom_adr => CPU_rom_adr,
      out_rom_rd_en => CPU_rom_rd_en,
      out_rom_rst => CPU_rom_rst,
      out_rom_rd => CPU_rom_rd,
      CPU_input => input,
      CPU_output => output,
      btn1 => btnL,
      btn2 => btnC,
      btn3 => btnR,
      display => display,
      dip_switches => dip_switches,
      leds => leds 
      );

   display_module : ENTITY work.display_controller PORT MAP (
      clk => display_clock,
      reset => btnD, -- reset on button down press
      hex3 => display(15 DOWNTO 12),
      hex2 => display(11 DOWNTO 8),
      hex1 => display(7 DOWNTO 4),
      hex0 => display(3 DOWNTO 0),
      an => digit_select,
      sseg => seven_segment
      );
END level_0;