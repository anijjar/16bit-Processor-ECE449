-- will contain the RAM module, the controllers, and ROM module b/c two controllers will have 2 instances of the RAM module.
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY System IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk                 : IN STD_LOGIC;
      rst_ex              : IN STD_LOGIC;
      rst_ld              : IN STD_LOGIC;
      input               : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      output              : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
   );        
END System;

ARCHITECTURE level_0 OF System IS
   -- CPU unit     
   SIGNAL CPU_ram_dina  : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_addra : std_logic_vector(12 downto 0);
   SIGNAL CPU_ram_addrb : std_logic_vector(12 downto 0);
   SIGNAL CPU_ram_wea   : std_logic_vector(0 downto 0);
   SIGNAL CPU_ram_rsta  : std_logic;
   SIGNAL CPU_ram_rstb  : std_logic;
   SIGNAL CPU_ram_ena   : std_logic;
   SIGNAL CPU_ram_enb   : std_logic;
   SIGNAL CPU_ram_douta : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_doutb : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_rom_data  : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_rom_adr   : std_logic_vector(N-1 downto 0); 
   SIGNAL CPU_rom_rd_en : std_logic;
   SIGNAL CPU_rom_rst   : std_logic;
   SIGNAL CPU_rom_rd    : std_logic;

BEGIN

   RAM_0 : ENTITY work.RAM PORT MAP(
		Clock      => clk, 
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
		Clock      => clk, 
		Reset      => CPU_rom_rst, 
		Enable     => CPU_rom_rd_en, 
		Read       => CPU_rom_rd, -- dont change
		Address    => CPU_rom_adr, 
		Data_out   => CPU_rom_data
   );

   CPU_0 : ENTITY work.CPU PORT MAP(
		in_rst_ld     => rst_ld,
		in_rst_ex     => rst_ex,
		clk           => clk,
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
		usr_output => output
   );
   

   
END level_0;