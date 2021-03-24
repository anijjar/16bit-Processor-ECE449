
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16;
      ram_address_length : integer := 13
   );
   PORT (
      clk : in std_logic; -- reset and run instructions
      rst_ex : in std_logic; -- reset and run instructions
      rst_ld : in std_logic; -- reset and load instructions
      out_output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);

      -- RAM port B (read only)
      in_ram_data : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      out_ram_addrb : OUT STD_LOGIC_VECTOR(ram_address_length-1 DOWNTO 0);
      out_ram_enb   : OUT STD_LOGIC;
      out_ram_rstb   : out std_logic
   );
END FETCH_CONTROLLER;

ARCHITECTURE level_2 OF FETCH_CONTROLLER IS
    SIGNAL pc_input : std_logic_vector(12 downto 0) := (others => '0'); -- RAM address shouyld be at most 13 bits long
    SIGNAL pc_output : std_logic_vector(12 downto 0) := (others => '0'); -- RAM address shouyld be at most 13 bits long
    SIGNAL pc_state : std_logic_vector(1 downto 0) := (others => '0'); -- RAM address shouyld be at most 13 bits long
BEGIN

    pc_2 : entity work.PC port map(
        clk    => clk,
        state  => pc_state,
        input =>  pc_input,
        output => pc_output
    );
-- logic (keep it simple for now)
    PROCESS(clk, rst_ex, rst_ld, in_ram_data)
    variable prog_en : std_logic := '0';
    BEGIN
    if(rising_edge(clk)) then --removing this causes 2 jumps per clock cycle
        if(rst_ex = '1') then
            pc_state <= "11";
            prog_en := '1';
            pc_state <= "01";
        end if;
        if(rst_ld = '1') then
            pc_input <= '0'&x"002";
            pc_state <= "10";
            --reset ram here for loading
            prog_en := '1';
            pc_state <= "01";
        end if;
        out_ram_enb <= '0';
   end if;
    if(falling_edge(clk)) then
        if(prog_en = '1') then
            out_ram_enb <= '1';
        end if;
    end if;
    out_ram_addrb <= pc_output;
    END PROCESS;
    out_output <= in_ram_data;
    out_ram_rstb <= '0';
END level_2;