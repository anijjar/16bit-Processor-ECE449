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
      out_ram_addra : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      out_ram_wea : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      out_ram_rsta : OUT STD_LOGIC;
      out_ram_ena : OUT STD_LOGIC;
      in_ram_doutb : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_ram_enb : OUT STD_LOGIC;
      out_ram_addrb : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      out_ram_rstb : OUT STD_LOGIC;
      -- ROM
      in_rom_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_rom_adr : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      out_rom_rd_en : OUT STD_LOGIC;
      out_rom_rst : OUT STD_LOGIC;
      out_rom_rd : OUT STD_LOGIC; --dont use
      -- user I/O
      CPU_input : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      CPU_output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      btn1 : IN STD_LOGIC;
      btn2 : IN STD_LOGIC;
      btn3 : IN STD_LOGIC;
      display : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      dip_switches : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      leds : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END CPU;

ARCHITECTURE level_1 OF CPU IS
   SIGNAL rst : STD_LOGIC;

   SIGNAL fs_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL fs_pc2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);

   SIGNAL ifid_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL ifid_data : STD_LOGIC_VECTOR(8 DOWNTO 0);
   SIGNAL ifid_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL ifid_pc2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

   SIGNAL ds_out_RF1a : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_RF2a : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_RD1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL ds_out_RD2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL ds_out_alumode : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ds_brch_adr : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL ds_brch_tkn : STD_LOGIC;
   SIGNAL ds_out_m1 : STD_LOGIC;

   SIGNAL rf_out_rd_data1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL rf_out_rd_data2 : STD_LOGIC_VECTOR(16 DOWNTO 0);

   SIGNAL idex_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL idex_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL idex_out_alumode : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL idex_out_m1 : STD_LOGIC;
   SIGNAL idex_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);

   SIGNAL ex_out_result : STD_LOGIC_VECTOR(16 DOWNTO 0); --main output
   SIGNAL ex_out_z_flag : STD_LOGIC;
   SIGNAL ex_out_n_flag : STD_LOGIC;
   SIGNAL es_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL ex_out_v_flag : STD_LOGIC;

   SIGNAL exmem_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL exmem_out_dr1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_m1 : STD_LOGIC;
   SIGNAL exmem_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL exmem_out_rb : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL exmem_out_dr2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL exmem_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL mem_output_data : STD_LOGIC_VECTOR(16 DOWNTO 0);

   SIGNAL memwb_out_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL memwb_output_data : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL memwb_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL memwb_out_rc : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL memwb_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);
   SIGNAL memwb_out_m1 : STD_LOGIC;

   SIGNAL wb_out_ra_wen : STD_LOGIC;
   SIGNAL wb_out_ra : STD_LOGIC_VECTOR(2 DOWNTO 0);
   SIGNAL wb_out_ar : STD_LOGIC_VECTOR(16 DOWNTO 0);

BEGIN
   Fetch : ENTITY work.FETCH_STAGE PORT MAP (
      rst => rst,
      clk => clk,
      rst_ex => in_rst_ex,
      rst_ld => in_rst_ld,
      out_ram_addrb => out_ram_addrb,
      out_output => fc_out_output,
      in_ram_data => in_ram_doutb,
      out_ram_enb => out_ram_enb,
      out_ram_rstb => out_ram_rstb,
      in_branch_adr => ds_brch_adr,
      in_branch_tkn => ds_brch_tkn,
      out_pc => fs_pc,
      out_pc2 => fs_pc2,
      in_rom_data => in_rom_data,
      out_rom_rd_en => out_rom_rd_en,
      out_rom_adr => out_rom_adr,
      out_rom_rst => out_rom_rst,
      out_rom_rd => out_rom_rd
      );
   IFID : ENTITY work.IFID_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_input => fc_out_output,
      in_pc => fs_pc,
      in_pc2 => fs_pc2,
      out_opcode => ifid_out_opcode,
      out_data => ifid_data,
      out_pc => ifid_pc,
      out_pc2 => ifid_pc2
      );

   es_flags <= ex_out_z_flag & ex_out_n_flag & ex_out_v_flag;
   decode_stage_0 : ENTITY work.DECODE_STAGE PORT MAP (
      rst => rst,
      in_opcode => ifid_out_opcode,
      in_data => ifid_data,
      in_RF1d => rf_out_rd_data1,
      in_RF2d => rf_out_rd_data2,
      in_flags => es_flags,
      in_pc => ifid_pc,
      in_pc2 => ifid_pc2,
      in_exmem_opcode => exmem_out_opcode,
      in_exmem_forwarding_address => exmem_out_ra,
      in_exmem_forwarded_data => exmem_out_ar,
      in_exmem_m1 => exmem_out_m1,
      in_wb_opcode => memwb_out_opcode,
      in_wb_forwarding_address => wb_out_ra,
      in_wb_forwarded_data => wb_out_ar,
      in_wb_m1 => memwb_out_m1,
      in_ex_opcode => idex_out_opcode,
      in_ex_forwarding_address => idex_out_ra,
      in_ex_forwarded_data => ex_out_result,
      in_ex_m1 => idex_out_m1,
      out_RF1a => ds_out_RF1a,
      out_RF2a => ds_out_RF2a,
      out_RD1 => ds_out_RD1,
      out_RD2 => ds_out_RD2,
      out_alumode => ds_out_alumode,
      out_ra => ds_out_ra,
      out_brch_tkn => ds_brch_tkn,
      out_brch_adr => ds_brch_adr,
      out_m1 => ds_out_m1
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
      in_m1 => ds_out_m1,
      in_ra => ds_out_ra,
      in_rb => ds_out_RF1a,
      in_rc => ds_out_RF2a,
      out_opcode => idex_out_opcode,
      out_dr1 => idex_out_dr1,
      out_dr2 => idex_out_dr2,
      out_alumode => idex_out_alumode,
      out_m1 => idex_out_m1,
      out_ra => idex_out_ra,
      out_rb => idex_out_rb,
      out_rc => idex_out_rc
      );

   EXECUTE : ENTITY work.EXECUTE_STAGE PORT MAP (
      rst => rst,
      in_CPU_input => CPU_input, --cpu input
      in_RD1 => idex_out_dr1,
      in_RD2 => idex_out_dr2,
      in_alumode => idex_out_alumode,
      in_opcode => idex_out_opcode,
      in_exmem_opcode => exmem_out_opcode,
      in_wb_opcode => memwb_out_opcode,
      in_rb => idex_out_rb,
      in_rc => idex_out_rc,
      in_exmem_forwarding_address => exmem_out_ra,
      in_wb_forwarding_address => wb_out_ra,
      in_exmem_forwarded_data => exmem_out_ar,
      in_wb_forwarded_data => wb_out_ar,
      out_result => ex_out_result, --main output
      out_z_flag => ex_out_z_flag,
      out_n_flag => ex_out_n_flag,
      out_v_flag => ex_out_v_flag
      );
   EXMEM : ENTITY work.EXMEM_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_opcode => idex_out_opcode,
      in_m1 => idex_out_m1,
      in_ar => ex_out_result,
      in_ra => idex_out_ra,
      in_dr1 => idex_out_dr1,
      in_rc => idex_out_rc,
      in_dr2 => idex_out_dr2,
      out_opcode => exmem_out_opcode,
      out_m1 => exmem_out_m1,
      out_ar => exmem_out_ar,
      out_ra => exmem_out_ra,
      out_dr1 => exmem_out_dr1,
      out_dr2 => exmem_out_dr2,
      out_rc => exmem_out_rc
      );

   MEMORY : ENTITY work.MEMORY_CONTROLLER PORT MAP (
      rst => rst,
      in_opcode => exmem_out_opcode,
      in_ra => exmem_out_ra,
      in_dr1 => exmem_out_dr1,
      in_rc => exmem_out_rc,
      in_dr2 => exmem_out_dr2,
      in_ar => exmem_out_ar, -- data input
      in_wb_opcode => memwb_out_opcode,
      in_wb_forwarded_address => wb_out_ra,
      in_wb_forwarded_data => wb_out_ar, --this is for loadimm
      output_data => mem_output_data, --main output (ar or ram)
      out_RAM_rst_a => out_ram_rsta,
      out_RAM_en_a => out_ram_ena,
      out_RAM_wen_a => out_ram_wea,
      out_RAM_addy_a => out_ram_addra,
      out_RAM_din_a => out_ram_dina,
      in_RAM_dout_a => in_ram_douta,
      display => leds, -- map the stores to leds
      dip_switches => dip_switches
      );

   MEMWB : ENTITY work.MEMWB_LATCH PORT MAP (
      rst => rst,
      clk => clk,
      in_m1 => exmem_out_m1,
      in_ar => exmem_out_ar,
      in_ra => exmem_out_ra,
      in_rc => exmem_out_rc,
      in_output_data => mem_output_data,
      in_opcode => exmem_out_opcode,
      out_m1 => memwb_out_m1,
      out_ra => memwb_out_ra,
      out_rc => memwb_out_rc,
      out_output_data => memwb_output_data,
      out_opcode => memwb_out_opcode
      );

   WRITEBACK : ENTITY work.WRITE_BACK_CONTROLLER PORT MAP (
      rst => rst,
      in_m1 => memwb_out_m1,
      in_opcode => memwb_out_opcode,
      in_ar => memwb_output_data, --for everything else
      in_ra => memwb_out_ra,
      in_rc => memwb_out_rc,
      out_cpu => CPU_output,
      out_ar => wb_out_ar,
      out_ra => wb_out_ra,
      out_ra_wen => wb_out_ra_wen
      );

   FSM : PROCESS (in_rst_ld, in_rst_ex, rst, btn1, btn2)
      VARIABLE prog_en : INTEGER := 0;
   BEGIN
      IF (in_rst_ld = '1' OR in_rst_ex = '1') THEN
         rst <= '1';
         prog_en := 1;
      ELSIF (prog_en = 0) THEN
         rst <= '1';
      ELSE
         rst <= '0';
      END IF;
      IF (btn1 = '1' AND btn2 = '0' AND btn3 = '0') THEN
         display <= fs_pc; --pc
      END IF;
      IF (btn1 = '0' AND btn2 = '1' AND btn3 = '0') THEN
         display <= ex_out_result(15 DOWNTO 0); --alu
      END IF;
      IF (btn1 = '0' AND btn2 = '0' AND btn3 = '1') THEN
         display <= out_rom_adr; -- instruction
      END IF;
   END PROCESS FSM;
END level_1;