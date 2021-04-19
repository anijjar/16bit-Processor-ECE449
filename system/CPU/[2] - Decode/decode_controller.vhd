
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL; -- for shifts

ENTITY DECODE_CONTROLLER IS
   PORT (
      rst : IN STD_LOGIC;
      -- opcode from the 16-bit instruction
      opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      -- determined ALU mode from opcode, only used for format A
      alumode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- the rest of the 16-bit instruction
      data : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      -- flags are received from the EXECUTE stage to determine
      -- if branch is taken or not
      -- flags are Z & N & V
      flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- address of destination register, ie ra
      -- defaulted to 000 (R0)
      ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- address of first operand, ie rb
      -- defaulted to 000 (R0)
      r1a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- address of second operand, ie rc
      -- defaulted to 000 (R0)
      r2a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- alternative data, eq cl in shift insturctions
      -- default value is zeros
      alt2d : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
      -- enables alternative data for D2, eg cl in shifting intructions
      -- 0 is return from register file, 1 is alternative data
      r2den : OUT STD_LOGIC;

      out_m1 : OUT STD_LOGIC;

      -- sent to the fecth stage, communicates if the branch has been
      -- taken. 0 is pc+2, 1 is new PC.
      brch_tkn : OUT STD_LOGIC;
      -- on any BR instruction, selects input the new-PC adder
      -- 0 selects PC (BRR), 1 selects value at R[ra] (Br)
      -- to be added to specified displacement
      ifBr : OUT STD_LOGIC;
      -- on a RETURN instruction, set high to select the value from RFD1
      -- to be used as the new PC
      ifReturn : OUT STD_LOGIC;

      -- pc+2
      pc2 : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
      if_Brsub : OUT STD_LOGIC;
      disp : OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
   );
END DECODE_CONTROLLER;

ARCHITECTURE behavioural OF DECODE_CONTROLLER IS
BEGIN
   PROCESS (rst, opcode, data, flags, pc2)
   BEGIN
      IF (rst = '1') THEN
         alumode <= "000";
         ra <= "000";
         r1a <= "000";
         r2a <= "000";
         r2den <= '0';
         alt2d <= (OTHERS => '0');
         brch_tkn <= '0';
         ifBr <= '0';
         ifReturn <= '0';
         out_m1 <= '0';
         if_brsub <= '0';
         disp <= (OTHERS => '0');
      ELSE
         CASE opcode(6 DOWNTO 0) IS
            WHEN "0000000" =>
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- ADD
            WHEN "0000001" =>
               alumode <= "001";
               ra <= data(8 DOWNTO 6);
               r1a <= data(5 DOWNTO 3);
               r2a <= data(2 DOWNTO 0);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- SUB
            WHEN "0000010" =>
               alumode <= "010";
               ra <= data(8 DOWNTO 6);
               r1a <= data(5 DOWNTO 3);
               r2a <= data(2 DOWNTO 0);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');
               -- MUL
            WHEN "0000011" =>
               alumode <= "011";
               ra <= data(8 DOWNTO 6);
               r1a <= data(5 DOWNTO 3);
               r2a <= data(2 DOWNTO 0);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- NAND
            WHEN "0000100" =>
               alumode <= "100";
               ra <= data(8 DOWNTO 6);
               r1a <= data(5 DOWNTO 3);
               r2a <= data(2 DOWNTO 0);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- SHL
            WHEN "0000101" =>
               alumode <= "101";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3 DOWNTO 0);
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- SHR
            WHEN "0000110" =>
               alumode <= "110";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3 DOWNTO 0);
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';

               -- TEST
            WHEN "0000111" =>
               alumode <= "111";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- OUT
            WHEN "0100000" =>
               alumode <= "000";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- IN
            WHEN "0100001" =>
               alumode <= "000";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               brch_tkn <= '0';
               ifBr <= '0';
               ifReturn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BRR
            WHEN "1000000" =>
               brch_tkn <= '1';
               ifBr <= '0';
               ifReturn <= '0';
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BRR.N
            WHEN "1000001" =>
               brch_tkn <= flags(1);
               ifBr <= '0';
               ifReturn <= '0';
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BRR.Z
            WHEN "1000010" =>
               brch_tkn <= flags(2);
               ifBr <= '0';
               ifReturn <= '0';
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BRR.V
            WHEN "1001000" =>
               brch_tkn <= flags(0);
               ifBr <= '0';
               ifReturn <= '0';
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BR
            WHEN "1000011" =>
               brch_tkn <= '1';
               ra <= data(8 DOWNTO 6);
               ifBr <= '1';
               ifReturn <= '0';
               alumode <= "000";
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BR.N
            WHEN "1000100" =>
               brch_tkn <= flags(1);
               ra <= data(8 DOWNTO 6);
               ifBr <= '1';
               ifReturn <= '0';
               alumode <= "000";
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BR.Z
            WHEN "1000101" =>
               brch_tkn <= flags(2);
               ra <= data(8 DOWNTO 6);
               ifBr <= '1';
               ifReturn <= '0';
               alumode <= "000";
               r1a <= data(8 DOWNTO 6);
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BR.V
            WHEN "1001001" =>
               brch_tkn <= flags(0);
               ra <= data(8 DOWNTO 6);
               ifBr <= '1';
               ifReturn <= '0';
               alumode <= "000";
               r1a <= data(8 DOWNTO 6);-- swapped r1a with r2a
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- BR.SUB
            WHEN "1000110" =>
               brch_tkn <= '1';
               ra <= "111";
               ifBr <= '1';
               ifReturn <= '0';
               alumode <= "000";
               r1a <= data(8 DOWNTO 6); --dest is handled in wb controller.
               r2a <= "000";
               r2den <= '1';
               alt2d <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 DOWNTO 0) & '0';
               out_m1 <= '0';
               if_brsub <= '1';
               disp <= pc2;

               -- RETURN
            WHEN "1000111" =>
               alumode <= "000";
               ra <= "000";
               r1a <= "111";
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '1';
               brch_tkn <= '1';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- Load
            WHEN "0010000" =>
               alumode <= "000";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= data(5 DOWNTO 3);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- store
            WHEN "0010001" =>
               alumode <= "000";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= data(5 DOWNTO 3);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- loadimm
            WHEN "0010010" =>
               alumode <= "000";
               ra <= "111"; -- changed from ra
               r1a <= "000"; -- cahnged from 111
               r2a <= "111";
               r2den <= '1';
               alt2d <= '0' & X"00" & data(7 DOWNTO 0);
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= data(8);
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- MOV
            WHEN "0010011" =>
               alumode <= "000";
               ra <= data(8 DOWNTO 6);
               r1a <= data(8 DOWNTO 6);
               r2a <= data(5 DOWNTO 3);
               r2den <= '0';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

               -- not an ALU operation
            WHEN OTHERS =>
               alumode <= "000";
               ra <= "000";
               r1a <= "000";
               r2a <= "000";
               r2den <= '1';
               alt2d <= (OTHERS => '0');
               ifBr <= '0';
               ifReturn <= '0';
               brch_tkn <= '0';
               out_m1 <= '0';
               if_brsub <= '0';
               disp <= (OTHERS => '0');

         END CASE;

      END IF;
   END PROCESS;
END behavioural; -- behavioural