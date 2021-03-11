library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

Library xpm;
use xpm.vcomponents.all;


entity RAM is
  port (
   Clock   : in std_logic;
	Reset_a	: in std_logic;	
	Reset_b	: in std_logic;	
   Enable_a	: in std_logic;
   Enable_b	: in std_logic;
	Write_en_a	: in std_logic_vector(0 downto 0); -- 1 for bottom bits, 2 for upper, 3 for all
	Address_a	: in std_logic_vector(15 downto 0); --2^13 addresses in 1024 byte ram
	Address_b	: in std_logic_vector(15 downto 0);
	data_in_a	: in std_logic_vector(15 downto 0); -- b doesnt do write operations
	Data_out_a: out std_logic_vector(15 downto 0);
	Data_out_b: out std_logic_vector(15 downto 0)
  ) ;
end RAM ; 

architecture arch of RAM is
begin
   xpm_memory_dpdistram_inst : xpm_memory_dpdistram
   generic map (
 
     -- Common module generics
     MEMORY_SIZE             => 8192,           --positive integer
     CLOCKING_MODE           => "common_clock", --string; "common_clock", "independent_clock" 
     MEMORY_INIT_FILE        => "format_a_test.mem",         --string; "none" or "<filename>.mem" 
     MEMORY_INIT_PARAM       => "",             --string;
     USE_MEM_INIT            => 1,              --integer; 0,1
     MESSAGE_CONTROL         => 0,              --integer; 0,1
     USE_EMBEDDED_CONSTRAINT => 0,              --integer: 0,1
     MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 
 
     -- Port A module generics
     WRITE_DATA_WIDTH_A      => 16,             --positive integer
     READ_DATA_WIDTH_A       => 16,             --positive integer
     BYTE_WRITE_WIDTH_A      => 16,             --integer; 8, 9, or WRITE_DATA_WIDTH_A value
     ADDR_WIDTH_A            => 16,              --positive integer
     READ_RESET_VALUE_A      => "0",            --string
     READ_LATENCY_A          => 1,              --non-negative integer
 
     -- Port B module generics
     READ_DATA_WIDTH_B       => 16,             --positive integer
     ADDR_WIDTH_B            => 16,              --positive integer
     READ_RESET_VALUE_B      => "0",            --string
     READ_LATENCY_B          => 1               --non-negative integer
   )
   port map (
 
     -- Port A module ports
     clka                    => Clock, -- clock a
     rsta                    => Reset_a, -- reset a
     ena                     => Enable_a, -- enable a
     regcea                  => '1',   --do not change
     wea                     => Write_en_a, -- write enable
     addra                   => Address_a, -- port A address
     dina                    => data_in_a, -- port A write data
     douta                   => Data_out_a, -- Port A output address, outputs after read_latency clock cycles
 
     -- Port B module ports
     clkb                    => Clock,
     rstb                    => Reset_b,
     enb                     => Enable_b,
     regceb                  => '1',   --do not change
     addrb                   => Address_b,
     doutb                   => Data_out_b
   );

   -- add latch here and map it
   
end architecture ;
