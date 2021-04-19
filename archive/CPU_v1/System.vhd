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
   SIGNAL ROM_Read         : STD_LOGIC; -- dont change
   SIGNAL ROM_Address      : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   SIGNAL ROM_Data_out     : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

   -- CPU unit     
   SIGNAL CPU_ram_dina  : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_addra : std_logic_vector(N-1 downto 0);
   SIGNAL CPU_ram_addrb : std_logic_vector(N-1 downto 0);
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
		Read       => ROM_Read, -- dont change
		Address    => ROM_Address, 
		Data_out   => ROM_Data_out
   );

   CPU : ENTITY work.CPU PORT MAP(
		in_rst_ld   => rst_ld,
		in_rst_ex     => rst_ex,
		clk        => clk,
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
   
   -- map ROM to CPU 
   ROM_Reset        <= CPU_rom_rst;
   ROM_Enable       <= CPU_rom_rd_en;
   ROM_Read         <= CPU_rom_rd; -- dont change
   ROM_Address      <= CPU_rom_adr;
   ROM_Data_out     <= CPU_rom_data;
   
   --map RAM to CPU
   RAM_rst_a	    <= CPU_ram_rsta;
   RAM_rst_b	    <= CPU_ram_rstb; 
   RAM_en_a	        <= CPU_ram_ena; 
   RAM_en_b	        <= CPU_ram_enb;   
   RAM_wen_a	    <= CPU_ram_wea;  
   RAM_addy_a       <= CPU_ram_addra;  
   RAM_addy_b       <= CPU_ram_addrb;   
   RAM_din_a	    <= CPU_ram_dina;   
   RAM_dout_a       <= CPU_ram_douta; 
   RAM_dout_b       <= CPU_ram_doutb; 
   
   
END level_0;