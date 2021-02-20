
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX_ARRAY_16 IS
   PORT (
      data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      s : IN STD_LOGIC;
      data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END MUX_ARRAY_16;

ARCHITECTURE behavioural OF MUX_ARRAY_16 IS
   COMPONENT MUX2_1 IS
      PORT (
      SEL : IN STD_LOGIC;
      A : IN STD_LOGIC;
      B : IN STD_LOGIC;
      C : OUT STD_LOGIC);
   END COMPONENT;

BEGIN
-- 7 for 8 bit shift, 15 for 16 bit shift
   gen: for i in 15 downto 0 generate
      ut : MUX2_1 PORT MAP(s, data_in(i*2), data_in((i*2)+1), , data_out(i));
   end generate;
   
END behavioural;