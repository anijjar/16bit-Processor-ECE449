
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FETCH_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk : IN STD_LOGIC;
      input_address : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);

      --output latches
      opcode : OUT std_logic_vector(6 downto 0); 
      ra : OUT std_logic_vector(2 downto 0);
      rb : OUT std_logic_vector(2 downto 0);
      rc : OUT std_logic_vector(2 downto 0);
      imm : OUT std_logic_vector(N-1 downto 0);
	  NPC : out std_logic_vector(15 downto 0);
	  
      -- outgoing for RAM
      Reset_a	: out std_logic;	
      Reset_b	: out std_logic;	
      Enable_a	: out std_logic;
      Enable_b	: out std_logic;
      Write_en_a	: out std_logic_vector(0 downto 0); 
      Address_a	: out std_logic_vector(N-1 downto 0);
      Address_b	: out std_logic_vector(N-1 downto 0);
      data_in_a	: out std_logic_vector(N-1 downto 0); 

      -- incoming for RAM
      Data_out_a: in std_logic_vector(N-1 downto 0);
      Data_out_b: in std_logic_vector(N-1 downto 0)
   );        
END FETCH_CONTROLLER;

ARCHITECTURE behav OF FETCH_CONTROLLER IS

   SIGNAL PC_input : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
   SIGNAL PC_output : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
   SIGNAL PC_rst : STD_LOGIC <= '0';

   SIGNAL Increment_output : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');

   SIGNAL IR_output : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
   SIGNAL IR_rst : STD_LOGIC <= '0';

   SIGNAL NPC_output : STD_LOGIC_VECTOR(N-1 DOWNTO 0) <= (OTHERS => '0');
   SIGNAL NPC_rst : STD_LOGIC <= '0';

   SIGNAL IFID_rst : std_logic <= '0';
   SIGNAL IFID_in_instruction : std_logic_vector( 15 downto 0);
   SIGNAL IFID_in_NPC : std_logic_vector(15 downto 0);

   SIGNAL IFID_out_opcode : std_logic_vector(6 downto 0); 
   SIGNAL IFID_out_ra : std_logic_vector(2 downto 0);
   SIGNAL IFID_out_rb : std_logic_vector(2 downto 0);
   SIGNAL IFID_out_rc : std_logic_vector(2 downto 0);
   SIGNAL IFID_out_imm : std_logic_vector(N-1 downto 0);

BEGIN

   PC : ENTITY work.PC PORT MAP(clk => clk, rst => PC_rst, input => PC_input, output => PC_output);
   
   Increment : ENTITY work.Increment PORT MAP(input => PC_output, output => Increment_output);

   NPC : ENTITY work.NPC PORT MAP(clk => clk, rst => NPC_rst, input => Increment_output, output => NPC_output);
   
   IR : ENTITY work.IR PORT MAP(clk => clk, rst => IR_rst, input => Data_out_b, output => IR_output); -- port b of ram always mapped to input of Instruction Reg

   IFID_LATCH : ENTITY.IFID PORT MAP(
   rst => IFID_rst, 
   clk => clk, 
   in_instruction => IFID_in_instruction,
   in_NPC => IFID_in_NPC,
   out_opcode => IFID_out_opcode, 
   out_ra => IFID_out_ra, 
   out_rb => IFID_out_rb, 
   out_rc => IFID_out_rc, 
   out_imm => IFID_out_imm
   )
   
   -- map ports to signals
   input_address <= PC_output;
   


END behav;