LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU IS    
   PORT (
      rst_load   : in  std_logic;
      rst_ex     : in  std_logic;
      clk        : in  std_logic;
      -- RAM
      ram_douta  : in std_logic_vector(15 downto 0);
      ram_dina   : out  std_logic_vector(15 downto 0);
      ram_addra  : out std_logic_vector(15 downto 0);
      ram_wea    : out std_logic_vector(0 downto 0);
      ram_rsta  : out std_logic;
      ram_ena    : out std_logic;
      ram_doutb  : in std_logic_vector(15 downto 0);
      ram_enb    : out std_logic;
      ram_addrb  : out std_logic_vector(15 downto 0);
      ram_rstb   : out std_logic;
      -- ROM
      rom_data   : in  std_logic_vector(15 downto 0);
      rom_adr    : out std_logic_vector(15 downto 0);
      rom_rd_en  : out std_logic;
      rom_rst    : out std_logic;
      rom_rd     : out std_logic;
      -- user I/O
      usr_input  : in  std_logic_vector(15 downto 0);              
      usr_output : out std_logic_vector(15 downto 0)              
   );   
END CPU;

ARCHITECTURE level_1 OF CPU IS
   ----+---- common ----+----
   signal rst             : std_logic;
   signal rf_rd_index1    : std_logic_vector( 2 downto 0);
   signal rf_rd_index2    : std_logic_vector( 2 downto 0);
   signal rf_rd_data1     : std_logic_vector(16 downto 0);
   signal rf_rd_data2     : std_logic_vector(16 downto 0);
   signal rf_wr_index     : std_logic_vector( 2 downto 0);
   signal rf_wr_data      : std_logic_vector(16 downto 0);
   signal rf_wr_enable    : std_logic;

   -- Fetch stage Signals
   signal fc_stall        : std_logic; -- nothing is driving this one
   signal fc_rst_ex        : std_logic;
   signal fc_rst_ld        : std_logic;
   signal fc_output   : std_logic_vector(15 downto 0);
   signal fc_rom_output   : std_logic_vector(15 downto 0);
   signal ifid_out_opcode : std_logic_vector( 6 downto 0);
   signal ifid_out_ra     : std_logic_vector( 2 downto 0);
   signal ifid_out_rb     : std_logic_vector( 2 downto 0);
   signal ifid_out_rc     : std_logic_vector( 2 downto 0);
   ----+---- Decode stage Signals ----+----
   signal ds_RD1          : std_logic_vector(16 downto 0);
   signal ds_RD2          : std_logic_vector(16 downto 0);
   signal ds_alumode      : std_logic_vector( 2 downto 0);  
   signal ds_regwb        : std_logic;
   signal ds_memwb        : std_logic;
   signal ds_usr_flag     : std_logic;
   signal ds_rdst         : std_logic_vector( 2 downto 0);
   ----+---- Execute stage Signals ----+----
   signal idex_dr1     : std_logic_vector(16 downto 0);
   signal idex_dr2     : std_logic_vector(16 downto 0);
   signal idex_alumode : std_logic_vector( 2 downto 0);
   signal idex_regwb   : std_logic;
   signal idex_memwb   : std_logic;
   signal idex_usr_flag: std_logic;
   signal idex_rdst    : std_logic_vector( 2 downto 0);
   signal es_ar        : std_logic_vector(16 downto 0);
   signal es_z         : std_logic; -- nothing is driving this one
   signal es_n         : std_logic; -- nothing is driving this one
   signal es_regwb     : std_logic;
   signal es_memwb     : std_logic;
   signal es_rdst      : std_logic_vector( 2 downto 0);
   signal exmem_regwb  : std_logic;
   signal exmem_memwb  : std_logic;
   signal exmem_ar  : std_logic_vector(16 downto 0);
   signal exmem_ra  : std_logic_vector(2 downto 0);
   -- Memory stage Signals
   signal mem_out_reg_wb : STD_LOGIC;
   signal mem_out_ar : std_logic_vector(16 downto 0);
   signal mem_out_ra : std_logic_vector(2 downto 0);
   signal memwb_out_reg_wb : STD_LOGIC;
   signal memwb_out_ar : std_logic_vector(16 downto 0);
   signal memwb_out_ra : std_logic_vector(2 downto 0);

begin
----+---- Commmon ----+----
   rf_0 : entity work.register_file port map 
   (
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
-- Fetch stage
   -- Controller
   Fetch : ENTITY work.FETCH_CONTROLLER port map (
      clk => clk,
      stall => fc_stall,   -- basically reset
      rst_ex => fc_rst_ex,
      rst_ld => fc_rst_ld,
      output => fc_output,
      rom_output => fc_rom_output,
      ram_data => ram_doutb,
      ram_addrb => ram_addrb,
      ram_rstb => ram_rstb, 
      ram_enb => ram_enb,
      rom_data => rom_data,  
      rom_adr => rom_adr,
      rom_rd_en => rom_rd_en,  
      rom_rst => rom_rst,
      rom_rd => rom_rd    
   );
   -- Latch
   IFID : ENTITY work.IFID_LATCH port map (
      rst        => rst,
      clk        => clk,
      input      => fc_output,
      out_opcode => ifid_out_opcode,
      out_ra     => ifid_out_ra,
      out_rb     => ifid_out_rb,
      out_rc     => ifid_out_rc
   );
-- Decode Stage
   -- Controller
   Decode : entity work.DECODE_STAGE port map (
      rst     => rst,
      opcode  => ifid_out_opcode,
      ra      => ifid_out_ra,
      rb      => ifid_out_rb,
      rc      => ifid_out_rc,
      RF1d    => rf_rd_data1, 
      RF2d    => rf_rd_data2, 
      RF1a    => rf_rd_index1,
      RF2a    => rf_rd_index2,
      RD1     => ds_RD1,
      RD2     => ds_RD2,
      alumode => ds_alumode,
      memwb   => ds_memwb,
      regwb   => ds_regwb,
      usr_flag => ds_usr_flag,
      rdst    => ds_rdst     
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
-- Execute Stage
   Execute : entity work.EXECUTE_STAGE port map 
   (
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
      out_RAM_rst_a => ram_rsta,
      out_RAM_en_a => ram_ena,
      out_RAM_wen_a => ram_wea,
      out_RAM_addy_a => ram_addra,
      out_RAM_din_a => ram_dina,
      out_RAM_dout_a => ram_douta
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

-- PROCESS FOR FINITE STATE MACHINE HERE --
-- Finite_state_machine: process(clk, rst_load, rst_ex, usr_input)
--    variable mutex : integer := 0; -- set high when ready to execute
-- begin
--    if  rising_edge(clk) and rst_load = '1' and mutex = 0 then
--       -- mutex := 1;
--       -- rst <= '1'; -- turn off pipeline by seting 'rst' signal to '1'
--       -- -- Now only the fetch controller is working...
--       -- fc_rst_ld <= '1'; -- tell PC to reset

--       -- -- take input pins and input into RAM
--       -- ram_dina <= usr_input;
--       -- -- take the ROM output from fetch controller and pass into the ram address
--       -- ram_addra <= fc_rom_output;
--       -- -- fetch controller turned on necessary rom signals

--       -- -- at falling edge, the RAM will send the data at location ram_addra into fetch controller 
--    end if;
--    if rising_edge(clk) and rst_ex = '1' and mutex = 1 then
--       -- -- Begin the Program
--       -- rst <= '0';
--       -- -- fetch controller will start. 
--       -- fc_rst_ex <= '1'; -- tell PC to reset
--    end if;

end process Finite_state_machine;

end level_1;