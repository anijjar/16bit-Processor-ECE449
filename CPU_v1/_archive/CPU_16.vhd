LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU_16 IS
    PORT (
        rst_load   : in  std_logic;
        rst_ex     : in  std_logic;
        clk        : in  std_logic;
		-- RAM
		ram_dina   : out  std_logic_vector(15 downto 0);
        ram_addra  : out std_logic_vector(15 downto 0);
		ram_addrb  : out std_logic_vector(15 downto 0);
		ram_wea    : out std_logic_vector(0 downto 0);
		ram_rsta   : out std_logic;
		ram_rstb   : out std_logic;
		ram_ena    : out std_logic;
		ram_enb    : out std_logic;
        ram_douta  : in std_logic_vector(15 downto 0);
		ram_doutb  : in std_logic_vector(15 downto 0);
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
END CPU_16;
    
ARCHITECTURE behavioural OF CPU_16 IS

    ----+---- COMMON ----+----
    -- register file --
    component register_file is port (
        rst       : IN  std_logic;
        clk       : IN  std_logic;
        rd_index1 : IN  std_logic_vector( 2 downto 0);
        rd_index2 : IN  std_logic_vector( 2 downto 0);
        rd_data1  : OUT std_logic_vector(16 downto 0);
        rd_data2  : OUT std_logic_vector(16 downto 0);
        wr_index  : IN  std_logic_vector( 2 downto 0);
        wr_data   : IN  std_logic_vector(16 downto 0);
        wr_enable : IN  std_logic
    );
    end component register_file;
    -- end register file --
    -- MUX_16_2x1 --
    component MUX_16_2x1 is port 
    (
        SEL : IN  std_logic;
        A   : IN  std_logic_vector(15 downto 0);
        B   : IN  std_logic_vector(15 downto 0);
        C   : OUT std_logic_vector(15 downto 0)
    );
    end component MUX_16_2x1;
    -- end MUX_16_2x1 --
    -- end register file --
    signal rst             : std_logic;
    signal rf_rd_index1    : std_logic_vector( 2 downto 0);
    signal rf_rd_index2    : std_logic_vector( 2 downto 0);
    signal rf_rd_data1     : std_logic_vector(16 downto 0);
    signal rf_rd_data2     : std_logic_vector(16 downto 0);
    signal rf_wr_index     : std_logic_vector( 2 downto 0);
    signal rf_wr_data      : std_logic_vector(16 downto 0);
    signal rf_wr_enable    : std_logic;
    signal data_to_IFID    : std_logic_vector(15 downto 0);
    ----+---- end COMMON ----+----

    ----+---- FETCH ----+----
    -- PC --
    component PC is port (
        clk  : in  std_logic;
        con  : in  std_logic_vector( 1 downto 0);
        pc_i : in  std_logic_vector(15 downto 0);
        pc_o : out std_logic_vector(15 downto 0)
    ); 
    end component PC;
    -- end PC --
    -- Fetch Controller --
    component FETCH_CONTROLLER is port 
    (
        rst_exe   : in  std_logic;
        rst_load  : in  std_logic;
        stall     : in  std_logic;
        pc_adr_i  : in  std_logic_vector(15 downto 0);
        pc_adr_o  : out std_logic_vector(15 downto 0);
        pc_con    : out std_logic_vector( 1 downto 0);
        rom_rd_en : out std_logic;
        ram_rd_en : out std_logic;
        rom_adr   : out std_logic_vector(15 downto 0);
        ram_adr   : out std_logic_vector(15 downto 0);
        mem_sel   : out std_logic
    );
    end component FETCH_CONTROLLER;
    -- end Fetch Controller --
    -- IF/ID latch --
    component IFID_LATCH is port (
        rst        : in  std_logic;
        clk        : in  std_logic;
        in_instruction    : in  std_logic_vector(15 downto 0);
        out_opcode : out std_logic_vector( 6 downto 0);
        out_ra     : out std_logic_vector( 2 downto 0);
        out_rb     : out std_logic_vector( 2 downto 0);
        out_rc     : out std_logic_vector( 2 downto 0);
        out_imm     : out std_logic_vector(3 downto 0)
    );
    end component IFID_LATCH;
    -- end IF/ID Latch -- 
    signal pc_con          : std_logic_vector( 1 downto 0);
    signal pc_in           : std_logic_vector(15 downto 0);
    signal pc_out          : std_logic_vector(15 downto 0);
    signal fc_stall        : std_logic;
    signal fc_rom_rd_en    : std_logic;
    signal fc_ram_rd_en    : std_logic;
    signal fc_rom_adr      : std_logic_vector(15 downto 0);
    signal fc_ram_adr      : std_logic_vector(15 downto 0);
    signal fc_mem_sel      : std_logic;
    signal ifid_out_opcode : std_logic_vector( 6 downto 0);
    signal ifid_out_ra     : std_logic_vector( 2 downto 0);
    signal ifid_out_rb     : std_logic_vector( 2 downto 0);
    signal ifid_out_rc     : std_logic_vector( 2 downto 0);
    signal ifid_out_imm    : std_logic_vector( 3 downto 0);
    ----+---- end Fetch ----+----

    ----+---- Decode ----+----
    -- Decode Controller --
    component DECODE_CONTROLLER is port (
        rst     : in  std_logic;
        opcode  : in  std_logic_vector( 6 downto 0);
        alumode : out std_logic_vector( 2 downto 0);
        ra      : in  std_logic_vector( 2 downto 0);
        rb      : in  std_logic_vector( 2 downto 0);
        rc      : in  std_logic_vector( 2 downto 0);
        rdst    : out std_logic_vector( 2 downto 0);
        r1a     : out std_logic_vector( 2 downto 0);
        r2a     : out std_logic_vector( 2 downto 0);
        altd2   : out std_logic_vector(16 downto 0);
        r2den   : out std_logic;
        regwb   : out std_logic;
        memwb   : out std_logic
    );
    end component DECODE_CONTROLLER;
    -- end Decode Controller --
    -- ID/EX Latch --
    component IDEX_LATCH is port (
        rst         : IN STD_LOGIC;
        clk         : IN STD_LOGIC;
        in_dr1      : in  std_logic_vector(16 downto 0);
        in_dr2      : in  std_logic_vector(16 downto 0);
        in_alumode  : in  std_logic_vector( 2 downto 0);
        in_regwb    : in  std_logic;
        in_memwb    : in  std_logic;
        in_ra       : in  std_logic_vector( 2 downto 0);
        in_rb       : in  std_logic_vector( 2 downto 0);
        out_dr1     : out std_logic_vector(16 downto 0);
        out_dr2     : out std_logic_vector(16 downto 0);
        out_alumode : out std_logic_vector( 2 downto 0);
        out_regwb   : out std_logic;
        out_memwb   : out std_logic;
        out_ra      : out std_logic_vector( 2 downto 0);
        out_rb      : out std_logic_vector( 2 downto 0)
    );
    end component IDEX_LATCH;
    -- end ID/EX Latch --
    signal dc_alumode_out   : std_logic_vector( 6 downto 0);
    signal dc_rdst_out      : std_logic_vector( 2 downto 0);
    signal dc_r1a_out       : std_logic_vector( 2 downto 0);
    signal dc_r2a_out       : std_logic_vector( 2 downto 0);
    signal dc_altd2_out     : std_logic_vector(16 downto 0);
    signal dc_r2gen_out     : std_logic;
    signal dc_regwb_out     : std_logic;
    signal dc_memwb_out     : std_logic;
    signal idex_dr1_out     : std_logic_vector(16 downto 0);
    signal idex_dr2_out     : std_logic_vector(16 downto 0);
    signal idex_alumode_out : std_logic_vector( 2 downto 0);
    signal idex_regwb_out   : std_logic;
    signal idex_memwb_out   : std_logic;
    signal idex_ra_out      : std_logic_vector( 2 downto 0);
    signal idex_rb_out      : std_logic_vector( 2 downto 0);
    signal RD2_to_IDEX      : std_logic_vector(16 downto 0);
    ----+---- end Decode ----+----

    ----+---- Execute ----+----
    -- ALU --
    component ALU_16 is port (
        rst      : in  std_logic;
        alu_mode : in  std_logic_vector( 2 downto 0);
        in1      : in  std_logic_vector(15 downto 0);
        in2      : in  std_logic_vector(15 downto 0);
        result   : out std_logic_vector(15 downto 0);
        v_flag   : out std_logic;
        z_flag   : out std_logic;
        n_flag   : out std_logic
    );
    end component ALU_16;
    -- end ALU --
    -- EX/Mem Latch --
    component EXMEM_LATCH is port (
        rst       : IN STD_LOGIC;
        clk       : IN STD_LOGIC;
        in_ar     : in  std_logic_vector(16 downto 0);
        in_regwb  : in  std_logic;
        in_memwb  : in  std_logic;
        in_ra     : in  std_logic_vector( 2 downto 0);
        out_ar    : out std_logic_vector(16 downto 0);
        out_regwb : out std_logic;
        out_memwb : out std_logic;
        out_ra    : out std_logic_vector( 2 downto 0)
    );
    end component EXMEM_LATCH;
    -- end EX/Mem Latch --
    signal vreg_rw         : std_logic;
    signal vreg_flag       : std_logic;
    signal alu_result      : std_logic_vector(15 downto 0);
    signal alu_v           : std_logic;
    signal alu_z           : std_logic;
    signal alu_n           : std_logic;
    signal exmem_ar_out    : std_logic_vector(15 downto 0);
    signal exmem_regwb_out : std_logic;
    signal exmem_memwb_out : std_logic;
    signal exmem_ra_out    : std_logic_vector( 2 downto 0);
    ----+---- end Execute ----+----

    ----+---- Memory Access ----+----
	-- MEMORY_CONTROLLER --
    component MEMORY_CONTROLLER is port (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
	  in_ar : IN STD_LOGIC_VECTOR(16 downto 0); -- result of alu
	  in_ra : IN STD_LOGIC_VECTOR(2 downto 0); -- address of dest register
	  in_regwb : IN STD_LOGIC; -- forward to register
	  in_memwb : IN STD_LOGIC; -- write to memory
	  
	  --memwb latch
	  out_reg_wb : out STD_LOGIC; -- 1 for regiseter, 0 for system out
	  out_ar : out std_logic_vector(15 downto 0);
	  out_ra : out std_logic_vector(2 downto 0);
	  
	  --add pins for port a of ram
	  out_RAM_rst_a : out STD_LOGIC;
	  out_RAM_en_a : out STD_LOGIC;
	  out_RAM_wen_a : out std_logic_vector(0 downto 0); 
	  out_RAM_addy_a : out std_logic_vector(15 downto 0); 
	  out_RAM_din_a : out std_logic_vector(15 downto 0);
	  out_RAM_dout_a : in std_logic_vector(15 downto 0)
	);
	end component MEMORY_CONTROLLER;
	-- END MEMORY_CONTROLLER -- 
    -- MEMWB_LATCH --
	component MEMWB_LATCH is port (
	  rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- any input signals
      in_reg_wb : IN STD_LOGIC;
      in_ar : in std_logic_vector(15 downto 0);
      in_ra : in std_logic_vector(2 downto 0);
      -- matching output signals
      out_reg_wb : out STD_LOGIC;
      out_ar : out std_logic_vector(15 downto 0);
      out_ra : out std_logic_vector(2 downto 0)
	);
	end component MEMWB_LATCH;
	-- END MEMWB_LATCH --t
    signal MEM_out_reg_wb : STD_LOGIC; -- 1 for regiseter, 0 for system out
    signal MEM_out_ar : std_logic_vector(15 downto 0);
    signal MEM_out_ra : std_logic_vector(2 downto 0);
    signal MEM_RAM_rst_a : STD_LOGIC;
    signal MEM_RAM_en_a : STD_LOGIC;
    signal MEM_RAM_wen_a : std_logic_vector(0 downto 0); 
    signal MEM_RAM_addy_a : std_logic_vector(15 downto 0); 
    signal MEM_RAM_din_a : std_logic_vector(15 downto 0);
    signal MEM_RAM_dout_a : std_logic_vector(15 downto 0);
    signal MEMWB_reg_wb : STD_LOGIC;
    signal MEMWB_ar : std_logic_vector(15 downto 0);
    signal MEMWB_ra : std_logic_vector(2 downto 0);
    ----+---- end Memory Access ----+----

    ----+---- Write Back ----+----
 	component WRITE_BACK_CONTROLLER is port (
	  rst : IN STD_LOGIC;
	  clk : IN STD_LOGIC;
	  in_reg_wb : out STD_LOGIC; -- 0 FOR OUTPUT PINS, 1 FOR INPUT REGISTER
	  in_ar : in std_logic_vector(15 downto 0);
      in_ra : in std_logic_vector(2 downto 0);
	  -- FOR THE IN INSTRUCTION, TAKE THE RA AND AR VALUES AND PASS IT INTO THE DECODE CONTROLLER
	  -- FOR THE OUT INSTRUCTION, TAKE AR AND PASS IT TO OUTPUT PINS.
     
     out_cpu : out std_logic_vector(15 downto 0);
	  out_ar : out std_logic_vector(15 downto 0); 
      out_ra : out std_logic_vector(2 downto 0) 
	);
	end component WRITE_BACK_CONTROLLER;
	signal WBK_cpu : std_logic_vector(15 downto 0);
	signal WBK_ar : std_logic_vector(15 downto 0);
	signal WBK_ra : std_logic_vector(2 downto 0);
    ----+---- end Write Back ----+----  

begin
    Registers : register_file port map 
    (
        rst => rst,
        clk => clk,
        rd_index1 => rf_rd_index1,
        rd_index2 => rf_rd_index2,
        rd_data1  => rf_rd_data1,
        rd_data2  => rf_rd_data2,
        wr_index  => rf_wr_index,
        wr_data   => rf_wr_data,
        wr_enable => rf_wr_enable
    );
    Program_Counter : PC port map 
    (
        clk  => clk,
        con  => pc_con,
        pc_i => pc_in,
        pc_o => pc_out
    );
   Fetch_Controller_0 : FETCH_CONTROLLER port map 
   (
       rst_exe   => rst_ex,
       rst_load  => rst_load,
       stall     => fc_stall,
       pc_adr_i  => pc_out,
       pc_adr_o  => pc_in,
       pc_con    => pc_con,
       rom_rd_en => fc_rom_rd_en,
       ram_rd_en => fc_ram_rd_en,
       rom_adr   => fc_rom_adr,
       ram_adr   => fc_ram_adr,
       mem_sel   => fc_mem_sel
   );
--    mux_16_2x1_0 : MUX_16_2x1 port map (
--        SEL => fc_mem_sel,
--        A   => rom_data,
--        B   => ram_port_a_data,
--        C   => data_to_IFID
--    );
    IFID : IFID_LATCH port map 
    (
        rst        => rst,
        clk        => clk,
        in_instruction    => data_to_IFID,
        out_opcode => ifid_out_opcode,
        out_ra     => ifid_out_ra,
        out_rb     => ifid_out_rb,
        out_rc     => ifid_out_rc
    );
    Decode_Controller_0 : DECODE_CONTROLLER port map 
    (
        rst     => rst,
        opcode  => ifid_out_opcode,
        alumode => dc_alumode_out,
        ra      => ifid_out_ra,
        rb      => ifid_out_rb,
        rc      => ifid_out_rc,
        rdst    => dc_rdst_out,
        r1a     => dc_r1a_out,
        r2a     => dc_r2a_out,
        altd2   => dc_altd2_out,
        r2den   => dc_r2gen_out,
        regwb   => dc_regwb_out,
        memwb   => dc_memwb_out
    );
    IDEX : IDEX_LATCH port map 
    (
        rst         => rst,
        clk         => clk,
        in_dr1      => rf_rd_data1,
        in_dr2      => RD2_to_IDEX,
        in_alumode  => dc_alumode_out,
        in_regwb    => dc_regwb_out,
        in_memwb    => dc_memwb_out,
        in_ra       => dc_rdst_out,
        in_rb       => dc_r1a_out,
        out_dr1     => idex_dr1_out,
        out_dr2     => idex_dr2_out,
        out_alumode => idex_alumode_out,
        out_regwb   => idex_regwb_out,
        out_memwb   => idex_memwb_out,
        out_ra      => idex_ra_out,
        out_rb      => idex_rb_out
    );
    alu_0 : ALU_16 port map 
    (
        rst      => rst,
        alu_mode => idex_alumode_out,
        in1      => idex_dr1_out,
        in2      => idex_dr2_out, 
        result   => alu_result,
        v_flag   => alu_v,
        z_flag   => alu_z,
        n_flag   => alu_n
    );
--    mux_17_2x1_0 : MUX_17_2x1 port map 
--    (
--        SEL => dc_r2gen_out,
--        A   => dc_altd2_out,
--        B   => rf_rd_data2,
--        C   => RD2_to_IDEX        
--    );
    EXMEM : EXMEM_LATCH port map 
    (
        rst       => rst,
        clk       => clk,
        in_ar     => alu_result,
        in_regwb  => idex_regwb_out,
        in_memwb  => idex_memwb_out,
        in_ra     => idex_ra_out,
        out_ar    => exmem_ar_out,
        out_regwb => exmem_regwb_out,
        out_memwb => exmem_memwb_out,
        out_ra    => exmem_ra_out
    );
  Memory_Controller_0: MEMORY_CONTROLLER port map 
  (
   rst => rst,
   clk => clk,
    in_ar => exmem_ar_out, -- result of alu
    in_ra => exmem_ra_out, -- address of dest register
    in_regwb => exmem_regwb_out, -- forward to register
    in_memwb => exmem_memwb_out, -- write to memory
    
    --memwb latch
    out_reg_wb => MEM_out_reg_wb, -- 1 for regiseter, 0 for system out
    out_ar => MEM_out_ar,
    out_ra => MEM_out_ra,
    
    --add pins for port a of ram
    out_RAM_rst_a   => MEM_RAM_rst_a,
    out_RAM_en_a  => MEM_RAM_en_a,
    out_RAM_wen_a  => MEM_RAM_wen_a,
    out_RAM_addy_a  => MEM_RAM_addy_a,
    out_RAM_din_a  => MEM_RAM_din_a,
    out_RAM_dout_a  => MEM_RAM_dout_a
  );

  MEMWB : MEMWB_LATCH port map
  (
    rst  => rst,
    clk  => clk,
    in_reg_wb => MEM_out_reg_wb,
    in_ar => MEM_out_ar,
    in_ra => MEM_out_ra, 
    out_reg_wb => MEMWB_reg_wb,
    out_ar => MEMWB_ar,
    out_ra => MEMWB_ra
 );
 Write_Back_Controller_0 : WRITE_BACK_CONTROLLER port map
 (
   rst => rst,
   clk => clk,
   in_reg_wb => MEMWB_reg_wb,
   in_ar => MEMWB_ar, 
   in_ra => MEMWB_ra, 
   out_cpu => WBK_cpu,
   out_ar => WBK_ar, -- map to decode controller or register
   out_ra => WBK_ra
 );
--    ----+---- process begin ----+----

END behavioural;