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

ARCHITECTURE behav OF System IS
   -- RAM units
   SIGNAL RAM_rst_a	       : std_logic;	
   SIGNAL RAM_rst_b	       : std_logic;	
   SIGNAL RAM_en_a	       : std_logic;
   SIGNAL RAM_en_b	       : std_logic;
   SIGNAL RAM_wen_a	       : std_logic_vector(0 downto 0); 
   SIGNAL RAM_addy_a	   : std_logic_vector(N-1 downto 0); 
   SIGNAL RAM_addy_b	   : std_logic_vector(N-1 downto 0);
   SIGNAL RAM_din_a	       : std_logic_vector(N-1 downto 0); 
   SIGNAL RAM_dout_a       : std_logic_vector(N-1 downto 0);
   SIGNAL RAM_dout_b       : std_logic_vector(N-1 downto 0);

   -- ROM units
   SIGNAL ROM_Reset        : STD_LOGIC;
   SIGNAL ROM_Enable       : STD_LOGIC;
   SIGNAL ROM_Read         : STD_LOGIC;
   SIGNAL ROM_Address      : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   SIGNAL ROM_Data_out     : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

   -- CPU unit     
   SIGNAL CPU_16_ram_dina  : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_ram_addra : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_ram_addrb : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_ram_wea   : std_logic_vector(0 downto 0);
   SIGNAL CPU_16_ram_rsta  : std_logic;
   SIGNAL CPU_16_ram_rstb  : std_logic;
   SIGNAL CPU_16_ram_ena   : std_logic;
   SIGNAL CPU_16_ram_enb   : std_logic;
   SIGNAL CPU_16_ram_douta : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_ram_doutb : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_rom_data  : std_logic_vector(15 downto 0);
   SIGNAL CPU_16_rom_adr   : std_logic_vector(15 downto 0); 
   SIGNAL CPU_16_rom_rd_en : std_logic;
   SIGNAL CPU_16_rom_rst   : std_logic;
   SIGNAL CPU_16_rom_rd    : std_logic;

BEGIN

   RAM : ENTITY work.RAM PORT MAP(
		Clock      => clk, 
		Reset_a    => RAM_rst_a, 
		Reset_b    => RAM_rst_b, 
		Enable_a   => RAM_en_a, 
		Enable_b   => RAM_en_b, 
		Write_en_a => RAM_wen_a, 
		Address_a  => RAM_addy_a, 
		Address_b  => RAM_addy_b, 
		data_in_a  => RAM_din_a, 
		Data_out_a => RAM_dout_a, 
		Data_out_b => RAM_dout_b
   ); 

   ROM : ENTITY work.ROM PORT MAP(
		Clock      => clk, 
		Reset      => ROM_Reset, 
		Enable     => ROM_Enable, 
		Read       => ROM_Read, 
		Address    => ROM_Address, 
		Data_out   => ROM_Data_out
   );

   CPU : ENTITY work.CPU_16 PORT MAP(
		rst_load   => rst_ld,
		rst_ex     => rst_ex,
		clk        => clk,
		ram_dina   => CPU_16_ram_dina,
		ram_addra  => CPU_16_ram_addra,
		ram_addrb  => CPU_16_ram_addrb,
		ram_wea    => CPU_16_ram_wea,
		ram_rsta   => CPU_16_ram_rsta,
		ram_rstb   => CPU_16_ram_rstb,
		ram_ena    => CPU_16_ram_ena,
		ram_enb    => CPU_16_ram_enb,
		ram_douta  => CPU_16_ram_douta,
		ram_doutb  => CPU_16_ram_doutb,
		rom_data   => CPU_16_rom_data,
		rom_adr    => CPU_16_rom_adr,
		rom_rd_en  => CPU_16_rom_rd_en,
		rom_rst	   => CPU_16_rom_rst,
		rom_rd	   => CPU_16_rom_rd,
		usr_input  => input,          
		usr_output => output
   );
   
   -- map ROM to CPU 
   ROM_Reset        <= CPU_16_rom_rst;
   ROM_Enable       <= CPU_16_rom_rd_en;
   ROM_Read         <= CPU_16_rom_rd;
   ROM_Address      <= CPU_16_rom_adr;
   ROM_Data_out     <= CPU_16_rom_data;
   
   --map RAM to CPU
   RAM_rst_a	    <= CPU_16_ram_rsta;
   RAM_rst_b	    <= CPU_16_ram_rstb; 
   RAM_en_a	        <= CPU_16_ram_ena; 
   RAM_en_b	        <= CPU_16_ram_enb;   
   RAM_wen_a	    <= CPU_16_ram_wea;  
   RAM_addy_a       <= CPU_16_ram_addra;  
   RAM_addy_b       <= CPU_16_ram_addrb;   
   RAM_din_a	    <= CPU_16_ram_dina;   
   RAM_dout_a       <= CPU_16_ram_douta; 
   RAM_dout_b       <= CPU_16_ram_doutb; 
   
   
END behav;