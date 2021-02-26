-- Booth's multiplication algorithm
-- multiplies two signed binary numbers in 2's complement
-- -7 * 3 = -21 ( -7 is multiplicand, 3 is multiplier, -21 is product)
-- see https://www.irjet.net/archives/V3/i6/IRJET-V3I691.pdf for algo

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY MUL IS
   GENERIC (
      n : INTEGER := 16 -- number of bits
   );
   PORT (
      M : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
      R : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
      RESULT : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
      O_FLAG : OUT STD_LOGIC
   );
END MUL;

ARCHITECTURE behavioural OF MUL IS
BEGIN
   MUL_PROCESS : PROCESS (M, R)
      VARIABLE A, S, P : STD_LOGIC_VECTOR(n + n DOWNTO 0); -- 33 bits long
      CONSTANT ENTRY_CONDITION : STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
   BEGIN
      -- fill the mopst significant bits of A with M
      A := (OTHERS => '0');
      S := (OTHERS => '0');
      P := (OTHERS => '0');
      IF M /= ENTRY_CONDITION AND R /= ENTRY_CONDITION THEN
         A(n + n DOWNTO n + 1) := M;
         S(n + n DOWNTO n + 1) := (NOT M) + 1; -- 2'S COMP
         P(n DOWNTO 1) := R;
         FOR COUNT IN (n - 1) DOWNTO 0 LOOP
            IF P(1 DOWNTO 0) = "01" THEN
               P := P + A; -- ignore overflow
            ELSIF P(1 DOWNTO 0) = "10" THEN
               P := P + S; -- ignore overflow
            END IF;
            -- arith shift P register by 1 bit
            P(n + n - 1 DOWNTO 0) := P(n + n DOWNTO 1);
         END LOOP;
         RESULT <= P(n DOWNTO 1);-- drop the LSB from P
         O_FLAG <= '1' when P(n+n downto n) /= X"FF" or P(n+n downto n) /= X"00" else '0'; 
         -- O_FLAG out if P is over a 16 bit max value
            -- overflow occurs when the top n bits are not all 0's or 1's.
         
      END IF;
   END PROCESS;
END behavioural;