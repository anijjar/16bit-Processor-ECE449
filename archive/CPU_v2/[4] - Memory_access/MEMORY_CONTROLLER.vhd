
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMORY_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst : IN STD_LOGIC;
      in_dr1 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_dr2 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_memwb : IN STD_LOGIC;
      in_memrd : IN STD_LOGIC;

      out_mem : OUT STD_LOGIC_VECTOR(N DOWNTO 0);
      --add pins for port a of ram
      out_RAM_rst_a : OUT STD_LOGIC;
      out_RAM_en_a : OUT STD_LOGIC;
      out_RAM_wen_a : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      out_RAM_addy_a : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_RAM_din_a : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      out_RAM_dout_a : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0)

   );
END MEMORY_CONTROLLER;

ARCHITECTURE level_2 OF MEMORY_CONTROLLER IS
BEGIN
   PROCESS (rst, in_dr1, in_dr2, in_memwb, in_memrd)
   BEGIN
      IF (rst = '1') THEN
         out_mem <= (OTHERS => '0');
      ELSE
         IF (in_memrd = '1') THEN
            out_RAM_rst_a <= '0';
            out_RAM_en_a <= '1';
            out_RAM_wen_a <= "0";
            out_RAM_addy_a <= in_dr2;
            out_RAM_din_a <= X"0000";
         ELSIF (in_memwb = '1') THEN
            out_RAM_rst_a <= '0';
            out_RAM_en_a <= '1';
            out_RAM_wen_a <= "1";
            out_RAM_addy_a <= in_dr1; -- contents of ra go here
            out_RAM_din_a <= in_dr2;
         ELSE
            out_RAM_en_a <= '0';
         END IF;
      END IF;
   END PROCESS;
END level_2;