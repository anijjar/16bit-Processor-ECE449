LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY xpm;
USE xpm.vcomponents.ALL;
ENTITY RAM IS
   PORT (
      Clock : IN STD_LOGIC;
      Reset_a : IN STD_LOGIC;
      Reset_b : IN STD_LOGIC;
      Enable_a : IN STD_LOGIC;
      Enable_b : IN STD_LOGIC;
      Write_en_a : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      Address_a : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      Address_b : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
      data_in_a : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- b doesnt do write operations
      Data_out_a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      Data_out_b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END RAM;

ARCHITECTURE arch OF RAM IS
BEGIN
   xpm_memory_dpdistram_inst : xpm_memory_dpdistram
   GENERIC MAP(

      -- Common module generics
      MEMORY_SIZE => 8192, --positive integer
      CLOCKING_MODE => "common_clock", --string; "common_clock", "independent_clock" 
      MEMORY_INIT_FILE => "none", --string; "none" or "<filename>.mem" 
      MEMORY_INIT_PARAM => "", --string;
      USE_MEM_INIT => 1, --integer; 0,1
      MESSAGE_CONTROL => 0, --integer; 0,1
      USE_EMBEDDED_CONSTRAINT => 0, --integer: 0,1
      MEMORY_OPTIMIZATION => "true", --string; "true", "false" 

      -- Port A module generics
      WRITE_DATA_WIDTH_A => 16, --positive integer
      READ_DATA_WIDTH_A => 16, --positive integer
      BYTE_WRITE_WIDTH_A => 16, --integer; 8, 9, or WRITE_DATA_WIDTH_A value
      ADDR_WIDTH_A => 10, --positive integer
      READ_RESET_VALUE_A => "0", --string
      READ_LATENCY_A => 0, --non-negative integer

      -- Port B module generics
      READ_DATA_WIDTH_B => 16, --positive integer
      ADDR_WIDTH_B => 10, --positive integer
      READ_RESET_VALUE_B => "0", --string
      READ_LATENCY_B => 0 --non-negative integer
   )
   PORT MAP(

      -- Port A module ports
      clka => Clock, -- clock a
      rsta => Reset_a, -- reset a
      ena => Enable_a, -- enable a
      regcea => '1', --do not change
      wea => Write_en_a, -- write enable
      addra => Address_a, -- port A address
      dina => data_in_a, -- port A write data
      douta => Data_out_a, -- Port A output address, outputs after read_latency clock cycles

      -- Port B module ports
      clkb => Clock,
      rstb => Reset_b,
      enb => Enable_b,
      regceb => '1', --do not change
      addrb => Address_b,
      doutb => Data_out_b
   );

   -- add latch here and map it

END ARCHITECTURE;