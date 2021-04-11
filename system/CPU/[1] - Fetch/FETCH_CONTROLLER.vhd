LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_CONTROLLER IS
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
      -- PC
      in_pc : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_pc_rst : OUT STD_LOGIC;
      out_pc : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
   );
END FETCH_CONTROLLER;

ARCHITECTURE level_2 OF FETCH_CONTROLLER IS
   SIGNAL signal_out_pc : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
   PROCESS (clk, rst, rst_ex, rst_ld, in_ram_data, in_rom_data, in_pc)
      VARIABLE prog_en : INTEGER := 0;
   BEGIN
      IF (rst_ld = '1') THEN --on rst_load
         signal_out_pc <= x"0002";
         out_pc_rst <= '1';
         prog_en := 1;
         out_ram_addrb <= (OTHERS => '0');
         out_ram_enb <= '0';
         out_ram_rstb <= '1';
         out_rom_rd_en <= '0';
         out_rom_adr <= (OTHERS => '0');
         out_rom_rst <= '1';
      ELSIF (rst_ex = '1') THEN -- on rst_ex
         signal_out_pc <= X"0000";
         out_pc_rst <= '1';
         prog_en := 1;
         out_ram_addrb <= (OTHERS => '0');
         out_ram_enb <= '0';
         out_ram_rstb <= '1';
         out_rom_rd_en <= '0';
         out_rom_adr <= (OTHERS => '0');
         out_rom_rst <= '1';
      ELSE -- everytime else
         out_pc_rst <= '0';
         IF (prog_en = 2) THEN
            IF (in_pc < X"03FF") THEN
               out_rom_rd_en <= '1';
               out_rom_rst <= '0';
               out_rom_adr <= '0' & in_pc(ram_address_length - 1 DOWNTO 1);
               --set ram at the same time
               out_ram_addrb <= "00" & X"00";
               out_ram_enb <= '0';
               out_ram_rstb <= '1';
               out_output <= in_rom_data;
            ELSE
               out_ram_enb <= '1';
               out_ram_rstb <= '0';
               out_ram_addrb <= '0' & in_pc(ram_address_length - 1 DOWNTO 1);
               out_rom_rd_en <= '0';
               out_rom_rst <= '1';
               out_rom_adr <= "00" & X"00";
               out_output <= in_ram_data;
            END IF;
         ELSE
            prog_en := 2;
         END IF;
      END IF;
   END PROCESS;
   out_pc <= signal_out_pc;
END level_2;