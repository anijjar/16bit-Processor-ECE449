LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY System IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
       btnU: in std_logic;
       btnD: in std_logic;
       btnL: in std_logic;
       btnR: in std_logic;
       btnC: in std_logic;
       leds: out std_logic_vector( 15 downto 0 );
       dip_switches: in std_logic_vector( 15 downto 0 );
       seven_segment: out std_logic_vector( 6 downto 0 );
       digit_select: out std_logic_vector( 3 downto 0 );
       clock : in std_logic;
       display_clock: in std_logic;
       ack_signal: out std_logic;
       in_port : in std_logic_vector(15 downto 5)
   );        
END System;

ARCHITECTURE level_0 OF System IS
   -- CPU unit     
   SIGNAL CPU_ram_dina  : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_addra : std_logic_vector(9 downto 0);
   SIGNAL CPU_ram_addrb : std_logic_vector(9 downto 0);
   SIGNAL CPU_ram_wea   : std_logic_vector(0 downto 0);
   SIGNAL CPU_ram_rsta  : std_logic;
   SIGNAL CPU_ram_rstb  : std_logic;
   SIGNAL CPU_ram_ena   : std_logic;
   SIGNAL CPU_ram_enb   : std_logic;
   SIGNAL CPU_ram_douta : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_doutb : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_rom_data  : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_rom_adr   : std_logic_vector(9 downto 0); 
   SIGNAL CPU_rom_rd_en : std_logic;
   SIGNAL CPU_rom_rst   : std_logic;
   SIGNAL CPU_rom_rd    : std_logic;
   signal input :  std_logic_vector(15 downto 0);
   
   signal in_led : std_logic_vector(15 downto 0);
SIGNAL display  : std_logic_vector(N-1 downto 0);
BEGIN
    input <= in_port & "00000";
    --ack_signal <= btnL ;
    
   RAM_0 : ENTITY work.RAM PORT MAP(
		Clock      => clock, 
		Reset_a    => CPU_ram_rsta, 
		Reset_b    => CPU_ram_rstb, 
		Enable_a   => CPU_ram_ena, 
		Enable_b   => CPU_ram_enb, 
		Write_en_a => CPU_ram_wea, 
		Address_a  => CPU_ram_addra, 
		Address_b  => CPU_ram_addrb, 
		data_in_a  => CPU_ram_dina, 
		Data_out_a => CPU_ram_douta, 
		Data_out_b => CPU_ram_doutb
   ); 

   ROM_0 : ENTITY work.ROM PORT MAP(
		Clock      => clock, 
		Reset      => CPU_rom_rst, 
		Enable     => CPU_rom_rd_en, 
		Read       => CPU_rom_rd, -- dont change
		Address    => CPU_rom_adr, 
		Data_out   => CPU_rom_data
   );

   CPU_0 : ENTITY work.CPU PORT MAP(
		in_rst_ld     => btnU,
		in_rst_ex     => btnD,
		clk           => clock,
		in_ram_douta  => CPU_ram_douta,
		in_ram_doutb  => CPU_ram_doutb,
		in_rom_data   => CPU_rom_data,
		out_ram_dina   => CPU_ram_dina,
		out_ram_addra  => CPU_ram_addra,
		out_ram_addrb  => CPU_ram_addrb,
		out_ram_wea    => CPU_ram_wea,
		out_ram_rsta   => CPU_ram_rsta,
		out_ram_rstb   => CPU_ram_rstb,
		out_ram_ena    => CPU_ram_ena,
		out_ram_enb    => CPU_ram_enb,
		out_rom_adr    => CPU_rom_adr,
		out_rom_rd_en  => CPU_rom_rd_en,
		out_rom_rst	   => CPU_rom_rst,
		out_rom_rd	   => CPU_rom_rd,
		usr_input  => input,          
		usr_output => in_led,
		btn1 => btnL,
		btn2 => btnR,
		btn3 => btnC,
		display => display,
		dip_switches => dip_switches,
		leds => leds -- have leds be outputing the store instructions
   );
   
   display_module : ENTITY work.display_controller port map (
        clk => display_clock,
        reset => btnD, -- reset on button down press
        hex3 => display(15 downto 12),
        hex2 => display(11 downto 8),
        hex1 => display(7 downto 4),
        hex0 => display(3 downto 0),
        an => digit_select,
        sseg => seven_segment  
   );

   
END level_0;