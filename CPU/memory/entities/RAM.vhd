
-- XPM_MEMORY instantiation template for dual port distributed RAM configurations
-- Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
-- =======================================================================================================================
--
-- Generic usage table, organized as follows:
-- +---------------------------------------------------------------------------------------------------------------------+
-- | Generic name            | Data type          | Restrictions, if applicable                                          |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Description                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_SIZE             | Integer            | Must be integer multiple of [WRITE|READ]_DATA_WIDTH_[A|B]            |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the total memory array size, in bits.                                                                       |
-- | For example, enter 65536 for a 2kx32 RAM.                                                                           |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | CLOCKING_MODE           | String             | Must be "common_clock" or "independent_clock"                        |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Designate whether port A and port B are clocked with a common clock or with independent clocks:                     |
-- |   "common_clock": Common clocking; clock both port A and port B with clka                                           |
-- |   "independent_clock": Independent clocking; clock port A with clka and port B with clkb                            |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_INIT_FILE        | String             | Must be exactly "none" or the name of the file (in quotes)           |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file:|
-- |   Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").      |
-- |   File format must be ASCII and consist of only hexadecimal values organized into the specified depth by            |
-- |   narrowest data width generic value of the memory.  See the Memory File (MEM) section for more                     |
-- |   information on the syntax. Initialization of memory happens through the file name specified only when generic     |
-- |   MEMORY_INIT_PARAM value is equal to "".                                                                           |
-- |   When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_INIT_PARAM       | String             | Must be exactly "" or the string of hex characters (in quotes)       |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
-- | containing the hex characters.Enter only hex characters and each location separated by delimiter(,).                |
-- | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
-- | narrowest data width generic value of the memory.  For example, if the narrowest data width is 8, and the depth of  |
-- | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
-- |   parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                             |
-- |                                  |                   |                                                              |
-- |                                  0th                7th                                                             |
-- |                                location            location                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | USE_MEM_INIT            | Integer            | Must be 0 or 1                                                       |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify 1 to enable the generation of below message and 0 to disable the generation of below message completely.    |
-- | Note: This message gets generated only when there is no Memory Initialization specified either through file or      |
-- | Parameter.                                                                                                          |
-- |    INFO : MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                       |
-- |    Initial memory contents will be all 0's                                                                          |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MESSAGE_CONTROL         | Integer            | Must be 0 or 1                                                       |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
-- +---------------------------------------------------------------------------------------------------------------------+
-- | USE_EMBEDDED_CONSTRAINT | Integer            | Must be 0 or 1                                                       |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify 1 to enable the set_false_path constraint addition between clka of Distributed RAM and doutb_reg on clkb    |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | MEMORY_OPTIMIZATION     | String             | Must be "true" or "false"                                            |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify "false" to disable the optimization of unused memory or bits in the memory structure                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | WRITE_DATA_WIDTH_A      | Integer            | Must be > 0 and equal to the value of READ_DATA_WIDTH_A              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port A write data input port dina, in bits.                                                |
-- | The values of WRITE_DATA_WIDTH_A and READ_DATA_WIDTH_A must be equal.                                               |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_DATA_WIDTH_A       | Integer            | Must be > 0 and equal to the value of WRITE_DATA_WIDTH_A             |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port A read data output port douta, in bits.                                               |
-- | The values of READ_DATA_WIDTH_A and WRITE_DATA_WIDTH_A must be equal.                                               |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | BYTE_WRITE_WIDTH_A      | Integer            | Must be 8, 9, or the value of WRITE_DATA_WIDTH_A                     |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | To enable byte-wide writes on port A, specify the byte width, in bits:                                              |
-- |   8: 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 8                              |
-- |   9: 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 9                              |
-- | Or to enable word-wide writes on port A, specify the same value as for WRITE_DATA_WIDTH_A.                          |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ADDR_WIDTH_A            | Integer            | Must be >= ceiling of log2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_A)    |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port A address port addra, in bits.                                                        |
-- | Must be large enough to access the entire memory from port A, i.e. >= $clog2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_A).|
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_RESET_VALUE_A      | String             |                                                                      |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the reset value of the port A final output register stage in response to rsta input port is assertion.      |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_LATENCY_A          | Integer            | Must be >= 0 for distributed memory, or >= 1 for block memory        |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the number of register stages in the port A read data pipeline. Read data output to port douta takes this   |
-- | number of clka cycles.                                                                                              |
-- | To target block memory, a value of 1 or larger is required: 1 causes use of memory latch only; 2 causes use of      |
-- | output register. To target distributed memory, a value of 0 or larger is required: 0 indicates combinatorial output.|
-- | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_DATA_WIDTH_B       | Integer            | Must be > 0 and equal to the value of WRITE_DATA_WIDTH_B             |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port B read data output port doutb, in bits.                                               |
-- | The values of READ_DATA_WIDTH_B and WRITE_DATA_WIDTH_B must be equal.                                               |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ADDR_WIDTH_B            | Integer            | Must be >= ceiling of log2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_B)    |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the width of the port B address port addrb, in bits.                                                        |
-- | Must be large enough to access the entire memory from port B, i.e. >= $clog2(MEMORY_SIZE/[WRITE|READ]_DATA_WIDTH_B).|
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_RESET_VALUE_B      | String             |                                                                      |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the reset value of the port B final output register stage in response to rstb input port is assertion.      |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | READ_LATENCY_B          | Integer            | Must be >= 0 for distributed memory, or >= 1 for block memory        |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Specify the number of register stages in the port B read data pipeline. Read data output to port doutb takes this   |
-- | number of clkb cycles (clka when CLOCKING_MODE is "common_clock").                                                  |
-- | To target block memory, a value of 1 or larger is required: 1 causes use of memory latch only; 2 causes use of      |
-- | output register. To target distributed memory, a value of 0 or larger is required: 0 indicates combinatorial output.|
-- | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
-- +---------------------------------------------------------------------------------------------------------------------+
--
-- Port usage table, organized as follows:
-- +---------------------------------------------------------------------------------------------------------------------+
-- | Port name      | Direction | Size, in bits                         | Domain | Sense       | Handling if unused      |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Description                                                                                                         |
-- +---------------------------------------------------------------------------------------------------------------------+
-- +---------------------------------------------------------------------------------------------------------------------+
-- | clka           | Input     | 1                                     |        | Rising edge | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Clock signal for port A. Also clocks port B when generic CLOCKING_MODE is 0.                                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | rsta           | Input     | 1                                     | clka   | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Reset signal for the final port A output register stage.                                                            |
-- | Synchronously resets output port douta to the value specified by generic READ_RESET_VALUE_A.                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | ena            | Input     | 1                                     | clka   | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Memory enable signal for port A.                                                                                    |
-- | Must be high on clock cycles when read or write operations are initiated. Pipelined internally.                     |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | regcea         | Input     | 1                                     | clka   | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Do not change from the provided value.                                                                              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | wea            | Input     | WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A | clka   | Active-high | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Write enable vector for port A input data port dina. 1 bit wide when word-wide writes are used.                     |
-- | In byte-wide write configurations, each bit controls the writing one byte of dina to address addra.                 |
-- | For example, to synchronously write only bits [15:8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be "0010".    |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | addra          | Input     | ADDR_WIDTH_A                          | clka   |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Address for port A write and read operations.                                                                       |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | dina           | Input     | WRITE_DATA_WIDTH_A                    | clka   |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Data input for port A write operations.                                                                             |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | douta          | Output   | READ_DATA_WIDTH_A                      | clka   |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Data output for port A read operations.                                                                             |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | clkb           | Input     | 1                                     |        | Rising edge | Tie to 1'b0             |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Clock signal for port B when generic CLOCKING_MODE is "independent_clock".                                          |
-- | Unused when generic CLOCKING_MODE is "common_clock".                                                                |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | rstb           | Input     | 1                                     | *      | Active-high | Tie to '0'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Reset signal for the final port B output register stage.                                                            |
-- | Synchronously resets output port doutb to the value specified by generic READ_RESET_VALUE_B.                        |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | enb            | Input     | 1                                     | *      | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Memory enable signal for port B.                                                                                    |
-- | Must be high on clock cycles when read or write operations are initiated. Pipelined internally.                     |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | regceb         | Input     | 1                                     | *      | Active-high | Tie to '1'              |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Do not change from the provided value.                                                                              |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | addrb          | Input     | ADDR_WIDTH_B                          | *      |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Address for port B write and read operations.                                                                       |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | doutb          | Output   | READ_DATA_WIDTH_B                      | *      |             | Required                |
-- |---------------------------------------------------------------------------------------------------------------------|
-- | Data output for port B read operations.                                                                             |
-- +---------------------------------------------------------------------------------------------------------------------+
-- | * clka when generic CLOCKING_MODE is "common_clock". clkb when generic CLOCKING_MODE is "independent_clock".        |
-- +---------------------------------------------------------------------------------------------------------------------+
--
-- Set generic values and connect ports to instantiate an XPM_MEMORY dual port distributed RAM configuration

--   xpm_memory_dpdistram: In order to incorporate this function into the design, the following instance declaration
--         VHDL          : needs to be placed in the architecture body of the design code.  The default values for the
--       instance        : generics may be changed to meet design requirements.  The instance name (xpm_memory_dpdistram_inst)
--      declaration      : and/or the port declarations after the "=>" declaration may be changed to properly reference
--         code          : and connect this function to the design.  All inputs and outputs must be connected.

--         Library      :
--       declaration    : In addition to adding the instance declaration, a use statement for the XPM.vcomponents
--           for        : library needs to be added before the entity declaration.  This library contains the
--         Xilinx       : component declarations for all Xilinx XPMs.
--          XPMs        :

--  Copy the following two statements and paste them before the Entity declaration, unless they already exist.

Library xpm;
use xpm.vcomponents.all;

-- <--Cut the following instance declaration and paste it into the architecture statement part of the design-->

-- xpm_memory_dpdistram: Dual Port Distributed RAM
-- Xilinx Parameterized Macro, Version 2017.4
xpm_memory_dpdistram_inst : xpm_memory_dpdistram
  generic map (

    -- Common module generics
    MEMORY_SIZE             => 1024,           --positive integer
    CLOCKING_MODE           => "common_clock", --string; "common_clock", "independent_clock" 
    MEMORY_INIT_FILE        => "none",         --string; "none" or "<filename>.mem" 
    MEMORY_INIT_PARAM       => "",             --string;
    USE_MEM_INIT            => 1,              --integer; 0,1
    MESSAGE_CONTROL         => 0,              --integer; 0,1
    USE_EMBEDDED_CONSTRAINT => 0,              --integer: 0,1
    MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

    -- Port A module generics
    WRITE_DATA_WIDTH_A      => 16,             --positive integer
    READ_DATA_WIDTH_A       => 16,             --positive integer
    BYTE_WRITE_WIDTH_A      => 16,             --integer; 8, 9, or WRITE_DATA_WIDTH_A value
    ADDR_WIDTH_A            => 10,              --positive integer
    READ_RESET_VALUE_A      => "0",            --string
    READ_LATENCY_A          => 2,              --non-negative integer

    -- Port B module generics
    READ_DATA_WIDTH_B       => 16,             --positive integer
    ADDR_WIDTH_B            => 6,              --positive integer
    READ_RESET_VALUE_B      => "0",            --string
    READ_LATENCY_B          => 2               --non-negative integer
  )
  port map (

    -- Port A module ports
    clka                    => clka,
    rsta                    => rsta,
    ena                     => ena,
    regcea                  => '1',   --do not change
    wea                     => wea,
    addra                   => addra,
    dina                    => dina,
    douta                   => douta,

    -- Port B module ports
    clkb                    => clkb,
    rstb                    => rstb,
    enb                     => enb,
    regceb                  => '1',   --do not change
    addrb                   => addrb,
    doutb                   => doutb
  );

-- End of xpm_memory_dpdistram_inst instance declaration

				
				