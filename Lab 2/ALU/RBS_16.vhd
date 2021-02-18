
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

   SIGNAL d : STD_LOGIC_VECTOR (31 DOWNTO 0);
   TYPE array_puts IS ARRAY (INTEGER RANGE 0 TO 4) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

   array_puts(4) <= d_in;

   u3 : MUX_ARRAY PORT MAP(
      d_in(0) => array_puts(4)(8),
      d_in(1) => array_puts(4)(0),
      d_in(2) => array_puts(4)(9),
      d_in(3) => array_puts(4)(1),
      d_in(4) => array_puts(4)(10),
      d_in(5) => array_puts(4)(2),
      d_in(6) => array_puts(4)(11),
      d_in(7) => array_puts(4)(3),
      d_in(8) => array_puts(4)(12),
      d_in(9) => array_puts(4)(4),
      d_in(10) => array_puts(4)(13),
      d_in(11) => array_puts(4)(5),
      d_in(12) => array_puts(4)(14),
      d_in(13) => array_puts(4)(6),
      d_in(14) => array_puts(4)(15),
      d_in(15) => array_puts(4)(7),
      d_in(16) => '0',
      d_in(17) => array_puts(4)(8),
      d_in(18) => '0',
      d_in(19) => array_puts(4)(9),
      d_in(20) => '0',
      d_in(21) => array_puts(4)(10),
      d_in(22) => '0',
      d_in(23) => array_puts(4)(11),
      d_in(24) => '0',
      d_in(25) => array_puts(4)(12),
      d_in(26) => '0',
      d_in(27) => array_puts(4)(13), 
      d_in(28) => '0',
      d_in(29) => array_puts(4)(14),
      d_in(30) => '0',
      d_in(31) => array_puts(4)(15),
      shift => shift(3),
      d_out => array_puts(3),
   );
   u2 : MUX_ARRAY PORT MAP(
      d_in(0) => array_puts(3)(4),
      d_in(1) => array_puts(3)(0),
      d_in(2) => array_puts(3)(5),
      d_in(3) => array_puts(3)(1),
      d_in(4) => array_puts(3)(6),
      d_in(5) => array_puts(3)(2),
      d_in(6) => array_puts(3)(7),
      d_in(7) => array_puts(3)(3),
      d_in(8) => array_puts(3)(8),
      d_in(9) => array_puts(3)(4),
      d_in(10) => array_puts(3)(9),
      d_in(11) => array_puts(3)(5),
      d_in(12) => array_puts(3)(10),
      d_in(13) => array_puts(3)(6),
      d_in(14) => array_puts(3)(11),
      d_in(15) => array_puts(3)(7),
      d_in(16) => array_puts(3)(12),
      d_in(17) => array_puts(3)(8),
      d_in(18) => array_puts(3)(13),
      d_in(19) => array_puts(3)(9),
      d_in(20) => array_puts(3)(14),
      d_in(21) => array_puts(3)(10),
      d_in(22) => array_puts(3)(15),
      d_in(23) => array_puts(3)(11),
      d_in(24) => '0',
      d_in(25) => array_puts(3)(12),
      d_in(26) => '0',
      d_in(27) => array_puts(3)(13), 
      d_in(28) => '0',
      d_in(29) => array_puts(3)(14),
      d_in(30) => '0',
      d_in(31) => array_puts(3)(15),
      shift => shift(2),
      d_out => array_puts(2),
   );
   u1 : MUX_ARRAY PORT MAP(
      d_in(0) => array_puts(2)(2),
      d_in(1) => array_puts(2)(0),
      d_in(2) => array_puts(2)(3),
      d_in(3) => array_puts(2)(1),
      d_in(4) => array_puts(2)(4),
      d_in(5) => array_puts(2)(2),
      d_in(6) => array_puts(2)(5),
      d_in(7) => array_puts(2)(3),
      d_in(8) => array_puts(2)(6),
      d_in(9) => array_puts(2)(4),
      d_in(10) => array_puts(2)(7),
      d_in(11) => array_puts(2)(5),
      d_in(12) => array_puts(2)(8),
      d_in(13) => array_puts(2)(6),
      d_in(14) => array_puts(2)(9),
      d_in(15) => array_puts(2)(7),
      d_in(16) => array_puts(2)(10),
      d_in(17) => array_puts(2)(8),
      d_in(18) => array_puts(2)(11),
      d_in(19) => array_puts(2)(9),
      d_in(20) => array_puts(2)(12),
      d_in(21) => array_puts(2)(10),
      d_in(22) => array_puts(2)(13),
      d_in(23) => array_puts(2)(11),
      d_in(24) => array_puts(2)(14), 
      d_in(25) => array_puts(2)(12),
      d_in(26) => array_puts(2)(15), 
      d_in(27) => array_puts(2)(13), 
      d_in(28) => '0',
      d_in(29) => array_puts(2)(14),
      d_in(30) => '0',
      d_in(31) => array_puts(2)(15),
      shift => shift(1),
      d_out => array_puts(1),
   );
   u0 : MUX_ARRAY PORT MAP(
      d_in(0) => array_puts(1)(1),
      d_in(1) => array_puts(1)(0),
      d_in(2) => array_puts(1)(2),
      d_in(3) => array_puts(1)(1),
      d_in(4) => array_puts(1)(3),
      d_in(5) => array_puts(1)(2),
      d_in(6) => array_puts(1)(4),
      d_in(7) => array_puts(1)(3),
      d_in(8) => array_puts(1)(5),
      d_in(9) => array_puts(1)(4),
      d_in(10) => array_puts(1)(6),
      d_in(11) => array_puts(1)(5),
      d_in(12) => array_puts(1)(7),
      d_in(13) => array_puts(1)(6),
      d_in(14) => array_puts(1)(8),
      d_in(15) => array_puts(1)(7),
      d_in(16) => array_puts(1)(9),
      d_in(17) => array_puts(1)(8),
      d_in(18) => array_puts(1)(10),
      d_in(19) => array_puts(1)(9),
      d_in(20) => array_puts(1)(11),
      d_in(21) => array_puts(1)(10),
      d_in(22) => array_puts(1)(12),
      d_in(23) => array_puts(1)(11),
      d_in(24) => array_puts(1)(13), 
      d_in(25) => array_puts(1)(12),
      d_in(26) => array_puts(1)(14), 
      d_in(27) => array_puts(1)(13), 
      d_in(28) => array_puts(1)(15),
      d_in(29) => array_puts(1)(14),
      d_in(30) => '0',
      d_in(31) => array_puts(1)(15),
      shift => shift(0),
      d_out => array_puts(0),
   );
   d_out <= array_puts(0);

END behavioural;