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
      out_ram_addra  : out std_logic_vector(9 downto 0);
      out_ram_wea    : out std_logic_vector(0 downto 0);
      out_ram_rsta   : out std_logic;
      out_ram_ena    : out std_logic;
      in_ram_doutb  : in std_logic_vector(N-1 downto 0);
      out_ram_enb    : out std_logic;
      out_ram_addrb  : out std_logic_vector(9 downto 0);
      out_ram_rstb   : out std_logic;
      -- ROM
      in_rom_data   : in  std_logic_vector(N-1 downto 0);
      out_rom_adr    : out std_logic_vector(9 downto 0);
      out_rom_rd_en  : out std_logic;
      out_rom_rst    : out std_logic;
      out_rom_rd     : out std_logic; --dont use
      -- user I/O
      usr_input  : in  std_logic_vector(N-1 downto 0);              
      usr_output : out std_logic_vector(N-1 downto 0);
      btn1 : in std_logic ;
      btn2 : in std_logic ;
      btn3 : in std_logic;
      display : out std_logic_vector(N-1 downto 0);
      dip_switches : in std_logic_vector(N-1 downto 0);
      leds : out std_logic_vector(N-1 downto 0)        
   );   
END CPU;

ARCHITECTURE level_1 OF CPU IS
signal rst            :  std_logic;

signal fs_pc         : std_logic_vector(15 downto 0);
signal fs_pc2        : std_logic_vector(15 downto 0);
signal fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal ifid_out_opcode : std_logic_vector( 6 downto 0);
signal ifid_data     : std_logic_vector(  8 downto 0);
signal ifid_pc       : std_logic_vector(15 downto 0);
signal ifid_pc2      : std_logic_vector(15 downto 0);

signal ds_out_RF1a    : std_logic_vector( 2 downto 0);
signal ds_out_RF2a    : std_logic_vector( 2 downto 0);
signal ds_out_RD1     : std_logic_vector(16 downto 0);
signal ds_out_RD2     : std_logic_vector(16 downto 0);
signal ds_out_alumode : std_logic_vector( 2 downto 0);
signal ds_out_memwb   : std_logic;
signal ds_out_regwb   : std_logic;
signal ds_out_usr_flag : std_logic;
signal ds_out_rdst    : std_logic_vector( 2 downto 0);
signal ds_brch_adr   : std_logic_vector(15 downto 0);
signal ds_brch_tkn   : std_logic;
signal ds_fwd_flag : std_logic_vector(1 downto 0);
signal ds_passthru_flag : std_logic;
signal ds_passthru_data : std_logic_vector(16 downto 0);
SIGNAL ds_out_memrd : STD_LOGIC;
SIGNAL ds_out_m1 : STD_LOGIC;

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
signal idex_fwd_flag : std_logic_vector(1 downto 0);
signal idex_passthru_flag : std_logic;
signal idex_passthru_data : std_logic_vector(16 downto 0);
SIGNAL idex_out_memrd : STD_LOGIC;
SIGNAL idex_out_m1 : STD_LOGIC;
SIGNAL idex_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);

signal ex_out_AR : std_logic_vector(16 downto 0); --main output
signal ex_out_z_flag : std_logic;
signal ex_out_n_flag : std_logic;
signal es_flags      : std_logic_vector(  2 downto 0);
signal ex_out_v_flag : std_logic;

signal exmem_fwd_flag : std_logic_vector(1 downto 0);
signal exmem_out_ar : std_logic_vector(16 downto 0);
signal exmem_out_regwb : std_logic;
signal exmem_out_memwb : std_logic;
signal exmem_out_ra : std_logic_vector(2  downto 0);
signal exmem_out_usr_flag : std_logic;
signal exmem_out_ra_data : std_logic_vector(16 downto 0);
SIGNAL exmem_out_memrd : STD_LOGIC;
SIGNAL exmem_out_m1 : STD_LOGIC;
SIGNAL exmem_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL exmem_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL exmem_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
SIGNAL exmem_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);

SIGNAL mem_ram_a_data : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal memwb_fwd_flag : std_logic_vector(1 downto 0);
signal memwb_out_reg_wb : std_logic; 
signal memwb_out_usr_flag : std_logic;
signal memwb_out_ar :  std_logic_vector(16 downto 0);
signal memwb_out_ra : std_logic_vector(2  downto 0);
signal memwb_out_ra_data : std_logic_vector(16 downto 0);
SIGNAL memwb_ram_a_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL memwb_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL memwb_out_m1 : STD_LOGIC;
SIGNAL memwb_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);

signal wb_out_ar : std_logic_vector(16 downto 0);
signal wb_out_ra : std_logic_vector(2  downto 0);
signal wb_out_ra_wen : STD_LOGIC;


begin
Fetch : ENTITY work.FETCH_STAGE port map (
    rst => rst,
   clk           => clk,
   rst_ex        => in_rst_ex,
   rst_ld        => in_rst_ld,
   out_ram_addrb => out_ram_addrb,
   out_output    => fc_out_output,
   in_ram_data   => in_ram_doutb, 
   out_ram_enb   => out_ram_enb,
   out_ram_rstb   => out_ram_rstb,
   in_branch_adr => ds_brch_adr,
   in_branch_tkn => ds_brch_tkn,
   out_pc        => fs_pc,
   out_pc2       => fs_pc2,
   in_rom_data    => in_rom_data,
   out_rom_rd_en => out_rom_rd_en,
   out_rom_adr => out_rom_adr,
   out_rom_rst => out_rom_rst,
   out_rom_rd => out_rom_rd
);


IFID : ENTITY work.IFID_LATCH port map (
   rst        => rst,
   clk        => clk,
   in_input   => fc_out_output,
   in_pc      => fs_pc,
   in_pc2     => fs_pc2,
   out_opcode => ifid_out_opcode,
   out_data   => ifid_data,
   out_pc     => ifid_pc,
   out_pc2    => ifid_pc2
);

es_flags <= ex_out_z_flag & ex_out_n_flag & ex_out_v_flag;
decode_stage_0 : ENTITY work.DECODE_STAGE port map (
   rst          => rst         ,
   in_opcode    => ifid_out_opcode   ,
   in_data      => ifid_data, 
   in_RF1d      => rf_out_rd_data1     , --works
   in_RF2d      => rf_out_rd_data2     ,--works
   in_flags     => es_flags, 
   in_pc        => ifid_pc, 
   in_pc2       => ifid_pc2, 
   in_exmem_opcode              => exmem_out_opcode,
   in_exmem_forwarding_address  => exmem_out_ra,
   in_exmem_forwarded_data      => exmem_out_ar,
   in_exmem_forwarding_fwd_flag => exmem_fwd_flag,
   out_RF1a     => ds_out_RF1a    ,--works
   out_RF2a     => ds_out_RF2a    ,--works
   out_RD1      => ds_out_RD1     ,--works
   out_RD2      => ds_out_RD2     ,--works
   out_alumode  => ds_out_alumode ,--works
   out_memwb    => ds_out_memwb   ,--works
   out_memrd    => ds_out_memrd   ,
   out_regwb    => ds_out_regwb   ,--works
   out_usr_flag => ds_out_usr_flag, --works
   out_rdst     => ds_out_rdst,    --works
   out_brch_tkn => ds_brch_tkn,
   out_brch_adr => ds_brch_adr, 
   out_passthru => ds_passthru_data, 
   out_fwd_flag => ds_fwd_flag, 
   out_passthru_flag => ds_passthru_flag,
   out_m1 => ds_out_m1
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
   in_opcode => ifid_out_opcode, 
   in_dr1  => ds_out_RD1,
   in_dr2 => ds_out_RD2,
   in_alumode => ds_out_alumode,
   in_regwb => ds_out_regwb,
   in_memwb => ds_out_memwb,
   in_m1 => ds_out_m1,
   in_memrd => ds_out_memrd,
   in_usr_flag => ds_out_usr_flag,
   in_ra => ds_out_rdst,
   in_rb => ds_out_RF1a,
   in_rc => ds_out_RF2a,
   in_passthru => ds_passthru_data, 
   in_passthru_flag => ds_passthru_flag,
   in_fwd_flag => ds_fwd_flag,
   out_opcode => idex_out_opcode,
   out_dr1 => idex_out_dr1,
   out_dr2 => idex_out_dr2,
   out_alumode => idex_out_alumode,
   out_regwb => idex_out_regwb,
   out_memwb => idex_out_memwb,
   out_m1 => idex_out_m1,
   out_memrd => idex_out_memrd,
   out_usr_flag => idex_out_usr_flag,
   out_ra => idex_out_ra,
   out_rb => idex_out_rb,
   out_rc => idex_out_rc,
   out_passthru => idex_passthru_data, 
   out_passthru_flag => idex_passthru_flag, 
   out_fwd_flag => idex_fwd_flag
);

EXECUTE : ENTITY work.EXECUTE_STAGE port map (
   rst                          => rst,
   usr_input                    => usr_input, --cpu input
   usr_flag                     => idex_out_usr_flag,
   RD1                          => idex_out_dr1,
   RD2                          => idex_out_dr2,
   alumode                      => idex_out_alumode,
   in_opcode                    => idex_out_opcode,
   in_exmem_opcode              => exmem_out_opcode,
   in_memwb_opcode              => memwb_out_opcode,
   in_rb_address                => idex_out_rb,
   in_rc_address                => idex_out_rc,
   in_exmem_forwarding_address  => exmem_out_ra,
   in_memwb_forwarding_address  => memwb_out_ra,
   in_exmem_forwarded_data      => exmem_out_ar,
   in_memwb_forwarded_data      => memwb_out_ar,
   passthru_flag                => idex_passthru_flag, 
   in_passthru_data             => idex_passthru_data, 
   fwd_flag                     => idex_fwd_flag,
   AR                           => ex_out_AR, --main output
   out_z_flag                   => ex_out_z_flag,
   out_n_flag                   => ex_out_n_flag,
   out_v_flag                   => ex_out_v_flag
);


EXMEM : ENTITY work.EXMEM_LATCH port map (
   rst          => rst,
   clk          => clk,
   in_m1        => idex_out_m1,
   in_opcode    => idex_out_opcode,
   in_ar        => ex_out_AR,
   in_regwb     => idex_out_regwb,
   in_memwb     => idex_out_memwb,
   in_memrd     => idex_out_memrd,
   in_ra        => idex_out_ra,
   in_usr_flag  => idex_out_usr_flag,
   in_ra_data   => idex_out_dr1,
   in_fwd_flag  => idex_fwd_flag,
   in_dr1       => idex_out_dr1,
   in_dr2       => idex_out_dr2,
   in_rb        => idex_out_rb,
   out_m1       => exmem_out_m1,
   out_opcode   => exmem_out_opcode,
   out_ar       => exmem_out_ar,
   out_regwb    => exmem_out_regwb,
   out_memwb    => exmem_out_memwb,
   out_memrd    => exmem_out_memrd,
   out_ra       => exmem_out_ra,
   out_usr_flag => exmem_out_usr_flag,
   out_ra_data  => exmem_out_ra_data,
   out_fwd_flag => exmem_fwd_flag,
   out_dr1      => exmem_out_dr1,
   out_dr2      => exmem_out_dr2,
   out_rb       => exmem_out_rb
);

MEMORY : ENTITY work.MEMORY_CONTROLLER PORT map (
   rst                          => rst,
   clk                          => clk,
   in_opcode                    => exmem_out_opcode,
   in_dr1                       => exmem_out_dr1,
   in_dr2                       => exmem_out_dr2,
   in_memwb                     => exmem_out_memwb,
   in_memrd                     => exmem_out_memrd,
   in_ra                        => exmem_out_ra,
   in_rb                        => exmem_out_rb,
   in_memwb_opcode              => memwb_out_opcode,
   in_memwb_forwarded_address_a => memwb_out_ra,
   in_memwb_forwarded_address_b => memwb_out_ra, --WHY ALSO A
   in_wb_forwarded_data         => wb_out_ar,
   in_memwb_forwarded_data      => memwb_ram_a_data,
   out_ram_mem                  => mem_ram_a_data, 
   out_RAM_rst_a                => out_ram_rsta,
   out_RAM_en_a                 => out_ram_ena,
   out_RAM_wen_a                => out_ram_wea,
   out_RAM_addy_a               => out_ram_addra,
   out_RAM_din_a                => out_ram_dina,
   out_RAM_dout_a               => in_ram_douta,
   display  => leds -- map the stores to leds
);  

MEMWB : ENTITY work.MEMWB_LATCH PORT map (
   rst          => rst,
   clk          => clk,
   in_m1        => exmem_out_m1,
   in_reg_wb    => exmem_out_regwb,
   in_ar        => exmem_out_ar,
   in_ra        => exmem_out_ra,
   in_rb        => exmem_out_rb,
   in_usr_flag  => exmem_out_usr_flag,
   in_fwd_flag  => exmem_fwd_flag,
   in_ra_data   => exmem_out_ra_data, 
   in_dr2       => exmem_out_dr2,
   in_opcode    => exmem_out_opcode,
   in_ram_mem   => mem_ram_a_data,
   out_m1       => memwb_out_m1,
   out_reg_wb   => memwb_out_reg_wb,
   out_ar       => memwb_out_ar,
   out_ra       => memwb_out_ra,
   out_usr_flag => memwb_out_usr_flag,
   out_fwd_flag => memwb_fwd_flag,
   out_ra_data  => memwb_out_ra_data, 
   out_dr2      => memwb_out_dr2,
   out_opcode   => memwb_out_opcode,
   out_ram_mem  => memwb_ram_a_data
);           

WRITEBACK : ENTITY work.WRITE_BACK_CONTROLLER port map (
   rst         => rst,
   clk => clk,
   in_m1       => memwb_out_m1,
   in_opcode   => memwb_out_opcode,
   in_dr2      => memwb_out_dr2,
   in_reg_wb   => memwb_out_reg_wb,
   in_ar       => memwb_out_ar,
   in_ra       => memwb_out_ra,
   in_usr_flag => memwb_out_usr_flag,
   in_ra_data  => memwb_out_ra_data,
   in_ram_mem  => memwb_ram_a_data,
   out_cpu     => usr_output,
   out_ar      => wb_out_ar,
   out_ra      => wb_out_ra,
   out_ra_wen  => wb_out_ra_wen,
   dip_switches => dip_switches
);            
   FSM: process(in_rst_ld, in_rst_ex, rst, btn1, btn2)
   variable prog_en : integer := 0;
   begin
   if( in_rst_ld = '1' or in_rst_ex = '1') then
      rst <= '1';
      prog_en := 1;
   elsif (prog_en = 0) then 
      rst <= '1';
   else
      rst <= '0';
   end if;
   if( btn1 = '1' and btn2 = '0' and btn3 = '0') then
    display <= fs_pc;
   end if;
   if( btn2 = '1' and btn1 = '0' and btn3 = '0') then
    display <= ex_out_AR(15 downto 0);
   end if;
   if( btn2 = '0' and btn1 = '0' and btn3 = '1') then
    display <= in_ram_douta;
   end if;
   end process FSM;
end level_1;