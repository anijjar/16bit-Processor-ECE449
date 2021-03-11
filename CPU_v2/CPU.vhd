LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      in_rst_ld   : in  std_logic;
      in_rst_ex     : in  std_logic;
      clk        : in  std_logic;
      -- RAM
      in_ram_douta  : in std_logic_vector(N-1 downto 0);
      out_ram_dina   : out  std_logic_vector(N-1 downto 0);
      out_ram_addra  : out std_logic_vector(N-1 downto 0);
      out_ram_wea    : out std_logic_vector(0 downto 0);
      out_ram_rsta   : out std_logic;
      out_ram_ena    : out std_logic;
      in_ram_doutb  : in std_logic_vector(N-1 downto 0);
      out_ram_enb    : out std_logic;
      out_ram_addrb  : out std_logic_vector(N-1 downto 0);
      out_ram_rstb   : out std_logic;
      -- ROM
      in_rom_data   : in  std_logic_vector(N-1 downto 0);
      out_rom_adr    : out std_logic_vector(N-1 downto 0);
      out_rom_rd_en  : out std_logic;
      out_rom_rst    : out std_logic;
      out_rom_rd     : out std_logic;
      -- user I/O
      usr_input  : in  std_logic_vector(N-1 downto 0);              
      usr_output : out std_logic_vector(N-1 downto 0)              
   );   
END CPU;

ARCHITECTURE level_1 OF CPU IS
   signal rst   : STD_LOGIC;

   signal rf_rd_index1    : std_logic_vector( 2 downto 0);
   signal rf_rd_index2    : std_logic_vector( 2 downto 0);
   signal rf_rd_data1     : std_logic_vector(N downto 0);
   signal rf_rd_data2     : std_logic_vector(N downto 0);
   signal rf_wr_index     : std_logic_vector( 2 downto 0);
   signal rf_wr_data      : std_logic_vector(N downto 0);
   signal rf_wr_enable    : std_logic;

   signal fc_in_ram_data : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   signal fc_out_output : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   signal fc_out_ram_addrb : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   signal fc_out_ram_enb   : STD_LOGIC;
   signal ifid_out_opcode : std_logic_vector( 6 downto 0);
   signal ifid_out_ra     : std_logic_vector( 2 downto 0);
   signal ifid_out_rb     : std_logic_vector( 2 downto 0);
   signal ifid_out_rc     : std_logic_vector( 2 downto 0);

   signal ds_RD1          : std_logic_vector(N downto 0);
   signal ds_RD2          : std_logic_vector(N downto 0);
   signal ds_alumode      : std_logic_vector( 2 downto 0);  
   signal ds_regwb        : std_logic;
   signal ds_memwb        : std_logic;
   signal ds_usr_flag     : std_logic;
   signal ds_rdst         : std_logic_vector( 2 downto 0);
   ----+---- Execute stage Signals ----+----
   signal idex_dr1     : std_logic_vector(N downto 0);
   signal idex_dr2     : std_logic_vector(N downto 0);
   signal idex_alumode : std_logic_vector( 2 downto 0);
   signal idex_regwb   : std_logic;
   signal idex_memwb   : std_logic;
   signal idex_usr_flag: std_logic;
   signal idex_rdst    : std_logic_vector( 2 downto 0);
   signal es_ar        : std_logic_vector(N downto 0);
   signal es_z         : std_logic; -- nothing is driving this one
   signal es_n         : std_logic; -- nothing is driving this one
   signal es_regwb     : std_logic;
   signal es_memwb     : std_logic;
   signal es_rdst      : std_logic_vector( 2 downto 0);
   signal exmem_regwb  : std_logic;
   signal exmem_memwb  : std_logic;
   signal exmem_ar  : std_logic_vector(N downto 0);
   signal exmem_ra  : std_logic_vector(2 downto 0);
   -- Memory stage Signals
   signal mem_out_reg_wb : STD_LOGIC;
   signal mem_out_ar : std_logic_vector(N downto 0);
   signal mem_out_ra : std_logic_vector(2 downto 0);
   signal memwb_out_reg_wb : STD_LOGIC;
   signal memwb_out_ar : std_logic_vector(N downto 0);
   signal memwb_out_ra : std_logic_vector(2 downto 0);


begin
   rf_0 : entity work.register_file port map (
      rst       => rst,
      clk       => clk,
      rd_index1 => rf_rd_index1,
      rd_index2 => rf_rd_index2,
      rd_data1  => rf_rd_data1,
      rd_data2  => rf_rd_data2,
      wr_index  => rf_wr_index,
      wr_data   => rf_wr_data,
      wr_enable => rf_wr_enable
   );
   Fetch : ENTITY work.FETCH_CONTROLLER port map (
      clk => clk,
      rst_ex => in_rst_ex,
      rst_ld  => in_rst_ld,
      out_output  => fc_out_output,
      in_ram_data  => fc_in_ram_data,
      out_ram_addrb => fc_out_ram_addrb, 
      out_ram_enb   => fc_out_ram_enb 
   );
   in_ram_doutb <= fc_in_ram_data;
   out_ram_enb <= fc_out_ram_enb;
   out_ram_addrb <= fc_out_ram_addrb;
   out_ram_rstb <= '0';

   IFID : ENTITY work.IFID_LATCH port map (
      rst        => rst,
      clk        => clk,
      input      => fc_out_output,
      out_opcode => ifid_out_opcode,
      out_ra     => ifid_out_ra,
      out_rb     => ifid_out_rb,
      out_rc     => ifid_out_rc
   );
   Decode : entity work.DECODE_STAGE port map (
      rst     => rst,
      in_opcode  => ifid_out_opcode,
      in_ra      => ifid_out_ra,
      in_rb      => ifid_out_rb,
      in_rc      => ifid_out_rc,
      in_RF1d    => rf_rd_data1, 
      in_RF2d    => rf_rd_data2, 
      out_RF1a    => rf_rd_index1,
      out_RF2a    => rf_rd_index2,
      out_RD1     => ds_RD1,
      out_RD2     => ds_RD2,
      out_alumode => ds_alumode,
      out_memwb   => ds_memwb,
      out_regwb   => ds_regwb,
      out_usr_flag => ds_usr_flag,
      out_rdst    => ds_rdst     
   );
   IDEX : entity work.IDEX_LATCH port map (
      rst         => rst,
      clk         => clk,
      in_dr1      => ds_RD1,
      in_dr2      => ds_RD2,
      in_usr_flag => ds_usr_flag,
      in_alumode  => ds_alumode,
      in_regwb    => ds_regwb,
      in_memwb    => ds_memwb,
      in_ra       => ds_rdst,
      out_dr1     => idex_dr1,
      out_dr2     => idex_dr2,
      out_alumode => idex_alumode,
      out_regwb   => idex_regwb,
      out_usr_flag => idex_usr_flag,
      out_memwb   => idex_memwb,
      out_ra      => idex_rdst
   );
   Execute : entity work.EXECUTE_STAGE port map (
      rst       => rst, 
      usr_input => usr_input,
      usr_flag =>  idex_usr_flag,
      RD1       => idex_dr1,
      RD2       => idex_dr2,
      alumode   => idex_alumode,
      AR        => es_ar,
      z_flag    => es_z,
      n_flag    => es_n,
      in_memwb  => idex_memwb,
      out_memwb => es_memwb,
      in_regwb  => idex_regwb,
      out_regwb => es_regwb,
      in_rdst   => idex_rdst,
      out_rdst  => es_rdst
   );
   EXMEM :ENTITY work.EXMEM_LATCH port map (
      rst       => rst,
      clk       => clk,
      in_ar     => es_ar,
      in_regwb  => es_regwb,
      in_memwb  => es_memwb,
      in_ra     => es_rdst,
      out_ar    => exmem_ar,
      out_regwb => exmem_regwb,
      out_memwb => exmem_memwb,
      out_ra    => exmem_ra
   );
-- Memory Stage
   --controller (currently only forwarding to next latch)
   Memory : ENTITY work.MEMORY_CONTROLLER port map (
      rst => rst,
      clk => clk,
      in_ar => exmem_ar,
      in_ra => exmem_ra, 
      in_regwb => exmem_regwb, 
      in_memwb => exmem_memwb, 
      out_reg_wb => mem_out_reg_wb,
      out_ar => mem_out_ar,
      out_ra => mem_out_ra,
      out_RAM_rst_a => out_ram_rsta,
      out_RAM_en_a => out_ram_ena,
      out_RAM_wen_a => out_ram_wea,
      out_RAM_addy_a => out_ram_addra,
      out_RAM_din_a => out_ram_dina,
      out_RAM_dout_a => in_ram_douta
   );  

   --latch
   MEMWB : ENTITY work.MEMWB_LATCH port map (
      rst        => rst,
      clk        => clk,
      in_reg_wb => mem_out_reg_wb,
      in_ar => mem_out_ar,
      in_ra => mem_out_ra,
      out_reg_wb => memwb_out_reg_wb,
      out_ar => memwb_out_ar,
      out_ra => memwb_out_ra
   );
-- Writeback Stage
   --Controller
   Write_Back : ENTITY work.WRITE_BACK_CONTROLLER port map (
      rst => rst,
      clk => clk,
	   in_reg_wb => memwb_out_reg_wb, 
	   in_ar => memwb_out_ar,
      in_ra => memwb_out_ra,
      out_cpu => usr_output, -- leaves CPU
	   out_ar => rf_wr_data,
      out_ra => rf_wr_index,
      out_ra_wen => rf_wr_enable
   );
   FSM: process(in_rst_ld, in_rst_ex, rst)
   begin
      if( in_rst_ld = '1' or in_rst_ex = '1') then
         rst <= '1';
      else 
         rst <= '0';
      end if;
   end process FSM;
end level_1;