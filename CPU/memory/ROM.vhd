LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY xpm;
USE xpm.vcomponents.ALL;
ENTITY ROM IS
   PORT (
      Clock : IN STD_LOGIC;
      Reset : IN STD_LOGIC;
      Enable : IN STD_LOGIC;
      Read : IN STD_LOGIC;
      Address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END ROM;

ARCHITECTURE arch OF ROM IS

BEGIN
   -- xpm_memory_sprom: Single Port ROM
   -- Xilinx Parameterized Macro, Version 2017.4
   xpm_memory_sprom_inst : xpm_memory_sprom
   GENERIC MAP(
      -- Common module generics
      MEMORY_SIZE => 1024, --positive integer
      MEMORY_PRIMITIVE => "auto", --string; "auto", "distributed", or "block";
      MEMORY_INIT_FILE => "test.mem", --string; "none" or "<filename>.mem" 
      MEMORY_INIT_PARAM => "", --string;
      USE_MEM_INIT => 1, --integer; 0,1
      WAKEUP_TIME => "disable_sleep", --string; "disable_sleep" or "use_sleep_pin" 
      MESSAGE_CONTROL => 0, --integer; 0,1
      ECC_MODE => "no_ecc", --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
      AUTO_SLEEP_TIME => 0, --Do not Change
      MEMORY_OPTIMIZATION => "true", --string; "true", "false" 

      -- Port A module generics
      READ_DATA_WIDTH_A => 16, --positive integer
      ADDR_WIDTH_A => 16, --positive integer
      READ_RESET_VALUE_A => "0", --string
      READ_LATENCY_A => 1 --non-negative integer
   )
   PORT MAP(
      -- Common module ports
      sleep => '0',
      -- Port A module ports
      clka => Clock,
      rsta => Reset,
      ena => Enable,
      regcea => Read,
      addra => Address,
      injectsbiterra => '0', --do not change
      injectdbiterra => '0', --do not change
      douta => Data_out,
      sbiterra => OPEN, --do not change
      dbiterra => OPEN --do not change
   );

END ARCHITECTURE;