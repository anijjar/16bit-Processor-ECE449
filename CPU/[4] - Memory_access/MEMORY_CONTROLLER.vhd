
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMORY_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
	  
	  in_ar : IN STD_LOGIC_VECTOR(N downto 0); -- result of alu
	  in_ra : IN STD_LOGIC_VECTOR(2 downto 0); -- address of dest register
	  in_regwb : IN STD_LOGIC; -- forward to register
	  in_memwb : IN STD_LOGIC; -- write to memory
	  
	  --memwb latch
	  out_reg_wb : out STD_LOGIC; -- 1 for regiseter, 0 for system out
	  out_ar : out std_logic_vector(15 downto 0);
	  out_ra : out std_logic_vector(2 downto 0);
	  
	  --add pins for port a of ram
	  out_RAM_rst_a : out STD_LOGIC;
	  out_RAM_en_a : out STD_LOGIC;
	  out_RAM_wen_a : out std_logic_vector(0 downto 0); 
	  out_RAM_addy_a : out std_logic_vector(N-1 downto 0); 
	  out_RAM_din_a : out std_logic_vector(N-1 downto 0);
	  out_RAM_dout_a : in std_logic_vector(N-1 downto 0)
	  
   );        
END MEMORY_CONTROLLER;

ARCHITECTURE behav OF MEMORY_CONTROLLER IS
	

BEGIN
   process(in_ar, in_ra, in_regwb, in_memwb)
   begin
   if (rst = '1') then
	 out_reg_wb <= '0';
	 out_ar <= X"0000";
	 out_ra <= X"0000";
   else
	   if(in_regwb = '1') then
         out_ar <= in_ar; --data
         out_ra <= in_ra; -- address
         out_reg_wb <= in_regwb; --enable wb
      end if;
      -- worry about this when L instructions
      -- if(in_memwb = '1') then
      --    out_RAM_rst_a <= '0'; 
      --    out_RAM_en_a <= '1';
      --    out_RAM_wen_a <= '1'; 
      --    out_RAM_addy_a <= in_ar; -- contents of ra go here
      --    out_RAM_din_a <= 
      -- end if;
   end if;
   end process;
END behav;