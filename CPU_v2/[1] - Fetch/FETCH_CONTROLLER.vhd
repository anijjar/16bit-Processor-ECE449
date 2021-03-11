
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk : in std_logic; -- reset and run instructions
      rst_ex : in std_logic; -- reset and run instructions
      rst_ld : in std_logic; -- reset and load instructions
      out_output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);

      -- RAM port B (read only)
      in_ram_data : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      out_ram_addrb : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      out_ram_enb   : OUT STD_LOGIC

   );
END FETCH_CONTROLLER;

ARCHITECTURE level_2 OF FETCH_CONTROLLER IS
   SIGNAL pc_state : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL pc_input : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   SIGNAL pc_out : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
BEGIN
-- add PC
   PC_2 : ENTITY work.PC PORT MAP(
      clk => clk,
      state => pc_state,
      input => pc_input, -- an address
      output => pc_out
   );

-- logic (keep it simple for now)
   PROCESS (rst_ex, rst_ld, in_ram_data)
   variable mutex : integer := 0;
   BEGIN
      IF (rst_ex = '1') THEN
         pc_state <= "11";
         pc_input <= X"0000";
         mutex := 1;
      ELSIF (rst_ld = '1') THEN
         pc_state <= "10";
         pc_input <= X"0002";
      ELSE
         if( mutex = 1) then
            -- output into RAM
            out_ram_addrb <= pc_out;
            out_ram_enb <= '1';
            out_output <= in_ram_data;
            pc_state <= "00";
         end if
      END IF;
   END PROCESS;
END level_2;