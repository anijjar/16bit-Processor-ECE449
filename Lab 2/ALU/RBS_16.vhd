
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY RBS_16 IS
   PORT (
      d_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      shift : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      d_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END RBS_16;

ARCHITECTURE behavioural OF RBS_16 IS
   COMPONENT MUX_ARRAY IS
      PORT (
         d_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
         shift : IN STD_LOGIC;
         d_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
      );
   END COMPONENT;

   SIGNAL c0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL c1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL c2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL c3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
   -- setup c3 to input the d_in signal of the array
   -- needs to be d_in(15), 0,  d_in(14), 0,  d_in(13), 0, d_in(12), 0, d_in(11), 0, d_in(10), 0, d_in(9), 0, d_in(8) 0, d_in(7), d_in(15), d_in(6), d_in(14), d_in(5), d_in(13), d_in(4), d_in(12), d_in(3), d_in(11), d_in(2), d_in(10), d_in(1), d_in(9), d_in(0), d_in(8)
   for elem in 31 downto 0 loop
      c3(elem) <= d_in(elem) when (elem mod 2 = 1) else 
            '0' when (elem >= 16) else
            d_in((elem*2)+3) when (elem mod 2 = 0);
      c2 <= c3(elem) when (elem mod 2 = 1) else 
            '0' when (elem >= 24) else
            d_in((elem)+3) when (elem mod 2 = 0);
            ;
      c1 <= c2(elem) when (elem mod 2 = 1) else 
            '0' when (elem >= 28);
      c0 <= c1(elem) when (elem mod 2 = 1) else 
            '0' when (elem >= 30); 
   end loop

   array: for i in 3 downto 0 generate
      -- for the first row we have RBS input
      row3: if (i = 3) generate
         u : MUX_ARRAY PORT MAP(
            d_in => c3,
            b => shift(3),
            d_out => c2,
         )
      end generate row3;

      row2: if (i = 2) generate
         u : MUX_ARRAY PORT MAP(
            d_in => c2,
            b => shift(2),
            d_out => c1,
         )
      end generate row2;

      row1: if (i = 1) generate
         u : MUX_ARRAY PORT MAP(
            d_in => c1,
            b => shift(1),
            d_out => c0,
         )
      end generate row1;

      row0: if (i = 0) generate
         u : MUX_ARRAY PORT MAP(
            d_in => c0,
            b => shift(0),
            d_out => d_out,
         )
      end generate row0;

   end generate array;

   SHR : PROCESS (d_in, shift)
   BEGIN

   END PROCESS;

END behavioural;