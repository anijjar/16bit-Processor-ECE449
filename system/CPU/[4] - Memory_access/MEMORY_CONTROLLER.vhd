
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MEMORY_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      in_dr1 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_dr2 : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_memwb : IN STD_LOGIC;
      in_memrd : IN STD_LOGIC;
      in_ra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_rb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_memwb_opcode : in std_logic_vector(6 downto 0);
      in_memwb_forwarded_address_a : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_memwb_forwarded_address_b : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      in_wb_forwarded_data : IN STD_LOGIC_VECTOR(N DOWNTO 0);
      in_memwb_forwarded_data : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      out_ram_mem : out STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	  --add pins for port a of ram
      out_RAM_rst_a : out STD_LOGIC;
      out_RAM_en_a : out STD_LOGIC;
      out_RAM_wen_a : out std_logic_vector(0 downto 0); 
      out_RAM_addy_a : out std_logic_vector(9 downto 0); 
      out_RAM_din_a : out std_logic_vector(N-1 downto 0);
      out_RAM_dout_a : in std_logic_vector(N-1 downto 0);
	  display : out std_logic_vector(N-1 downto 0)
   );        
END MEMORY_CONTROLLER;

ARCHITECTURE level_2 OF MEMORY_CONTROLLER IS
    SIGNAL last_store_address : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
BEGIN
   PROCESS (clk, rst, in_dr1, in_dr2, in_memwb, in_memrd, in_opcode)
   variable port_a_en_on : integer := 0;
   BEGIN
      IF (rst = '1') THEN
         out_RAM_rst_a <= '1';
         out_RAM_en_a <= '0';
         out_RAM_wen_a <= "0";
         out_RAM_addy_a <= (others => '0');
         out_RAM_din_a <= (others => '0');
      ELSE
         if(rising_edge(clk)) then
            if(in_memrd = '1' or in_memwb = '1') then
                out_RAM_en_a <= '0';
            end if;
         end if;
         IF (in_memrd = '1') THEN
            out_RAM_rst_a <= '0';
            out_RAM_en_a <= '1';
            out_RAM_wen_a <= "0";
            if((in_rb = in_memwb_forwarded_address_b) 
                and (in_memwb_opcode /= "0000000") --nop
                and (in_memwb_opcode /= "1000000") --brr stuff
                and (in_memwb_opcode /= "1000001") 
                and (in_memwb_opcode /= "1000010") 
                and (in_memwb_opcode /= "1001000")
                and (in_memwb_opcode /= "1000011") -- br
                and (in_memwb_opcode /= "1000100") 
                and (in_memwb_opcode /= "1000101") 
                and (in_memwb_opcode /= "1001001") 
                and (in_memwb_opcode /= "1000110") --brr.sub
                ) then -- for load
                out_RAM_addy_a <= last_store_address;
            else
                out_RAM_addy_a <= in_dr2(9 downto 0);
            end if;
            out_RAM_din_a <= X"0000";
         end if;
         IF (in_memwb = '1') THEN
            out_RAM_rst_a <= '0';
            out_RAM_en_a <= '1';
            out_RAM_wen_a <= "1";
            if(in_ra = in_memwb_forwarded_address_a
                and (in_memwb_opcode /= "0000000") --nop
                and (in_memwb_opcode /= "1000000") --brr stuff
                and (in_memwb_opcode /= "1000001") 
                and (in_memwb_opcode /= "1000010") 
                and (in_memwb_opcode /= "1001000")
                and (in_memwb_opcode /= "1000011") -- br
                and (in_memwb_opcode /= "1000100") 
                and (in_memwb_opcode /= "1000101") 
                and (in_memwb_opcode /= "1001001") 
                and (in_memwb_opcode /= "1000110") --brr.sub
                ) then -- for store
                out_RAM_addy_a <= in_wb_forwarded_data(9 downto 0);
                last_store_address <= in_wb_forwarded_data(9 downto 0);
            else
                out_RAM_addy_a <= in_dr1(9 downto 0); -- contents of ra go here
            end if;
            -- if store address is 0xfff2, then route to led
            if( in_dr1(9 downto 0) = "11"&X"F2" or in_wb_forwarded_data(9 downto 0) = "11"&X"F2" ) then
                display <= in_dr2(15 downto 0);
                out_RAM_din_a <= in_dr2(15 downto 0);
            else
                out_RAM_din_a <= in_dr2(15 downto 0);
            end if;
         END IF;
         if(in_memwb = '1' or in_memrd = '1') then
            out_RAM_en_a <= '1';
         else
            out_RAM_en_a <= '0';
         end if;
      END IF;
   END PROCESS;
   out_ram_mem <= out_RAM_dout_a;
END level_2;