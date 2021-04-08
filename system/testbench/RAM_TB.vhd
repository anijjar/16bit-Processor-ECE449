LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY RAM_TB IS
   --  Port ( );
END RAM_TB;

ARCHITECTURE Behavioral OF RAM_TB IS
   SIGNAL CLK : STD_LOGIC;
   SIGNAL RSTA : STD_LOGIC;
   SIGNAL RSTB : STD_LOGIC;
   SIGNAL ENA : STD_LOGIC;
   SIGNAL ENB : STD_LOGIC;
   SIGNAL WENA : STD_LOGIC_VECTOR(0 DOWNTO 0);
   SIGNAL ADDA : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL ADDB : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL DINA : STD_LOGIC_VECTOR(15 DOWNTO 0); -- b doesnt do write operations
   SIGNAL DOUTA : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL DOUTB : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
   RAM_tb : ENTITY work.RAM PORT MAP(
   Clock => CLK, 
   Reset_a => RSTA, 
   Reset_b => RSTB, 
   Enable_a => ENA, 
   Enable_b => ENB, 
   Write_en_a => WENA, 
   Address_a => ADDA,
   Address_b => ADDB, 
   data_in_a => DINA, 
   Data_out_a => DOUTA,
   Data_out_b => DOUTB
  );

   clock : PROCESS
   BEGIN
      CLK <= '0';
      WAIT FOR 10 us;
      CLK <= '1';
      WAIT FOR 10 us;
   END PROCESS;

   RAM_TESTS : PROCESS
   BEGIN
      RSTA <= '1';
      RSTB <= '1';
      ENA <= '0';
      ENB <= '0';
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      RSTA <= '0';
      RSTB <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event); -- HERE WRITE BY PORT A AND READ FROM PORT B
      ENA <= '1';
      ENB <= '1';
      WENA <= "1";
      ADDA <= x"0000";
      ADDB <= x"0001";
      DINA <= x"FFFF";
      WAIT UNTIL (CLK = '1' AND CLK'event); -- HERE READ FROM PORT A
      ENA <= '1';
      ADDA <= x"0004";
      WAIT;
   END PROCESS;
END Behavioral;