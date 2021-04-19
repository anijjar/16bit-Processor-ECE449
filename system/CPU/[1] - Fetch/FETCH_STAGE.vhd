
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_STAGE IS
   GENERIC (
      N : INTEGER := 16;
      ram_address_length : INTEGER := 10
   );
   PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      rst_ex : IN STD_LOGIC;
      rst_ld : IN STD_LOGIC;
      out_output : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      -- RAM port B (read only)
      in_ram_data : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_ram_addrb : OUT STD_LOGIC_VECTOR(ram_address_length - 1 DOWNTO 0);
      out_ram_enb : OUT STD_LOGIC;
      out_ram_rstb : OUT STD_LOGIC;
      -- rom port
      in_rom_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      out_rom_rd_en : OUT STD_LOGIC;
      out_rom_adr : OUT STD_LOGIC_VECTOR(ram_address_length - 1 DOWNTO 0);
      out_rom_rst : OUT STD_LOGIC;
      out_rom_rd : OUT STD_LOGIC; --dont use
      -- for controllering branches
      in_branch_adr : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      in_branch_tkn : IN STD_LOGIC;
      out_pc : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_pc2 : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
   );
END FETCH_STAGE;

ARCHITECTURE level_2 OF FETCH_STAGE IS
   SIGNAL pc_input : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL pc_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL new_pc : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL pc2 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL rst_pc_adr : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL rst_pc : STD_LOGIC;
   SIGNAL sig_pc_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
   SIGNAL sig_brch_tkn : STD_LOGIC;
   SIGNAL fc_output : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

BEGIN

   pc_latch : ENTITY work.PC_V2 PORT MAP
      (
      clk => clk,
      in_pc => pc_input,
      out_pc => sig_pc_output
      );
   pc2 <= sig_pc_output + x"0002"; -- increment by 2 for the byte addressable
   sig_brch_tkn <= in_branch_tkn;
   mux_newpc : ENTITY work.MUX16_2x1 PORT MAP
      (
      SEL => sig_brch_tkn,
      A => pc2,
      B => in_branch_adr,
      C => new_pc
      );

   fetch_controller_0 : ENTITY work.FETCH_CONTROLLER PORT MAP
      (
      rst => rst,
      clk => clk,
      rst_ex => rst_ex,
      rst_ld => rst_ld,
      out_output => fc_output,
      in_ram_data => in_ram_data,
      out_ram_addrb => out_ram_addrb,
      out_ram_enb => out_ram_enb,
      out_ram_rstb => out_ram_rstb,
      in_pc => sig_pc_output,
      out_pc_rst => rst_pc,
      out_pc => rst_pc_adr,
      in_rom_data => in_rom_data,
      out_rom_rd_en => out_rom_rd_en,
      out_rom_adr => out_rom_adr,
      out_rom_rst => out_rom_rst,
      out_rom_rd => out_rom_rd
      );

   mux_stall : ENTITY work.MUX16_2x1 PORT MAP
      (
      SEL => sig_brch_tkn,
      A => fc_output,
      B => X"0000",
      C => out_output
      );

   mux_newadr : ENTITY work.MUX16_2x1 PORT MAP
      (
      SEL => rst_pc,
      A => new_pc,
      B => rst_pc_adr,
      C => pc_input
      );

   out_pc <= sig_pc_output;
   out_pc2 <= pc2;

END level_2;