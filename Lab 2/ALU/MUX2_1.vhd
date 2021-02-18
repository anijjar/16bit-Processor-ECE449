
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX2_1 IS
   PORT (
      SEL : IN STD_LOGIC;
      A : IN STD_LOGIC;
      B : IN STD_LOGIC;
      C : OUT STD_LOGIC;
   );
END MUX2_1;

ARCHITECTURE behavioural OF MUX2_1 IS

BEGIN
   PROCESS (SEL, A, B)
   BEGIN
      C <= A WHEN (SEL = '1') ELSE B;
   END PROCESS;

END behavioural;