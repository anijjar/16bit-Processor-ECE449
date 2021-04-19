
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMORY_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst : IN STD_LOGIC;
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_dr1 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_ar : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_rc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_dr2 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_wb_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_wb_forwarded_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_wb_forwarded_data : IN STD_LOGIC_VECTOR(N DOWNTO 0); --we use wb_forwarded data for the case of loadimm

      output_data : OUT STD_LOGIC_VECTOR(N DOWNTO 0);
      -- RAM port A
      out_RAM_rst_a : OUT STD_LOGIC;
      out_RAM_en_a : OUT STD_LOGIC;
      out_RAM_wen_a : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      out_RAM_addy_a : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      out_RAM_din_a : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      in_RAM_dout_a : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      -- I/O logic
      -- when the load or store instruction is 0xFFF0 or 0xFFF2, then instead of memory, write to ports
      display : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      dip_switches : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END MEMORY_CONTROLLER;

ARCHITECTURE level_2 OF MEMORY_CONTROLLER IS
BEGIN
   PROCESS (rst, in_ra, in_ar, in_rc, in_wb_opcode, in_wb_forwarded_address, in_wb_forwarded_data, in_dr1, in_dr2, in_opcode, dip_switches)
   BEGIN
      IF (rst = '1') THEN
         out_RAM_rst_a <= '1';
         out_RAM_en_a <= '0';
         out_RAM_wen_a <= "0";
         out_RAM_addy_a <= (OTHERS => '0');
         out_RAM_din_a <= (OTHERS => '0');
      ELSE
         CASE in_opcode IS
            WHEN "0010000" => -- load
               IF (in_dr2 = X"FFF0") THEN -- read the dip switches
                  out_RAM_rst_a <= '0';
                  out_RAM_en_a <= '0';
                  out_RAM_wen_a <= "0";
                  out_RAM_addy_a <= (others => '0');
                  out_RAM_din_a <= X"0000";
                  output_data <= dip_switches;
               ELSE -- read the RAM unit
                  out_RAM_rst_a <= '0';
                  out_RAM_en_a <= '1';
                  out_RAM_wen_a <= "0";
                  out_RAM_din_a <= X"0000";
                  output_data <= '0' & in_RAM_dout_a;
                  -- check if the input address has been modified in the last instruction
                  IF (
                     (in_rc = in_wb_forwarded_address) AND
                     (in_wb_opcode /= "0000000") AND --nop 
                     (in_wb_opcode /= "1000000") AND --brr
                     (in_wb_opcode /= "1000001") AND --brr.n
                     (in_wb_opcode /= "1000010") AND --brr.z
                     (in_wb_opcode /= "1001000") AND --br.v
                     (in_wb_opcode /= "1000011") AND -- br 
                     (in_wb_opcode /= "1000100") AND -- br.n
                     (in_wb_opcode /= "1000101") AND -- br.z
                     (in_wb_opcode /= "1001001") AND -- br.v
                     (in_wb_opcode /= "1000111") --return
                     ) THEN
                     out_RAM_addy_a <= in_wb_forwarded_data(9 DOWNTO 0);
                  ELSE
                     out_RAM_addy_a <= in_dr2(9 DOWNTO 0);
                  END IF;
               WHEN "0010001" => -- store
                  IF (in_dr1 = X"FFF2") THEN --for writing to the LED strips
                     IF (
                        (in_rc = in_wb_forwarded_address) AND
                        (in_wb_opcode /= "0000000") AND --nop 
                        (in_wb_opcode /= "1000000") AND --brr
                        (in_wb_opcode /= "1000001") AND --brr.n
                        (in_wb_opcode /= "1000010") AND --brr.z
                        (in_wb_opcode /= "1001000") AND --br.v
                        (in_wb_opcode /= "1000011") AND -- br 
                        (in_wb_opcode /= "1000100") AND -- br.n
                        (in_wb_opcode /= "1000101") AND -- br.z
                        (in_wb_opcode /= "1001001") AND -- br.v
                        (in_wb_opcode /= "1000111") --return
                        ) THEN
                        display <= in_wb_forwarded_data(15 DOWNTO 0);
                     ELSE
                        display <= in_dr2(15 DOWNTO 0);
                     END IF;
                     out_RAM_rst_a <= '0';
                     out_RAM_en_a <= '0';
                     out_RAM_wen_a <= "0";
                     out_RAM_addy_a <= (others => '0');
                     out_RAM_din_a <= X"0000";
                     output_data <= (others => '0');
                  ELSE -- to the ram unit
                     out_RAM_rst_a <= '0';
                     out_RAM_en_a <= '1';
                     out_RAM_wen_a <= "1";
                     -- check if the destination address has been modified in the last instruction
                     IF (
                        (in_ra = in_wb_forwarded_address) AND
                        (in_wb_opcode /= "0000000") AND --nop 
                        (in_wb_opcode /= "1000000") AND --brr
                        (in_wb_opcode /= "1000001") AND --brr.n
                        (in_wb_opcode /= "1000010") AND --brr.z
                        (in_wb_opcode /= "1001000") AND --br.v
                        (in_wb_opcode /= "1000011") AND -- br 
                        (in_wb_opcode /= "1000100") AND -- br.n
                        (in_wb_opcode /= "1000101") AND -- br.z
                        (in_wb_opcode /= "1001001") AND -- br.v
                        (in_wb_opcode /= "1000111") --return
                        ) THEN
                        out_RAM_addy_a <= in_wb_forwarded_data(9 DOWNTO 0);
                        output_data <= in_wb_forwarded_data;
                     ELSE
                        out_RAM_addy_a <= in_dr1(9 DOWNTO 0);  
                        output_data <= in_dr1(9 DOWNTO 0);
                     END IF;
                     -- check if the input data has been modified in the last instruction
                     IF (
                        (in_rc = in_wb_forwarded_address) AND
                        (in_wb_opcode /= "0000000") AND --nop 
                        (in_wb_opcode /= "1000000") AND --brr
                        (in_wb_opcode /= "1000001") AND --brr.n
                        (in_wb_opcode /= "1000010") AND --brr.z
                        (in_wb_opcode /= "1001000") AND --br.v
                        (in_wb_opcode /= "1000011") AND -- br 
                        (in_wb_opcode /= "1000100") AND -- br.n
                        (in_wb_opcode /= "1000101") AND -- br.z
                        (in_wb_opcode /= "1001001") AND -- br.v
                        (in_wb_opcode /= "1000111") --return
                        ) THEN
                        out_RAM_din_a <= in_wb_forwarded_data(15 DOWNTO 0);
                     ELSE
                        out_RAM_din_a <= in_dr2(15 DOWNTO 0);
                     END IF;
                  END IF;
               WHEN OTHERS => --pass ex result to the wb stage
                  out_RAM_rst_a <= '1';
                  out_RAM_en_a <= '0';
                  out_RAM_wen_a <= "0";
                  out_RAM_addy_a <= (OTHERS => '0');
                  out_RAM_din_a <= (OTHERS => '0');
                  output_data <= in_ar;
               END CASE;
         END IF;
      END PROCESS;
   END level_2;