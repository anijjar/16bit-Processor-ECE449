LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY EXECUTE_STAGE IS
   PORT (
      rst : IN STD_LOGIC;
      in_CPU_input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      in_RD1 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_RD2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_alumode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_rb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_rc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_exmem_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_exmem_forwarding_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_exmem_forwarded_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      in_wb_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_wb_forwarding_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_wb_forwarded_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0); -- for the loadimm edge case

      out_result : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      out_z_flag : OUT STD_LOGIC;
      out_n_flag : OUT STD_LOGIC;
      out_v_flag : OUT STD_LOGIC
   );
END EXECUTE_STAGE;

ARCHITECTURE behavioural OF EXECUTE_STAGE IS
   SIGNAL alu_RD2 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL alu_RD1 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL alu_out : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
   SIGNAL forward_en : STD_LOGIC := '0';
BEGIN
   alu_0 : ENTITY work.ALU_16 PORT MAP (
      rst => rst,
      alu_mode => in_alumode,
      in1 => alu_RD1,
      in2 => alu_RD2,
      result => alu_out,
      z_flag => out_z_flag,
      n_flag => out_n_flag,
      v_flag => out_v_flag
      );
   PROCESS (rst, in_RD1, in_RD2, in_alumode, in_opcode, in_rb, in_rc, in_exmem_opcode, in_exmem_forwarding_address, in_exmem_forwarded_data,
      in_wb_opcode, in_wb_forwarding_address, in_wb_forwarded_data, alu_out, alu_RD2, alu_RD1, forward_en)
   BEGIN
      IF (rst = '1') THEN
         out_result <= (OTHERS => '0');
         forward_en <= '0';
      ELSE
         CASE in_opcode IS
               -- this determines what value is output to the MEM and WB stages
            WHEN "0000001" => -- ADD
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0000010" => -- SUB
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0000011" => -- MUL
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0000100" => -- NAND
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0000101" => -- SHL
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0000110" => -- SHR
               out_result <= alu_out;
               forward_en <= '1';
            WHEN "0100000" => -- OUT
               out_result <= alu_RD1;
               forward_en <= '1'; --using the rb input
            WHEN "0100001" => -- IN
               out_result <= '0' & in_CPU_input; --output the pins
               forward_en <= '1';
            WHEN "1000110" => -- brr.sub
               out_result <= alu_RD2;
               forward_en <= '0';
            WHEN "0010010" => -- LOADIMM
               out_result <= alu_RD2;
               forward_en <= '0';
            WHEN "0010011" => -- MOV
               out_result <= alu_RD1;
               forward_en <= '1';
            WHEN OTHERS => -- NOP
               out_result <= (OTHERS => '0');
               forward_en <= '0';
         END CASE;
         -- this is the forwarding.
         -- we can forward load and stores because the RAM module is combinational logic.
         -- if the input address == forwarded address and some other ocnditions are true, then use the forwarded result.
         IF ((in_rb = in_exmem_forwarding_address) AND
            (in_exmem_opcode /= "0000000") AND --nop 
            (in_exmem_opcode /= "1000000") AND --brr
            (in_exmem_opcode /= "1000001") AND --brr.n
            (in_exmem_opcode /= "1000010") AND --brr.z
            (in_exmem_opcode /= "1001000") AND --br.v
            (in_exmem_opcode /= "1000011") AND -- br 
            (in_exmem_opcode /= "1000100") AND -- br.n
            (in_exmem_opcode /= "1000101") AND -- br.z
            (in_exmem_opcode /= "1001001") AND -- br.v
            (in_exmem_opcode /= "1000111") AND --return
            (in_opcode /= "0010010") AND --loadimm
            (in_opcode /= "1000110") AND --BR.sub
            (in_opcode /= "0000000")) --NOP
            THEN
            alu_RD1 <= in_exmem_forwarded_data;
         ELSIF ((in_rb = in_wb_forwarding_address) AND
            (in_wb_opcode /= "0000000") AND --nop 
            (in_wb_opcode /= "1000000") AND --brr
            (in_wb_opcode /= "1000001") AND --brr.n
            (in_wb_opcode /= "1000010") AND --brr.z
            (in_wb_opcode /= "1001000") AND --br.v
            (in_wb_opcode /= "1000011") AND -- br 
            (in_wb_opcode /= "1000100") AND -- br.n
            (in_wb_opcode /= "1000101") AND -- br.z
            (in_wb_opcode /= "1001001") AND -- br.v
            (in_wb_opcode /= "1000111") AND --return
            (in_opcode /= "0010010") AND --loadimm
            (in_opcode /= "1000110") AND --BR.sub
            (in_opcode /= "0000000") --NOP
            ) THEN
            alu_RD1 <= in_exmem_forwarded_data;
         ELSE
            alu_RD1 <= in_RD1;
         END IF;
         IF ((in_rc = in_exmem_forwarding_address) AND
            (in_exmem_opcode /= "0000000") AND --nop 
            (in_exmem_opcode /= "1000000") AND --brr
            (in_exmem_opcode /= "1000001") AND --brr.n
            (in_exmem_opcode /= "1000010") AND --brr.z
            (in_exmem_opcode /= "1001000") AND --br.v
            (in_exmem_opcode /= "1000011") AND -- br 
            (in_exmem_opcode /= "1000100") AND -- br.n
            (in_exmem_opcode /= "1000101") AND -- br.z
            (in_exmem_opcode /= "1001001") AND -- br.v
            (in_exmem_opcode /= "1000111") AND --return
            (in_opcode /= "0010010") AND --loadimm
            (in_opcode /= "1000110") AND --BR.sub
            (in_opcode /= "0000000")) --NOP
            THEN
            alu_RD2 <= in_exmem_forwarded_data;
         ELSIF ((in_rc = in_wb_forwarding_address) AND
            (in_wb_opcode /= "0000000") AND --nop 
            (in_wb_opcode /= "1000000") AND --brr
            (in_wb_opcode /= "1000001") AND --brr.n
            (in_wb_opcode /= "1000010") AND --brr.z
            (in_wb_opcode /= "1001000") AND --br.v
            (in_wb_opcode /= "1000011") AND -- br 
            (in_wb_opcode /= "1000100") AND -- br.n
            (in_wb_opcode /= "1000101") AND -- br.z
            (in_wb_opcode /= "1001001") AND -- br.v
            (in_wb_opcode /= "1000111") AND --return
            (in_opcode /= "0010010") AND --loadimm
            (in_opcode /= "1000110") AND --BR.sub
            (in_opcode /= "0000000") --NOP
            ) THEN
            alu_RD2 <= in_wb_forwarded_data;
         ELSE
            alu_RD2 <= in_RD2;
         END IF;
      END IF;
   END PROCESS;
END behavioural;