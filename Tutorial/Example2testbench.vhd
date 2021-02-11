-----------------------------------------------------------
--
-- ECE241 Lab 2
--
-- Example 2 test bench
--
-- (c)2018 Dr. D. Capson   Dept. of ECE
--                         University of Victoria
--
-----------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--  the entity for your test bench code must be declared
--  as follows:

entity Example2_testbench is
end Example2_testbench;

architecture simulate of Example2_testbench is

	signal a: std_logic;
	signal b: std_logic;
	signal c: std_logic;
	signal d: std_logic;

	signal Y1: std_logic;
	signal Y2: std_logic;
	signal Y3: std_logic;
	signal Y4: std_logic;
	signal Y5: std_logic;

begin

-- entity instantiation (uut = "unit under test")
-- the name of the entity ("Example2" in this example) must
-- match the name of your upper level entity that you are
-- simulating.  Also the word "work" must be used as shown.
-- You should do explicit connections in the port map as follows
-- (otherwise you get a warning):
--      ( ip1 => ip1_s, ip2 => ip2_s, sum => sum_s, ca => ca_s);

uut : entity work.Example2 port map(a=>a, b=>b, c=>c, d=>d, Y1=>Y1, Y2=>Y2, Y3=>Y3, Y4=>Y4, Y5=>Y5);

-- specify a sequence of inputs for simulating our design

process 
	begin

	a <= '0';
	b <= '0';
	c <= '0';
	d <= '0';
	wait for 10 ns;

	a <= '1';
	b <= '1';
	c <= '0';
	d <= '0';
	wait for 10 ns;

	a <= '0';
	b <= '1';
	c <= '1';
	d <= '0';
	wait for 10 ns;

	a <= '1';
	b <= '1';
	c <= '1';
	d <= '1';
	wait;

end process;

end simulate;