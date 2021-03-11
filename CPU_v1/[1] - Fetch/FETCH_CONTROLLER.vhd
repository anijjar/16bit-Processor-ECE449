
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_CONTROLLER IS
   PORT (
      clk    : IN STD_LOGIC;
      stall    : IN STD_LOGIC; -- stall the pipeline
      rst_ex : in std_logic; -- reset and run instructions
      rst_ld : in std_logic; -- reset and load instructions
      output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --RAM out here
      rom_output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

      -- RAM port B (read only)
      ram_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      ram_addrb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      ram_rstb  : OUT STD_LOGIC;
      ram_enb   : OUT STD_LOGIC;

      -- ROM
      rom_data   : in  std_logic_vector(15 downto 0);
      rom_adr    : out std_logic_vector(15 downto 0);
      rom_rd_en  : out std_logic;
      rom_rst    : out std_logic;
      rom_rd     : out std_logic

   );
END FETCH_CONTROLLER;

ARCHITECTURE level_2 OF FETCH_CONTROLLER IS
   SIGNAL pc_state : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL pc_input : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL pc_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
-- add PC
   PC_2 : ENTITY work.PC PORT MAP(
      clk => clk,
      rst => stall,
      state => pc_state,
      input => pc_input, -- an address
      output => pc_out
   );

-- logic (keep it simple for now)
   PROCESS (stall, rst_ex, rst_ld, pc_out, ram_data, rom_data)
   BEGIN
      IF (rst_ex = '1') THEN
         pc_state <= "11";
         pc_input <= X"0000";
      ELSIF (rst_ld = '1') THEN
         pc_state <= "10";
         pc_input <= X"0002";
      ELSIF (stall = '1') THEN
         pc_state <= "01"; -- do nothing
      ELSE
         -- normal operation
         if (unsigned(pc_out) < X"0400") then -- accessing ROM
            rom_adr <= pc_out;
            rom_rd_en <= '1';
            rom_rst <= '0';
            rom_rd <= '1';
            rom_output <= rom_data;

            ram_addrb <= pc_out;
            ram_rstb <= '0';
            ram_enb <= '0';
            output <= X"0000";
         elsif (unsigned(pc_out) >= X"0400") then 
            ram_addrb <= '0'&pc_out(15 downto 1);
            ram_rstb <= '0';
            ram_enb <= '1';
            output <= ram_data;

            rom_adr <= pc_out;
            rom_rd_en <= '0';
            rom_rst <= '0';
            rom_rd <= '0';
         else -- reset system
            pc_state <= "11";
            pc_input <= X"0000";
            output <= X"0000";
            -- rom_rst <= '1'; //let CPU.vhd reset RAM and ROM
            -- ram_rstb <= '1';
         end if;
         -- increment at the end
         pc_state <= "00";
      END IF;
   END PROCESS;
END level_2;