-----------------------------------------------------------
--
-- ECE241 Lab 2
--
-- Second example that implements some simple random logic
--
-- (c)2018 Dr. D. Capson    Dept. of ECE
--                          University of Victoria
--
-----------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Example2 is 
port (
		a,b,c,d        : in STD_LOGIC;
		Y1,Y2,Y3,Y4,Y5 : out STD_LOGIC
	);
end Example2;

architecture Lab2 of Example2 is

signal p1, p2 : STD_LOGIC;  -- internal signals

begin       -- note that all of the following statements are concurrent
        
    Y1 <=  a XOR b;
    Y2 <=  a NAND b;
    Y3 <=  p1 NAND p2;
    Y4 <=  NOT d;
    Y5 <=  d;

    p1 <= a NAND b; -- it doesn't matter that p1, p2 were used
    p2 <= c NAND d; -- prior to their definition here
    
 end Lab2;
