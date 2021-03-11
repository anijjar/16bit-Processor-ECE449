
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
	   in_ar : in std_logic_vector(16 downto 0);
      in_ra : in std_logic_vector(2 downto 0);
	  
      out_cpu : out std_logic_vector(15 downto 0);
	   out_ar : out std_logic_vector(16 downto 0);
      out_ra : out std_logic_vector(2 downto 0);
      out_ra_wen : out std_logic
   );        
END WRITE_BACK_CONTROLLER;

ARCHITECTURE level_2 OF WRITE_BACK_CONTROLLER IS


BEGIN
   Controller: process(rst, in_reg_wb, in_ar, in_ra)
   begin
      if(rst = '0') then
         if(in_reg_wb = '0') then -- only output
            out_cpu <= in_ar(15 downto 0);
            out_ar <=(others => '0');
            out_ra <= "000";
            out_ra_wen <= '0';
         elsif (in_reg_wb = '1') then -- only register
            out_cpu <= X"0000";
            out_ar <= in_ar;
            out_ra <= in_ra;
            out_ra_wen <= '1';
         else -- write to register and output pins
            out_cpu <= in_ar(15 downto 0);
            out_ar <= in_ar;
            out_ra <= in_ra;
            out_ra_wen <= '1';   
         end if;
      else
         out_cpu <= X"0000";
         out_ra <= "000";
         out_ar <= (others => '0');
         out_ra_wen <= '0';
      end if;
   end process Controller;
END level_2;