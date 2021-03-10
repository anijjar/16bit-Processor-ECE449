LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CPU IS    
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
END CPU;

ARCHITECTURE level_1 OF CPU IS
   -- Fetch stage Signals
   -- signal pc_con          : std_logic_vector( 1 downto 0);
   -- signal pc_in           : std_logic_vector(15 downto 0);
   -- signal pc_out          : std_logic_vector(15 downto 0);
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
   -- Decode stage Signals

   -- Execute stage Signals

   -- Memory stage Signals

   -- Writeback stage Siganls
begin
-- Fetch stage
   -- Controller
   Fetch : ENTITY work.FETCH_CONTROLLER port map (
      rst_exe   => rst_ex,
      rst_load  => rst_load,
      stall     => fc_stall,
      clk       => clk, --added
      -- removed PC ports
      -- pc_adr_i  => pc_out,
      -- pc_adr_o  => pc_in,
      -- pc_con    => pc_con,
      rom_rd_en => fc_rom_rd_en,
      ram_rd_en => fc_ram_rd_en,
      rom_adr   => fc_rom_adr,
      ram_adr   => fc_ram_adr,
      mem_sel   => fc_mem_sel
   );
   -- Latch
   IFID : ENTITY work.IFID_LATCH port map (
      rst        => rst,
      clk        => clk,
      in_instruction => data_to_IFID, -- link to a fetch port. compare rom and ram in fetch controller
      out_opcode => ifid_out_opcode,
      out_ra     => ifid_out_ra,
      out_rb     => ifid_out_rb,
      out_rc     => ifid_out_rc
   );
-- Decode Stage
   -- NOTE: for the 16 and 17 bit muxes, use the MUX_ARRAY file with 'generic port (num => 16)' before the 'port map'.
   -- Controller

-- Execute Stage

-- Memory Stage

-- Writeback Stage

-- PROCESS FOR FINITE STATE MACHINE HERE --
Finite_state_machine: process(clk, rst_load, rst_ex, usr_input)
begin
   if  rising_edge(clk) and rst_load = '1' then
      -- usr_input to RAM
   elsif rising_edge(clk) and rst_ex = '1' then
      -- RAM to IR
   else
      -- do nothing
   end if;
end process Finite_state_machine;

end level_1;