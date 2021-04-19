LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX3_1_16 IS
    generic (
        N : integer := 17
    );
   PORT (
      SEL : IN std_logic_vector(1 downto 0);
      A : IN std_logic_vector(N-1 downto 0);
      B : IN std_logic_vector(N-1 downto 0);
      C : IN std_logic_vector(N-1 downto 0);
      D : OUT std_logic_vector(N-1 downto 0)
   );
END MUX3_1_16;

ARCHITECTURE behavioural OF MUX3_1_16 IS
BEGIN
    mux3_1 : process(SEL, A, B, C)
    begin
        case SEL is
            when "00" => D <= A;
            when "01" => D <= B;
            when "10" => D <= C;
            when others => null;
        end case;
    end process;

END behavioural;