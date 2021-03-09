-- will contain the RAM module, the controllers, and ROM module b/c two controllers will have 2 instances of the RAM module.

ENTITY System IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      clk : IN STD_LOGIC;
      rst_ex : IN STD_LOGIC;
      rst_ld   : IN STD_LOGIC;
      input : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
   );        
END System;

ARCHITECTURE behav OF MASTER_CONTROLLER IS
   -- RAM units
   SIGNAL RAM_rst_a	: std_logic <= '0';	
   SIGNAL RAM_rst_b	: std_logic <= '0';	
   SIGNAL RAM_en_a	: std_logic <= '0';
   SIGNAL RAM_en_b	: std_logic <= '0';
   SIGNAL RAM_wen_a	: std_logic_vector(0 downto 0); 
   SIGNAL RAM_addy_a	: std_logic_vector(N-1 downto 0); 
   SIGNAL RAM_addy_b	: std_logic_vector(N-1 downto 0);
   SIGNAL RAM_din_a	: std_logic_vector(N-1 downto 0); 
   SIGNAL RAM_dout_a : std_logic_vector(N-1 downto 0);
   SIGNAL RAM_dout_b : std_logic_vector(N-1 downto 0);

   -- ROM units
   SIGNAL ROM_Clock  :  STD_LOGIC;
   SIGNAL ROM_Reset  :  STD_LOGIC;
   SIGNAL ROM_Enable :  STD_LOGIC;
   SIGNAL ROM_Read   :  STD_LOGIC;
   SIGNAL ROM_Address  : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   SIGNAL ROM_Data_out : STD_LOGIC_VECTOR(N-1 DOWNTO 0)

   -- Fetch controller
   SIGNAL FETCH_CONTROLLER_clk : IN STD_LOGIC;
   SIGNAL FETCH_CONTROLLER_input_address : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      --Latch
   SIGNAL FETCH_CONTROLLER_opcode :  std_logic_vector(6 downto 0); 
   SIGNAL FETCH_CONTROLLER_ra :  std_logic_vector(2 downto 0);
   SIGNAL FETCH_CONTROLLER_rb :  std_logic_vector(2 downto 0);
   SIGNAL FETCH_CONTROLLER_rc :  std_logic_vector(2 downto 0);
   SIGNAL FETCH_CONTROLLER_imm :  std_logic_vector(N-1 downto 0);
      --RAM
   SIGNAL FETCH_CONTROLLER_Reset_a	:  std_logic;
   SIGNAL FETCH_CONTROLLER_Reset_b	:  std_logic;
   SIGNAL FETCH_CONTROLLER_Enable_a	:  std_logic;
   SIGNAL FETCH_CONTROLLER_Enable_b	:  std_logic;
   SIGNAL FETCH_CONTROLLER_Write_en_a	:  std_logic_vector(0 downto 0);
   SIGNAL FETCH_CONTROLLER_Address_a	:  std_logic_vector(N-1 downto 0);
   SIGNAL FETCH_CONTROLLER_Address_b	:  std_logic_vector(N-1 downto 0);
   SIGNAL FETCH_CONTROLLER_data_in_a	:  std_logic_vector(N-1 downto 0);
   SIGNAL FETCH_CONTROLLER_Data_out_a : std_logic_vector(N-1 downto 0);
   SIGNAL FETCH_CONTROLLER_Data_out_b : std_logic_vector(N-1 downto 0);

   -- Decode controller
   SIGNAL DECODE_CONTROLLER_
   SIGNAL DECODE_CONTROLLER_
   SIGNAL DECODE_CONTROLLER_
   SIGNAL DECODE_CONTROLLER_
   SIGNAL DECODE_CONTROLLER_
   -- Execute Controller
   -- Mem controller
   -- WB controller

BEGIN

   RAM : ENTITY work.RAM PORT MAP(Clock => clk, Reset_a => RAM_rst_a, Reset_b => RAM_rst_b, Enable_a => RAM_en_a, Enable_b => RAM_en_b, Write_en_a => RAM_wen_a, Address_b => RAM_addy_a, Address_b => RAM_addy_b, data_in_a	=> RAM_din_a, Data_out_a => RAM_dout_a, Data_out_b => RAM_dout_b); 

   ROM : ENTITY work.ROM PORT MAP(Clock => ROM_Clock, Reset => ROM_Reset, Enable => ROM_Enable, Read => ROM_Read, Address => ROM_Address, Data_out => ROM_Data_out);

   FETCH_CONTROLLER : ENTITY work.F_controller PORT MAP(clk => FETCH_CONTROLLER_clk, input_address => FETCH_CONTROLLER_input_address, opcode => FETCH_CONTROLLER_opcode, ra => FETCH_CONTROLLER_ra, rb => FETCH_CONTROLLER_rb, rc => FETCH_CONTROLLER_rc, imm => FETCH_CONTROLLER_imm, Reset_a => FETCH_CONTROLLER_Reset_a, Reset_b => FETCH_CONTROLLER_Reset_b, Enable_a	=> FETCH_CONTROLLER_Enable_a, Enable_b	=> FETCH_CONTROLLER_Enable_b, Write_en_a => FETCH_CONTROLLER_Write_en_a, Address_a => FETCH_CONTROLLER_Address_a, Address_b => FETCH_CONTROLLER_Address_b, data_in_a => FETCH_CONTROLLER_data_in_a, Data_out_a => FETCH_CONTROLLER_Data_out_a, Data_out_b => FETCH_CONTROLLER_Data_out_b);



   -- folow state machine implementation as the slides suggest
   PROCESS (clk, rst_ex, rst_ld, input)
      CONSTANT RST_LD_ADDRESS : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0002";
      CONSTANT RST_EX_ADDRESS : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0000";  
   BEGIN
      IF (falling_edge(clk)) THEN
         IF (rst_ex = '1') THEN
            PC_input <= RST_EX_ADDRESS;
         ELSIF (rst_ld = '1') THEN
            PC_input <= RST_LD_ADDRESS;
         END IF
      -- if pc_input is start address then go
      END IF

      -- wire ram to fetch controller

      -- wire ram to mem controller

   END PROCESS

END behav;