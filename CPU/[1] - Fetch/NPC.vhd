LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY NPC IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;

      input : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
   );        
END NPC;

ARCHITECTURE behav OF NPC IS
   SIGNAL reg : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
BEGIN
   -- synchronously remove the register
   PROCESS (clk, rst)
   BEGIN
      IF (falling_edge(clk)) THEN
         IF (rst = '1') THEN
            reg <= (OTHERS => '0');
         END IF
         ELSE 
            output <= reg;
      END IF
   END PROCESS

   --asynchronously add pc into register
   reg <= input;
END behav;