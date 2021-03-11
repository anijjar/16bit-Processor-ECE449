LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IR IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk    : IN STD_LOGIC;
      rst    : IN STD_LOGIC;
      input  : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
   );        
END IR;

ARCHITECTURE behav OF IR IS
   SIGNAL reg : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
BEGIN
   -- synchronously remove the register
   PROCESS (clk, rst)
   BEGIN
      IF (falling_edge(clk)) THEN --RAM outputs at falling edge
         IF (rst = '1') THEN
            reg <= (OTHERS => '0');
         END IF
         ELSE 
            reg <= input;
      END IF
   END PROCESS
   --asynchronously output the register contents
   output <= reg;
END behav;