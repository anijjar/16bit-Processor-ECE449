-- 16-bit right barrel shift
--
--
--

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
         data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
         s : IN STD_LOGIC;
         data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
      );
   END COMPONENT;

   TYPE ARR IS ARRAY (INTEGER RANGE 0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL array_puts : ARR;
   TYPE ARR_OUT IS ARRAY (INTEGER RANGE 0 TO 3) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL array_outs : ARR_OUT;
BEGIN

   array_puts(3)(0) <= d_in(8);
   array_puts(3)(1) <= d_in(0);
   array_puts(3)(2) <= d_in(9);
   array_puts(3)(3) <= d_in(1);
   array_puts(3)(4) <= d_in(10);
   array_puts(3)(5) <= d_in(2);
   array_puts(3)(6) <= d_in(11);
   array_puts(3)(7) <= d_in(3);
   array_puts(3)(8) <= d_in(12);
   array_puts(3)(9) <= d_in(4);
   array_puts(3)(10) <= d_in(13);
   array_puts(3)(11) <= d_in(5);
   array_puts(3)(12) <= d_in(14);
   array_puts(3)(13) <= d_in(6);
   array_puts(3)(14) <= d_in(15);
   array_puts(3)(15) <= d_in(7);
   array_puts(3)(16) <= '0';
   array_puts(3)(17) <= d_in(8);
   array_puts(3)(18) <= '0';
   array_puts(3)(19) <= d_in(9);
   array_puts(3)(20) <= '0';
   array_puts(3)(21) <= d_in(10);
   array_puts(3)(22) <= '0';
   array_puts(3)(23) <= d_in(11);
   array_puts(3)(24) <= '0';
   array_puts(3)(25) <= d_in(12);
   array_puts(3)(26) <= '0';
   array_puts(3)(27) <= d_in(13);
   array_puts(3)(28) <= '0';
   array_puts(3)(29) <= d_in(14);
   array_puts(3)(30) <= '0';
   array_puts(3)(31) <= d_in(15);

   u3 : MUX_ARRAY PORT MAP( array_puts(3), shift(3), array_outs(3));

   array_puts(2)(0) <= array_outs(3)(4);
   array_puts(2)(1) <= array_outs(3)(0);
   array_puts(2)(2) <= array_outs(3)(5);
   array_puts(2)(3) <= array_outs(3)(1);
   array_puts(2)(4) <= array_outs(3)(6);
   array_puts(2)(5) <= array_outs(3)(2);
   array_puts(2)(6) <= array_outs(3)(7);
   array_puts(2)(7) <= array_outs(3)(3);
   array_puts(2)(8) <= array_outs(3)(8);
   array_puts(2)(9) <= array_outs(3)(4);
   array_puts(2)(10) <= array_outs(3)(9);
   array_puts(2)(11) <= array_outs(3)(5);
   array_puts(2)(12) <= array_outs(3)(10);
   array_puts(2)(13) <= array_outs(3)(6);
   array_puts(2)(14) <= array_outs(3)(11);
   array_puts(2)(15) <= array_outs(3)(7);
   array_puts(2)(16) <= array_outs(3)(12);
   array_puts(2)(17) <= array_outs(3)(8);
   array_puts(2)(18) <= array_outs(3)(13);
   array_puts(2)(19) <= array_outs(3)(9);
   array_puts(2)(20) <= array_outs(3)(14);
   array_puts(2)(21) <= array_outs(3)(10);
   array_puts(2)(22) <= array_outs(3)(15);
   array_puts(2)(23) <= array_outs(3)(11);
   array_puts(2)(24) <= '0';
   array_puts(2)(25) <= array_outs(3)(12);
   array_puts(2)(26) <= '0';
   array_puts(2)(27) <= array_outs(3)(13);
   array_puts(2)(28) <= '0';
   array_puts(2)(29) <= array_outs(3)(14);
   array_puts(2)(30) <= '0';
   array_puts(2)(31) <= array_outs(3)(15);
   u2 : MUX_ARRAY PORT MAP( array_puts(2), shift(2), array_outs(2));

   array_puts(1)(0) <= array_outs(2)(2);
   array_puts(1)(1) <= array_outs(2)(0);
   array_puts(1)(2) <= array_outs(2)(3);
   array_puts(1)(3) <= array_outs(2)(1);
   array_puts(1)(4) <= array_outs(2)(4);
   array_puts(1)(5) <= array_outs(2)(2);
   array_puts(1)(6) <= array_outs(2)(5);
   array_puts(1)(7) <= array_outs(2)(3);
   array_puts(1)(8) <= array_outs(2)(6);
   array_puts(1)(9) <= array_outs(2)(4);
   array_puts(1)(10) <= array_outs(2)(7);
   array_puts(1)(11) <= array_outs(2)(5);
   array_puts(1)(12) <= array_outs(2)(8);
   array_puts(1)(13) <= array_outs(2)(6);
   array_puts(1)(14) <= array_outs(2)(9);
   array_puts(1)(15) <= array_outs(2)(7);
   array_puts(1)(16) <= array_outs(2)(10);
   array_puts(1)(17) <= array_outs(2)(8);
   array_puts(1)(18) <= array_outs(2)(11);
   array_puts(1)(19) <= array_outs(2)(9);
   array_puts(1)(20) <= array_outs(2)(12);
   array_puts(1)(21) <= array_outs(2)(10);
   array_puts(1)(22) <= array_outs(2)(13);
   array_puts(1)(23) <= array_outs(2)(11);
   array_puts(1)(24) <= array_outs(2)(14);
   array_puts(1)(25) <= array_outs(2)(12);
   array_puts(1)(26) <= array_outs(2)(15);
   array_puts(1)(27) <= array_outs(2)(13);
   array_puts(1)(28) <= '0';
   array_puts(1)(29) <= array_outs(2)(14);
   array_puts(1)(30) <= '0';
   array_puts(1)(31) <= array_outs(2)(15);
   u1 : MUX_ARRAY PORT MAP( array_puts(1), shift(1), array_outs(1));

   array_puts(0)(0) <= array_outs(1)(1);
   array_puts(0)(1) <= array_outs(1)(0);
   array_puts(0)(2) <= array_outs(1)(2);
   array_puts(0)(3) <= array_outs(1)(1);
   array_puts(0)(4) <= array_outs(1)(3);
   array_puts(0)(5) <= array_outs(1)(2);
   array_puts(0)(6) <= array_outs(1)(4);
   array_puts(0)(7) <= array_outs(1)(3);
   array_puts(0)(8) <= array_outs(1)(5);
   array_puts(0)(9) <= array_outs(1)(4);
   array_puts(0)(10) <= array_outs(1)(6);
   array_puts(0)(11) <= array_outs(1)(5);
   array_puts(0)(12) <= array_outs(1)(7);
   array_puts(0)(13) <= array_outs(1)(6);
   array_puts(0)(14) <= array_outs(1)(8);
   array_puts(0)(15) <= array_outs(1)(7);
   array_puts(0)(16) <= array_outs(1)(9);
   array_puts(0)(17) <= array_outs(1)(8);
   array_puts(0)(18) <= array_outs(1)(10);
   array_puts(0)(19) <= array_outs(1)(9);
   array_puts(0)(20) <= array_outs(1)(11);
   array_puts(0)(21) <= array_outs(1)(10);
   array_puts(0)(22) <= array_outs(1)(12);
   array_puts(0)(23) <= array_outs(1)(11);
   array_puts(0)(24) <= array_outs(1)(13);
   array_puts(0)(25) <= array_outs(1)(12);
   array_puts(0)(26) <= array_outs(1)(14);
   array_puts(0)(27) <= array_outs(1)(13);
   array_puts(0)(28) <= array_outs(1)(15);
   array_puts(0)(29) <= array_outs(1)(14);
   array_puts(0)(30) <= '0';
   array_puts(0)(31) <= array_outs(1)(15);
   u0 : MUX_ARRAY PORT MAP( array_puts(0), shift(0), array_outs(0));

   d_out <= array_outs(0);

END behavioural;