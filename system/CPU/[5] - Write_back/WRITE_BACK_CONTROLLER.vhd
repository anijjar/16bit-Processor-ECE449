
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WRITE_BACK_CONTROLLER IS
   GENERIC (N : INTEGER := 16);
   PORT (
      rst : IN STD_LOGIC;
      in_m1 : IN STD_LOGIC;
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_ar : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_rc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_cpu : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      out_ar : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      out_ra_wen : OUT STD_LOGIC
   );
END WRITE_BACK_CONTROLLER;

ARCHITECTURE level_2 OF WRITE_BACK_CONTROLLER IS
   SIGNAL r7_temp : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
BEGIN
   Controller : PROCESS (rst, in_m1, in_ar, in_ra, in_opcode, r7_temp)
   BEGIN
      IF (rst = '1') THEN
         out_cpu <= X"0000";
         out_ra <= "000";
         out_ar <= (OTHERS => '0');
         out_ra_wen <= '0';
      ELSE
         CASE in_opcode IS
               -- cannot use others case for A and L instructions because B instructions
            WHEN "0000001" => -- ADD
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0000010" => -- SUB
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0000011" => -- MUL
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0000100" => -- NAND
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0000101" => -- SHL
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0000110" => -- SHR
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0100001" => -- IN
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0100000" => -- OUT
               out_cpu <= in_ar(15 DOWNTO 0);
               out_ar <= (OTHERS => '0');
               out_ra <= "000";
               out_ra_wen <= '0';
            WHEN "0010010" => -- LOADIMM (need latest r7)
               out_cpu <= X"0000";
               out_ra <= "111";
               IF (in_m1 = '1') THEN
                  out_ar <= '0' & in_ar(7 DOWNTO 0) & r7_temp(7 DOWNTO 0);
               ELSE
                  out_ar <= '0' & r7_temp(15 DOWNTO 8) & in_ar(7 DOWNTO 0);
               END IF;
               out_ra_wen <= '1';
            WHEN "0010011" => -- MOV
               out_cpu <= X"0000";
               IF (in_rc = "111") THEN
                  out_ar <= r7_temp;
               ELSE
                  out_ar <= in_ar;
               END IF;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "0010000" => -- LOAD
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '1';
            WHEN "1000110" => -- BR.sub
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= "111";
               out_ra_wen <= '1';
            WHEN "0010001" => -- store -- for the forwarding of the memory stage
               out_cpu <= X"0000";
               out_ar <= in_ar;
               out_ra <= in_ra;
               out_ra_wen <= '0'; --dont write
            WHEN OTHERS => -- NOP
               out_cpu <= X"0000";
               out_ra <= "000";
               out_ar <= (OTHERS => '0');
               out_ra_wen <= '0';
         END CASE;
         IF (in_ra = "111") THEN
            IF (in_opcode = "0010010") THEN -- if laodimm
               IF (in_m1 = '1') THEN
                  r7_temp(15 DOWNTO 8) <= in_ar(7 DOWNTO 0);
               ELSE
                  r7_temp(7 DOWNTO 0) <= in_ar(7 DOWNTO 0);
               END IF;
            ELSE
               r7_temp <= in_ar;
            END IF;
         END IF;
      END IF;
   END PROCESS Controller;
END level_2;