LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY level_2_tb IS
   --  Port ( );
END level_2_tb;

ARCHITECTURE Behavioral OF level_2_tb IS
signal clk            :  std_logic;
signal rst            :  std_logic;
signal in_rst_ld      :  std_logic;
signal in_rst_ex      :  std_logic;
signal fc_in_ram_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal fc_out_ram_addrb : STD_LOGIC_VECTOR(12 DOWNTO 0);
signal fc_out_ram_enb   : STD_LOGIC;
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

signal usr_input : std_logic_vector(15 downto 0); --cpu input
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

signal usr_output : std_logic_vector(15 downto 0);
signal wb_out_ar : std_logic_vector(16 downto 0);
signal wb_out_ra : std_logic_vector(2  downto 0);
signal wb_out_ra_wen : STD_LOGIC;

BEGIN
Fetch : ENTITY work.FETCH_CONTROLLER port map (
   clk => clk,
   rst_ex => in_rst_ex,
   rst_ld  => in_rst_ld,
   out_ram_addrb => fc_out_ram_addrb,
   out_output  => fc_out_output,
   in_ram_data  => fc_in_ram_data, 
   out_ram_enb   => fc_out_ram_enb 
);

RAM_tb : ENTITY work.RAM PORT MAP(
   Clock => clk, 
   Reset_a => '0', 
   Reset_b => '0', 
   Enable_a => '0', 
   Enable_b => fc_out_ram_enb, 
   Write_en_a => "0", 
   Address_a => '0'&X"000",
   Address_b => fc_out_ram_addrb, 
   data_in_a => X"0000", 
   Data_out_a => DOUTA,
   Data_out_b => fc_in_ram_data
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
    out_rdst     => ds_out_rdst,    --works
    out_rb => ds_out_rb,
    out_rc => ds_out_rc
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
   clock : PROCESS
   BEGIN
      CLK <= '1';
      WAIT FOR 10 us;
      CLK <= '0';
      WAIT FOR 10 us;
   END PROCESS;
   -- goal:
   -- read instructions from RAM and parse it **WORKS**
   -- take parsed instructions and pass into decode stage **WORKS**
   -- execute instructions **works**
      -- multiplication is weird
   -- write the data into memory **fine for now**
      -- forward data to latch for now
   -- write data into register or output
   
   SYSTEM_TESTS : PROCESS
   BEGIN
      in_rst_ex <= '0';
      in_rst_ld <= '0';
      --rst <= '1';
      usr_input <= X"FFFF";
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      --rst <= '0';
--      -- load some values into register
----      rf_in_wr_index <= "000";
----      rf_in_wr_data <= '0'&X"0000";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "001";
----      rf_in_wr_data <= '0'&X"1111";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "010";
----      rf_in_wr_data <= '0'&X"2222";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "011";
----      rf_in_wr_data <= '0'&X"3333";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "100";
----      rf_in_wr_data <= '0'&X"4444";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "101";
----      rf_in_wr_data <= '0'&X"5555";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "110";
----      rf_in_wr_data <= '0'&X"6666";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      -- load some values into register
----      rf_in_wr_index <= "111";
----      rf_in_wr_data <= '0'&X"7777";
----      rf_in_wr_enable <= '1';
--      WAIT UNTIL (CLK = '1' AND CLK'event);
--      rf_in_wr_enable <= '0';
      rst <= '1';
      in_rst_ex <= '1';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      in_rst_ex <= '0';
      rst <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);  
      usr_input <= X"0002";
      WAIT UNTIL (CLK = '1' AND CLK'event);
      usr_input <= X"0003"; 
      WAIT UNTIL (CLK = '1' AND CLK'event);
      usr_input <= X"0001";
      WAIT UNTIL (CLK = '1' AND CLK'event);
      usr_input <= X"0005";
      WAIT;
   END PROCESS;
END Behavioral;