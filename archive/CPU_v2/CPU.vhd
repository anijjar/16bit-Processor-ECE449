LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      in_rst_ld : IN STD_LOGIC;
      in_rst_ex : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- RAM
      in_ram_douta : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_ram_dina : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_ram_addra : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
      out_ram_wea : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      out_ram_rsta : OUT STD_LOGIC;
      out_ram_ena : OUT STD_LOGIC;
      in_ram_doutb : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_ram_enb : OUT STD_LOGIC;
      out_ram_addrb : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
      out_ram_rstb : OUT STD_LOGIC;
      -- ROM
      in_rom_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_rom_adr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_rom_rd_en : OUT STD_LOGIC;
      out_rom_rst : OUT STD_LOGIC;
      out_rom_rd : OUT STD_LOGIC; --dont use
      -- user I/O
      usr_input : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      usr_output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
   );
END CPU;

ARCHITECTURE level_1 OF CPU IS
   SIGNAL rst : STD_LOGIC;
   SIGNAL fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL ifid_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL ifid_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ifid_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ifid_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);

   SIGNAL ds_out_RF1a : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_RF2a : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_RD1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL ds_out_RD2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL ds_out_alumode : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_memwb : STD_LOGIC;
   SIGNAL ds_out_m1 : STD_LOGIC;
   SIGNAL ds_out_regwb : STD_LOGIC;
   SIGNAL ds_out_usr_flag : STD_LOGIC;
   SIGNAL ds_out_rdst : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);

   SIGNAL rf_out_rd_data1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL rf_out_rd_data2 : STD_LOGIC_VECTOR(16 DOWNTO 0);

   SIGNAL idex_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL idex_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL idex_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL idex_out_alumode : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_regwb : STD_LOGIC;
   SIGNAL idex_out_memwb : STD_LOGIC;
   SIGNAL idex_out_m1 : STD_LOGIC;
   SIGNAL idex_out_usr_flag : STD_LOGIC;
   SIGNAL idex_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);

   SIGNAL ex_out_AR : STD_LOGIC_VECTOR(16 DOWNTO 0); --main output
   SIGNAL ex_out_z_flag : STD_LOGIC;
   SIGNAL ex_out_n_flag : STD_LOGIC;
   SIGNAL ex_out_memwb : STD_LOGIC;
   SIGNAL ex_out_regwb : STD_LOGIC;
   SIGNAL ex_out_rdst : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ex_out_usr_flag : STD_LOGIC;

   SIGNAL exmem_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL exmem_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_regwb : STD_LOGIC;
   SIGNAL exmem_out_memwb : STD_LOGIC;
   SIGNAL exmem_out_m1 : STD_LOGIC;
   SIGNAL exmem_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL exmem_out_usr_flag : STD_LOGIC;
   SIGNAL exmem_out_ra_data : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);

   SIGNAL mem_out_RAM_rst_a : STD_LOGIC;
   SIGNAL mem_out_RAM_en_a : STD_LOGIC;
   SIGNAL mem_out_RAM_wen_a : STD_LOGIC_VECTOR(0 DOWNTO 0);
   SIGNAL mem_out_RAM_addy_a : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL mem_out_RAM_din_a : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL mem_out_RAM_dout_a : STD_LOGIC_VECTOR(15 DOWNTO 0);

   SIGNAL memwb_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL memwb_out_reg_wb : STD_LOGIC;
   SIGNAL memwb_out_usr_flag : STD_LOGIC;
   SIGNAL memwb_out_m1 : STD_LOGIC;
   SIGNAL memwb_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL memwb_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL memwb_out_ra_data : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL memwb_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL memwb_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);

   SIGNAL wb_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL wb_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL wb_out_ra_wen : STD_LOGIC;

BEGIN
   Fetch : ENTITY work.FETCH_CONTROLLER PORT MAP (
      clk => clk,
      rst_ex => in_rst_ex,
      rst_ld => in_rst_ld,
      out_ram_addrb => out_ram_addrb,
      out_output => fc_out_output,
      in_ram_data => in_ram_doutb,
      out_ram_enb => out_ram_enb
      );

   IFID : ENTITY work.IFID_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      input => fc_out_output,
      out_opcode => ifid_out_opcode,
      out_ra => ifid_out_ra,
      out_rb => ifid_out_rb,
      out_rc => ifid_out_rc
      );

   decode_stage_0 : ENTITY work.DECODE_STAGE PORT MAP (
      rst => rst,
      in_opcode => ifid_out_opcode,
      in_ra => ifid_out_ra,
      in_rb => ifid_out_rb,
      in_rc => ifid_out_rc,
      in_RF1d => rf_out_rd_data1, --works
      in_RF2d => rf_out_rd_data2, --works
      out_m1 => ds_out_m1,
      out_RF1a => ds_out_RF1a, --works
      out_RF2a => ds_out_RF2a, --works
      out_RD1 => ds_out_RD1, --works
      out_RD2 => ds_out_RD2, --works
      out_alumode => ds_out_alumode, --works
      out_memwb => ds_out_memwb, --works
      out_regwb => ds_out_regwb, --works
      out_usr_flag => ds_out_usr_flag, --works
      out_rdst => ds_out_rdst --works
      );
   rf : ENTITY work.register_file PORT MAP (
      rst => rst,
      clk => clk,
      rd_index1 => ds_out_RF1a,
      rd_index2 => ds_out_RF2a,
      rd_data1 => rf_out_rd_data1,
      rd_data2 => rf_out_rd_data2,
      wr_index => wb_out_ra,
      wr_data => wb_out_ar,
      wr_enable => wb_out_ra_wen
      );

   IDEX : ENTITY work.IDEX_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_opcode => ifid_out_opcode,
      in_dr1 => ds_out_RD1,
      in_dr2 => ds_out_RD2,
      in_alumode => ds_out_alumode,
      in_regwb => ds_out_regwb,
      in_memwb => ds_out_memwb,
      in_m1 => ds_out_m1,
      in_usr_flag => ds_out_usr_flag,
      in_ra => ds_out_rdst,
      in_rb => ds_out_rb,
      in_rc => ds_out_rc,
      out_opcode => idex_out_opcode,
      out_dr1 => idex_out_dr1,
      out_dr2 => idex_out_dr2,
      out_alumode => idex_out_alumode,
      out_regwb => idex_out_regwb,
      out_memwb => idex_out_memwb,
      out_m1 => idex_out_m1,
      out_usr_flag => idex_out_usr_flag,
      out_ra => idex_out_ra,
      out_rb => idex_out_rb,
      out_rc => idex_out_rc
      );
   EXECUTE : ENTITY work.EXECUTE_STAGE PORT MAP (
      rst => rst,
      usr_input => usr_input, --cpu input
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
      out_rdst => ex_out_rdst,
      );

   EXMEM : ENTITY work.EXMEM_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_opcode => idex_out_opcode,
      in_ar => ex_out_AR,
      in_regwb => idex_out_regwb,
      in_ra => ex_out_rdst,
      in_memwb => idex_out_memwb,
      in_usr_flag => idex_out_usr_flag,
      in_ra_data => idex_out_dr1,
      in_dr1 => idex_out_dr1,
      in_dr2 => idex_out_dr2,
      in_m1 => idex_out_m1,

      out_dr1 => exmem_out_dr1,
      out_dr2 => exmem_out_dr2,
      out_opcode => exmem_out_opcode,
      out_m1 => exmem_out_m1,
      out_ar => exmem_out_ar,
      out_regwb => exmem_out_regwb,
      out_memwb => exmem_out_memwb,
      out_ra => exmem_out_ra,
      out_usr_flag => exmem_out_usr_flag,
      out_ra_data => exmem_out_ra_data
      );

   MEMORY : ENTITY work.MEMORY_CONTROLLER PORT MAP (
      rst => rst,
      in_dr1 => exmem_out_ar,
      in_dr2 => exmem_out_ra,
      in_memwb => exmem_out_memwb,
      out_reg_wb => mem_out_reg_wb,
      out_RAM_rst_a => mem_out_RAM_rst_a,
      out_RAM_en_a => mem_out_RAM_en_a,
      out_RAM_wen_a => mem_out_RAM_wen_a,
      out_RAM_addy_a => mem_out_RAM_addy_a,
      out_RAM_din_a => mem_out_RAM_din_a,
      out_RAM_dout_a => mem_out_RAM_dout_a,
      out_usr_flag => mem_out_usr_flag
      );

   MEMWB : ENTITY work.MEMWB_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_m1 => exmem_out_m1,
      in_opcode => exmem_out_opcode,
      in_reg_wb => mem_out_reg_wb,
      in_ar => exmem_out_ar,
      in_ra => exmem_out_ra,
      in_usr_flag => mem_out_usr_flag,
      in_ra_data => exmem_out_ra_data,
      in_dr1 => exmem_out_dr1,
      in_dr2 => exmem_out_dr2,
      out_m1 => memwb_out_m1,
      out_opcode => memwb_out_opcode,
      out_dr1 => memwb_out_dr1,
      out_dr2 => memwb_out_dr2,
      out_reg_wb => memwb_out_reg_wb,
      out_ar => memwb_out_ar,
      out_ra => memwb_out_ra,
      out_usr_flag => memwb_out_usr_flag,
      out_ra_data => memwb_out_ra_data
      );

   WRITEBACK : ENTITY work.WRITE_BACK_CONTROLLER PORT MAP (
      rst => rst,
      clk => clk,
      in_m1 => memwb_out_m1,
      in_opcode => memwb_out_opcode,
      in_dr1 => memwb_out_dr1,
      in_dr2 => memwb_out_dr2,
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

   FSM : PROCESS (in_rst_ld, in_rst_ex, rst)
   BEGIN
      IF (in_rst_ld = '1' OR in_rst_ex = '1') THEN
         rst <= '1';
      ELSE
         rst <= '0';
      END IF;
      -- pull down rom
      out_rom_adr <= x"0000";
      out_rom_rd_en <= '0';
      out_rom_rst <= '0';
      out_rom_rd <= '0';
   END PROCESS FSM;
END level_1;