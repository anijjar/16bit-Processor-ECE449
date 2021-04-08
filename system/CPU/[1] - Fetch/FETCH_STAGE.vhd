
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_STAGE IS
    GENERIC (
        N : INTEGER := 16;
        ram_address_length : integer := 10
    );
    PORT (
        clk        : in  std_logic;
        rst         : in std_logic;
        rst_ex     : in  std_logic; -- reset and run instructions
        rst_ld     : in  std_logic; -- reset and load instructions
        out_output : out std_logic_vector(N-1 downto 0);
        -- RAM port B (read only)
        in_ram_data   : in  std_logic_vector(N-1 downto 0);
        out_ram_addrb : out std_logic_vector(ram_address_length-1 downto 0);
        out_ram_enb   : out std_logic;
        out_ram_rstb  : out std_logic;
        -- rom port
        in_rom_data    : in std_logic_vector(15 downto 0);
        out_rom_rd_en  : out std_logic;
        out_rom_adr    : out std_logic_vector(ram_address_length-1 downto 0);  
        out_rom_rst    : out std_logic;
        out_rom_rd     : out std_logic; --dont use
        -- for controllering branches
        in_branch_adr : in  std_logic_vector(N-1 downto 0);
        in_branch_tkn : in  std_logic;
        out_pc        : out std_logic_vector(N-1 downto 0);
        out_pc2       : out std_logic_vector(N-1 downto 0)
    );
END FETCH_STAGE;

ARCHITECTURE level_2 OF FETCH_STAGE IS
    SIGNAL pc_input  : std_logic_vector(N-1 downto 0); 
    SIGNAL pc_output : std_logic_vector(N-1 downto 0) ; 
    signal new_pc : std_logic_vector(N-1 downto 0);
    signal pc2 : std_logic_vector(N-1 downto 0);
    signal rst_pc_adr : std_logic_vector(N-1 downto 0);
    signal rst_pc : std_logic ;
    signal sig_pc_output : std_logic_vector(N-1 downto 0);
    signal sig_brch_tkn : std_logic;
    signal fc_output : std_logic_vector(N-1 downto 0);
    
BEGIN

    pc_latch : entity work.PC_V2 port map 
    (
        clk    => clk,
        in_pc  => pc_input,
        out_pc => sig_pc_output 
    );
    pc2 <= sig_pc_output + x"0002";
    sig_brch_tkn <= in_branch_tkn;
    mux_newpc : entity work.MUX16_2x1 port map 
    (
        SEL => sig_brch_tkn,
        A   => pc2,
        B   => in_branch_adr,
        C   => new_pc
    );

    fetch_controller_0 : entity work.FETCH_CONTROLLER port map 
    (
        rst => rst,
        clk            => clk,
        rst_ex         => rst_ex,
        rst_ld         => rst_ld, 
        out_output     => fc_output,
        in_ram_data    => in_ram_data,
        out_ram_addrb  => out_ram_addrb,
        out_ram_enb    => out_ram_enb,
        out_ram_rstb   => out_ram_rstb,
        in_pc          => sig_pc_output,
        out_pc_rst     => rst_pc,
        out_pc         => rst_pc_adr,
        in_rom_data    => in_rom_data,
        out_rom_rd_en => out_rom_rd_en,
        out_rom_adr => out_rom_adr,
        out_rom_rst => out_rom_rst,
        out_rom_rd => out_rom_rd
    );

    mux_stall : entity work.MUX16_2x1 port map
    (
        SEL => sig_brch_tkn,
        A   => fc_output,
        B   => X"0000",
        C   => out_output
    );

    mux_newadr : entity work.MUX16_2x1 port map 
    (
        SEL => rst_pc,
        A   => new_pc,
        B   => rst_pc_adr,
        C   => pc_input
    );

    out_pc <= sig_pc_output;
    out_pc2 <= pc2;
        
END level_2;