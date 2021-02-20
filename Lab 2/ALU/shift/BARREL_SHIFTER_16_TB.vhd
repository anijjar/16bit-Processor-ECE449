LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY BARREL_SHIFTER_16_TB IS
   --  Port ( );
END BARREL_SHIFTER_16_TB;

ARCHITECTURE Behavioral OF BARREL_SHIFTER_16_TB IS
   -- RBS signals
   SIGNAL BARREL_SHIFTER_16_A : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL BARREL_SHIFTER_16_B : STD_LOGIC_VECTOR (3 DOWNTO 0);
   SIGNAL BARREL_SHIFTER_16_LEFT : STD_LOGIC;
   SIGNAL BARREL_SHIFTER_16_Y : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

   BARREL_SHIFTER_16 : ENTITY work.BARREL_SHIFTER_16 PORT MAP(BARREL_SHIFTER_16_A, BARREL_SHIFTER_16_B, BARREL_SHIFTER_16_LEFT, BARREL_SHIFTER_16_Y);
   BARREL_SHIFTER_16_RIGHT_tests : PROCESS
      CONSTANT period : TIME := 20 ns;
   BEGIN
      -- '1' case
      BARREL_SHIFTER_16_A <= X"0001";
      BARREL_SHIFTER_16_B <= X"1";
      BARREL_SHIFTER_16_LEFT <= '0';
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_16_Y = "0000000000000000") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for RBS_16_D_IN = 0x0001" SEVERITY error;
      -- 'F' case
      BARREL_SHIFTER_16_A <= X"000F";
      BARREL_SHIFTER_16_B <= "0010";
      BARREL_SHIFTER_16_LEFT <= '0';
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_16_Y = "0000000000000011") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for RBS_16_D_IN = 0x000F" SEVERITY error;
      -- 'F00F' case
      BARREL_SHIFTER_16_A <= X"F00F";
      BARREL_SHIFTER_16_B <= X"0008";
      BARREL_SHIFTER_16_LEFT <= '0';
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_16_Y = "0000000011110000") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for RBS_16_D_IN = 0xF00F" SEVERITY error;
      -- 'FFFF' case
      BARREL_SHIFTER_16_A <= X"FFFF";
      BARREL_SHIFTER_16_B <= X"F";
      BARREL_SHIFTER_16_LEFT <= '0';
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_16_Y = X"0001") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for RBS_16_D_IN = 0xFFFF" SEVERITY error;

      -- 'FAIL case
      BARREL_SHIFTER_16_A <= X"0000";
      BARREL_SHIFTER_16_B <= X"F";
      BARREL_SHIFTER_16_LEFT <= '0';
      WAIT FOR period;
      ASSERT (BARREL_SHIFTER_16_Y = X"FFFF") -- expected output
      -- error will be reported if out is not 0
      REPORT "test failed for RBS_16_D_IN = 0x0000" SEVERITY error;
      WAIT;
   END PROCESS;

   BARREL_SHIFTER_16_left_tests : PROCESS
   CONSTANT period : TIME := 20 ns;
BEGIN
   -- '1' case
   BARREL_SHIFTER_16_A <= X"0001";
   BARREL_SHIFTER_16_B <= X"1";
   BARREL_SHIFTER_16_LEFT <= '1';
   WAIT FOR period;
   ASSERT (BARREL_SHIFTER_16_Y = X"0002") -- expected output
   -- error will be reported if out is not 0
   REPORT "test failed for RBS_16_D_IN = 0x0001" SEVERITY error;
   -- 'F' case
   BARREL_SHIFTER_16_A <= X"000F";
   BARREL_SHIFTER_16_B <= "0010";
   BARREL_SHIFTER_16_LEFT <= '1';
   WAIT FOR period;
   ASSERT (BARREL_SHIFTER_16_Y = X"FFFC") -- expected output
   -- error will be reported if out is not 0
   REPORT "test failed for RBS_16_D_IN = 0x000F" SEVERITY error;
   -- 'F00F' case
   BARREL_SHIFTER_16_A <= X"F00F";
   BARREL_SHIFTER_16_B <= X"0008";
   BARREL_SHIFTER_16_LEFT <= '1';
   WAIT FOR period;
   ASSERT (BARREL_SHIFTER_16_Y = X"0F00") -- expected output
   -- error will be reported if out is not 0
   REPORT "test failed for RBS_16_D_IN = 0xF00F" SEVERITY error;
   -- 'FFFF' case
   BARREL_SHIFTER_16_A <= X"FFFF";
   BARREL_SHIFTER_16_B <= X"F";
   BARREL_SHIFTER_16_LEFT <= '1';
   WAIT FOR period;
   ASSERT (BARREL_SHIFTER_16_Y = X"8000") -- expected output
   -- error will be reported if out is not 0
   REPORT "test failed for RBS_16_D_IN = 0xFFFF" SEVERITY error;

   -- 'FAIL case
   BARREL_SHIFTER_16_A <= X"0000";
   BARREL_SHIFTER_16_B <= X"F";
   BARREL_SHIFTER_16_LEFT <= '1';
   WAIT FOR period;
   ASSERT (BARREL_SHIFTER_16_Y = X"FFFF") -- expected output
   -- error will be reported if out is not 0
   REPORT "test failed for RBS_16_D_IN = 0x0000" SEVERITY error;
   WAIT;
END PROCESS;
END Behavioral;