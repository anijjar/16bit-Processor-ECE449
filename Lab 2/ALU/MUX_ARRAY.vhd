
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX_ARRAY IS
   PORT (
      d_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      shift : IN STD_LOGIC;
      d_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END MUX_ARRAY;

ARCHITECTURE behavioural OF MUX_ARRAY IS
   COMPONENT MUX2_1 IS
      PORT (
         A, B, SEL : IN STD_LOGIC;
         C : OUT STD_LOGIC);
   END COMPONENT;

BEGIN
-- 7 for 8 bit shift, 15 for 16 bit shift
   gen: for i in 15 downto 0 generate
      ut : MUX2_1 PORT MAP(B => d_in((i*2)+1), A => d_in(i*2), SEL => shift, C => d_out(i);
   end generate;
   
END behavioural;