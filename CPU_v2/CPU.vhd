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
      out_ram_addra  : out std_logic_vector(12 downto 0);
      out_ram_wea    : out std_logic_vector(0 downto 0);
      out_ram_rsta   : out std_logic;
      out_ram_ena    : out std_logic;
      in_ram_doutb  : in std_logic_vector(N-1 downto 0);
      out_ram_enb    : out std_logic;
      out_ram_addrb  : out std_logic_vector(12 downto 0);
      out_ram_rstb   : out std_logic;
      -- ROM
      in_rom_data   : in  std_logic_vector(N-1 downto 0);
      out_rom_adr    : out std_logic_vector(N-1 downto 0);
      out_rom_rd_en  : out std_logic;
      out_rom_rst    : out std_logic;
      out_rom_rd     : out std_logic; --dont use
      -- user I/O
      usr_input  : in  std_logic_vector(N-1 downto 0);              
      usr_output : out std_logic_vector(N-1 downto 0)              
   );   
END CPU;

ARCHITECTURE level_1 OF CPU IS
signal rst            :  std_logic;
signal fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal ifid_out_opcode : std_logic_vector( 6 downto 0);
signal ifid_out_ra     : std_logic_vector( 2 downto 0);
signal ifid_out_rb     : std_logic_vector( 2 downto 0);
signal ifid_out_rc     : std_logic_vector( 2 downto 0);

signal DOUTA : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal ds_out_RF1a    : std_logic_vector( 2 downto 0);
signal ds_out_RF2a    : std_logic_vector( 2 downto 0);
signal ds_out_RD1     : std_logic_vector(16 downto 0);
signal ds_out_RD2     : std_logic_vector(16 downto 0);
signal ds_out_alumode : std_logic_vector( 2 downto 0);
signal ds_out_memwb   : std_logic;
signal ds_out_regwb   : std_logic;
signal ds_out_usr_flag : std_logic;
signal ds_out_rdst    : std_logic_vector( 2 downto 0);
signal ds_out_rb    : std_logic_vector( 2 downto 0);
signal ds_out_rc    : std_logic_vector( 2 downto 0);

signal rf_out_rd_data1  : std_logic_vector(16 downto 0);
signal rf_out_rd_data2  : std_logic_vector(16 downto 0);

signal idex_out_dr1 : std_logic_vector(16 downto 0);
signal idex_out_dr2 : std_logic_vector(16 downto 0);
signal idex_out_alumode : std_logic_vector(2  downto 0);
signal idex_out_regwb : std_logic;
signal idex_out_memwb : std_logic;
signal idex_out_usr_flag : std_logic; 
signal idex_out_ra : std_logic_vector(2  downto 0);
signal idex_out_rb : std_logic_vector(2  downto 0);
signal idex_out_rc : std_logic_vector(2  downto 0);

signal ex_out_AR : std_logic_vector(16 downto 0); --main output
signal ex_out_z_flag : std_logic;
signal ex_out_n_flag : std_logic;
signal ex_out_memwb : std_logic;
signal ex_out_regwb : std_logic;
signal ex_out_rdst  : std_logic_vector(2 downto 0);
signal ex_out_usr_flag : std_logic;

signal exmem_out_ar : std_logic_vector(16 downto 0);
signal exmem_out_regwb : std_logic;
signal exmem_out_memwb : std_logic;
signal exmem_out_ra : std_logic_vector(2  downto 0);
signal exmem_out_usr_flag : std_logic;
signal exmem_out_ra_data : std_logic_vector(16 downto 0);

signal mem_out_reg_wb : std_logic;
signal mem_out_ar : std_logic_vector(16 downto 0);
signal mem_out_ra : std_logic_vector(2  downto 0);
signal mem_out_usr_flag : std_logic;
signal mem_out_RAM_rst_a : std_logic;
signal mem_out_RAM_en_a : std_logic;
signal mem_out_RAM_wen_a : std_logic_vector(0  downto 0);
signal mem_out_RAM_addy_a : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal mem_out_RAM_din_a : std_logic_vector(15 downto 0);
signal mem_out_RAM_dout_a : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal memwb_out_reg_wb : std_logic; 
signal memwb_out_usr_flag : std_logic;
signal memwb_out_ar :  std_logic_vector(16 downto 0);
signal memwb_out_ra : std_logic_vector(2  downto 0);
signal memwb_out_ra_data : std_logic_vector(16 downto 0);

signal wb_out_ar : std_logic_vector(16 downto 0);
signal wb_out_ra : std_logic_vector(2  downto 0);
signal wb_out_ra_wen : STD_LOGIC;

begin
Fetch : ENTITY work.FETCH_CONTROLLER port map (
   clk => clk,
   rst_ex => in_rst_ex,
   rst_ld  => in_rst_ld,
   out_ram_addrb => out_ram_addrb,
   out_output  => fc_out_output,
   in_ram_data  => in_ram_doutb, 
   out_ram_enb   => out_ram_enb 
);

IFID : ENTITY work.IFID_LATCH port map (
   rst        => rst,
   clk        => clk,
   input      => fc_out_output,
   out_opcode => ifid_out_opcode,
   out_ra     => ifid_out_ra,
   out_rb     => ifid_out_rb,
   out_rc     => ifid_out_rc
);

decode_stage_0 : ENTITY work.DECODE_STAGE port map (
    rst          => rst         ,
    in_opcode    => ifid_out_opcode   ,
    in_ra        => ifid_out_ra       ,
    in_rb        => ifid_out_rb       ,
    in_rc        => ifid_out_rc       ,
    in_RF1d      => rf_out_rd_data1     , --works
    in_RF2d      => rf_out_rd_data2     ,--works
    out_RF1a     => ds_out_RF1a    ,--works
    out_RF2a     => ds_out_RF2a    ,--works
    out_RD1      => ds_out_RD1     ,--works
    out_RD2      => ds_out_RD2     ,--works
    out_alumode  => ds_out_alumode ,--works
    out_memwb    => ds_out_memwb   ,--works
    out_regwb    => ds_out_regwb   ,--works
    out_usr_flag => ds_out_usr_flag, --works
    out_rdst     => ds_out_rdst    --works
);
rf : ENTITY work.register_file port map (
   rst  => rst,
   clk => clk,
   rd_index1 => ds_out_RF1a,
   rd_index2 => ds_out_RF2a,
   rd_data1  => rf_out_rd_data1,
   rd_data2  => rf_out_rd_data2,
   wr_index => wb_out_ra,
   wr_data  => wb_out_ar,
   wr_enable => wb_out_ra_wen
);

IDEX : ENTITY work.IDEX_LATCH port map (
   rst  => rst,
   clk => clk,
   in_dr1  => ds_out_RD1,
   in_dr2 => ds_out_RD2,
   in_alumode => ds_out_alumode,
   in_regwb => ds_out_regwb,
   in_memwb => ds_out_memwb,
   in_usr_flag => ds_out_usr_flag,
   in_ra => ds_out_rdst,
   in_rb => ds_out_rb,
   in_rc => ds_out_rc,
   out_dr1 => idex_out_dr1,
   out_dr2 => idex_out_dr2,
   out_alumode => idex_out_alumode,
   out_regwb => idex_out_regwb,
   out_memwb => idex_out_memwb,
   out_usr_flag => idex_out_usr_flag,
   out_ra => idex_out_ra,
   out_rb => idex_out_rb,
   out_rc => idex_out_rc
);
EXECUTE : ENTITY work.EXECUTE_STAGE port map (
   rst  => rst,
   usr_input  => usr_input, --cpu input
   usr_flag => idex_out_usr_flag,
   RD1 => idex_out_dr1,
   RD2 => idex_out_dr2,
   alumode => idex_out_alumode,
   AR => ex_out_AR, --main output
   z_flag => ex_out_z_flag,
   n_flag => ex_out_n_flag,
   
   in_rb_address => idex_out_rb,
   in_rc_address => idex_out_rc,
   in_exmem_forwarding_address => exmem_out_ra,
   in_memwb_forwarding_address => memwb_out_ra,
   in_exmem_forwarded_data => exmem_out_ar,
   in_memwb_forwarded_data => memwb_out_ar,
   
   in_memwb => idex_out_memwb,
   in_regwb => idex_out_regwb,
   in_rdst => idex_out_ra,
   out_memwb => ex_out_memwb,
   out_regwb => ex_out_regwb,
   out_rdst => ex_out_rdst,
   out_usr_flag => ex_out_usr_flag
);

EXMEM : ENTITY work.EXMEM_LATCH port map (
   rst => rst,
   clk => clk,
   in_ar => ex_out_AR,
   in_regwb => ex_out_regwb,
   in_ra => ex_out_rdst,
   in_memwb =>  ex_out_memwb,
   in_usr_flag => ex_out_usr_flag,
   in_ra_data => idex_out_dr1,
   out_ar =>    exmem_out_ar,
   out_regwb => exmem_out_regwb,
   out_memwb => exmem_out_memwb,
   out_ra => exmem_out_ra,
   out_usr_flag => exmem_out_usr_flag,
   out_ra_data => exmem_out_ra_data
);

MEMORY : ENTITY work.MEMORY_CONTROLLER PORT map (
   rst => rst,
   clk => clk,
   in_ar => exmem_out_ar,
   in_ra => exmem_out_ra,
   in_regwb => exmem_out_regwb,
   in_memwb => exmem_out_memwb,
   in_usr_flag => exmem_out_usr_flag,
   out_reg_wb => mem_out_reg_wb,
   out_ar => mem_out_ar,
   out_ra => mem_out_ra,
   out_RAM_rst_a =>  mem_out_RAM_rst_a,
   out_RAM_en_a   => mem_out_RAM_en_a,
   out_RAM_wen_a  => mem_out_RAM_wen_a,
   out_RAM_addy_a => mem_out_RAM_addy_a,
   out_RAM_din_a => mem_out_RAM_din_a,
   out_RAM_dout_a => mem_out_RAM_dout_a,
   out_usr_flag => mem_out_usr_flag
);  

MEMWB : ENTITY work.MEMWB_LATCH PORT map (
   rst => rst,
   clk => clk,
   in_reg_wb => mem_out_reg_wb,
   in_ar => mem_out_ar,
   in_ra => mem_out_ra,
   in_usr_flag => mem_out_usr_flag,
   in_ra_data => exmem_out_ra_data,
   out_reg_wb => memwb_out_reg_wb,
   out_ar => memwb_out_ar,
   out_ra => memwb_out_ra,
   out_usr_flag => memwb_out_usr_flag,
   out_ra_data => memwb_out_ra_data
);          

WRITEBACK : ENTITY work.WRITE_BACK_CONTROLLER port map (
   rst => rst,
   clk => clk,
   in_reg_wb => memwb_out_reg_wb,
   in_ar => memwb_out_ar,
   in_ra => memwb_out_ra,
   in_usr_flag => memwb_out_usr_flag,
   in_ra_data => memwb_out_ra_data,
   out_cpu => usr_output,
   out_ar => wb_out_ar,
   out_ra => wb_out_ra,
   out_ra_wen => wb_out_ra_wen
);   
   FSM: process(in_rst_ld, in_rst_ex, rst)
   begin
      if( in_rst_ld = '1' or in_rst_ex = '1') then
      rst <= '1';
   else 
      rst <= '0';
   end if;
   -- pull down rom and ram a
   out_ram_rstb <= '0';


   out_ram_dina   <= X"0000"; 
   out_ram_addra  <='0'&x"000";
   out_ram_wea    <= "0";
   out_ram_rsta   <= '0';
   out_ram_ena   <= '0';

   out_rom_adr    <= x"0000";
   out_rom_rd_en  <= '0';
   out_rom_rst    <= '0';
   out_rom_rd     <= '0';
   end process FSM;
end level_1;