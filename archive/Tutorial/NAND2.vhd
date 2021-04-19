-----------------------------------------------------------
--
-- ECE241 Lab 2
--
-- First example - a simple 2-input NAND gate
--
-- (c)2018 Dr. D. Capson   Dept. of ECE
--                         University of Victoria
--
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity myNANDgate is
port (
	a,b : in STD_LOGIC;
	Y   : out STD_LOGIC
	);
end myNANDgate;


architecture Lab2 of myNANDgate is

begin
        
	Y <=  a NAND b;

end Lab2;

