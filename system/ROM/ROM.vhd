library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

Library xpm;
use xpm.vcomponents.all;


entity ROM is
  port (
    Clock   : in std_logic;
	Reset	: in std_logic;	
	Enable	: in std_logic;
	Read	: in std_logic;
	Address	: in std_logic_vector(9 downto 0);
    Data_out: out std_logic_vector(15 downto 0)
  ) ;
end ROM ; 

architecture arch of ROM is
			
begin
-- xpm_memory_sprom: Single Port ROM
-- Xilinx Parameterized Macro, Version 2017.4
xpm_memory_sprom_inst : xpm_memory_sprom
  generic map (
    -- Common module generics
    MEMORY_SIZE             => 8192,            --positive integer
    MEMORY_PRIMITIVE        => "auto",          --string; "auto", "distributed", or "block";
    MEMORY_INIT_FILE        => "counter.mem",          --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "",              --string;
    USE_MEM_INIT            => 1,               --integer; 0,1
    WAKEUP_TIME             => "disable_sleep", --string; "disable_sleep" or "use_sleep_pin" 
    MESSAGE_CONTROL         => 0,               --integer; 0,1
    ECC_MODE                => "no_ecc",        --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
    AUTO_SLEEP_TIME         => 0,               --Do not Change
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    READ_DATA_WIDTH_A       => 16,              --positive integer
    ADDR_WIDTH_A            => 10,               --positive integer
    READ_RESET_VALUE_A      => "0000",             --string
    READ_LATENCY_A          => 0                --non-negative integer
  )
  port map (
    -- Common module ports
    sleep                   => '0',
    -- Port A module ports
    clka                    => Clock,
    rsta                    => Reset,
    ena                     => Enable,
    regcea                  => Read,
    addra                   => Address,
    injectsbiterra          => '0',   --do not change
    injectdbiterra          => '0',   --do not change
    douta                   => Data_out,
    sbiterra                => open,  --do not change
    dbiterra                => open   --do not change
  );

	

end architecture ;