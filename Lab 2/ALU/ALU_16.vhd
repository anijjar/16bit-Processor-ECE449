LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;

ENTITY ALU_16 IS
   PORT (
      -- master control inputs
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      -- control INput
      alu_mode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      -- data INputs
      IN1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      IN2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- data output
      result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      -- control output
      -- ov_flag : out std_logic;
      z_flag : OUT STD_LOGIC;
      n_flag : OUT STD_LOGIC);
END ALU_16;

ARCHITECTURE behavioural OF ALU_16 IS

   BARREL_SHIFTER_16 : ENTITY work.BARREL_SHIFTER_16 PORT MAP(A => BS_16_D_IN, B => BS_16_SHIFT, LEFT => BS_16_LEFT, AR_SHIFT => BS_16_AR_SEL, AL_SHIFT => BS_16_AR_SEL, Y => BS_16_D_OUT);

   SIGNAL BS_16_D_IN : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL BS_16_SHIFT : STD_LOGIC_VECTOR (3 DOWNTO 0);
   SIGNAL BS_16_LEFT : STD_LOGIC;
   SIGNAL BS_16_AR_SEL, BS_16_AR_SEL : STD_LOGIC;
   SIGNAL BS_16_D_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN
   PROCESS (rst, alu_mode, in1, in2)
   BEGIN
      IF (rst = '1') THEN
         -- not sure if output needs to be set to zero
         -- RF8_16 does not do this
         result <= (OTHERS => '0');
         z_flag <= '0';
         n_flag <= '0';
         -- set all internal values to default; zero
      ELSE
         CASE alu_mode(2 DOWNTO 0) IS
            WHEN "000" => -- NOP
               result <= (OTHERS => '0');
               z_flag <= '0';
               n_flag <= '0';
               -- set internal values to default?
            WHEN "001" => -- ADD

            WHEN "010" => -- SUB

            WHEN "011" => -- MUL

            WHEN "100" => -- NAND
               result <= in1 NAND in2;
            WHEN "101" => -- SHL
               BS_16_D_IN <= IN1;
               RBS_16_SHIFT <= IN2(3 downto 0); --supports upto 15 shifts
               BS_16_LEFT <= '1';
               BS_16_AR_SEL <= '0';
               BS_16_AL_SEL <= '0';
               result <= RBS_16_D_OUT;
            WHEN "110" => -- SHR
               BS_16_D_IN <= IN1;
               RBS_16_SHIFT <= IN2(3 downto 0); --supports upto 15 shifts
               BS_16_LEFT <= '0';
               BS_16_AR_SEL <= '0';
               BS_16_AL_SEL <= '0';
               result <= RBS_16_D_OUT;
            WHEN "111" => -- TEST

            WHEN OTHERS => NULL;
         END CASE;
      END IF;
   END PROCESS;
END behavioural; -- behavioural