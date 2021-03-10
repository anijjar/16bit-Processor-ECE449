
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WRITE_BACK_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
	  in_reg_wb : IN STD_LOGIC;
	  in_ar : in std_logic_vector(15 downto 0);
      in_ra : in std_logic_vector(2 downto 0);
	  
      out_cpu : out std_logic_vector(15 downto 0);
	   out_ar : out std_logic_vector(15 downto 0);
      out_ra : out std_logic_vector(2 downto 0)
   );        
END WRITE_BACK_CONTROLLER;

ARCHITECTURE behav OF WRITE_BACK_CONTROLLER IS


BEGIN
   

END behav;