LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Increment IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      input : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
   );        
END Increment;

ARCHITECTURE behav OF Increment IS
   SIGNAL offset : STD_LOGIC_VECTOR(3 DOWNTO 0) <= "0010"; --add 2 to the PC 
BEGIN
   output <= input + offset; 
END behav;