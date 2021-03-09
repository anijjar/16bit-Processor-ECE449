
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMORY_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk : IN STD_LOGIC;
      --match ports to EMEM and MEMWB latches
      -- matching output signals
      EXMEM_ar      : in std_logic_vector(15 downto 0);
      EXMEM_regwb   : in std_logic; -- 
      EXMEM_memwb   : in std_logic; -- WR_EN OF RAM PORT A
      EXMEM_ra      : in std_logic_vector(2  downto 0)
   );        
END MEMORY_CONTROLLER;

ARCHITECTURE behav OF MEMORY_CONTROLLER IS


BEGIN
   

END behav;