LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fc_to_IFID_TB IS
   --  Port ( );
END fc_to_IFID_TB;

ARCHITECTURE Behavioral OF fc_to_IFID_TB IS
signal clk            :  std_logic;
signal rst            :  std_logic;
signal in_rst_ld      :  std_logic;
signal in_rst_ex      :  std_logic;
signal fc_in_ram_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal fc_out_output : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal fc_out_ram_addrb : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal fc_out_ram_enb   : STD_LOGIC;
signal ifid_out_opcode : std_logic_vector( 6 downto 0);
signal ifid_out_ra     : std_logic_vector( 2 downto 0);
signal ifid_out_rb     : std_logic_vector( 2 downto 0);
signal ifid_out_rc     : std_logic_vector( 2 downto 0);

BEGIN
Fetch : ENTITY work.FETCH_CONTROLLER port map (
   clk => clk,
   rst_ex => in_rst_ex,
   rst_ld  => in_rst_ld,
   out_output  => fc_out_output,
   in_ram_data  => fc_in_ram_data,
   out_ram_addrb => fc_out_ram_addrb, 
   out_ram_enb   => fc_out_ram_enb 
);


IFID : ENTITY work.IFID_LATCH port map (
   rst        => rst,
   clk        => clk,
   input      => fc_out_output,
   out_opcode => ifid_out_opcode,
   out_ra     => ifid_out_ra,
   out_rb     => ifid_out_rb,
   out_rc     => ifid_out_rc
);
   clock : PROCESS
   BEGIN
      CLK <= '1';
      WAIT FOR 10 us;
      CLK <= '0';
      WAIT FOR 10 us;
   END PROCESS;

   SYSTEM_TESTS : PROCESS
   BEGIN
      in_rst_ex <= '0';
      in_rst_ld <= '0';
      fc_in_ram_data <= X"AFF1";
      WAIT UNTIL (CLK = '0' AND CLK'event);
      WAIT UNTIL (CLK = '1' AND CLK'event);
      in_rst_ex <= '1';
      WAIT UNTIL (CLK = '1' AND CLK'event); 
      in_rst_ex <= '0';
      WAIT UNTIL (CLK = '1' AND CLK'event); 

      WAIT;
   END PROCESS;
END Behavioral;