LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY EXECUTE_STAGE IS
    PORT (
        rst       : in  std_logic;
        usr_input : in  std_logic_vector(15 downto 0);
        usr_flag  : in  std_logic;
        RD1       : in  std_logic_vector(16 downto 0);
        RD2       : in  std_logic_vector(16 downto 0);
        alumode   : in  std_logic_vector( 2 downto 0);
        in_rdst   : in  std_logic_vector( 2 downto 0);
        in_memwb  : in  std_logic;
        in_regwb  : in  std_logic;
        
        in_rb_address     : in  std_logic_vector( 2 downto 0);
        in_rc_address     : in  std_logic_vector( 2 downto 0);
        in_exmem_forwarding_address : in  std_logic_vector( 2 downto 0);
        in_memwb_forwarding_address : in  std_logic_vector( 2 downto 0);
        in_exmem_forwarded_data : in std_logic_vector(16 downto 0);
        in_memwb_forwarded_data : in std_logic_vector(16 downto 0);
        
        out_memwb : out std_logic;
        out_regwb : out std_logic;
        out_rdst  : out std_logic_vector( 2 downto 0);
        AR        : out std_logic_vector(16 downto 0);
        z_flag    : out std_logic;
        n_flag    : out std_logic;
        out_usr_flag : out std_logic
        );        
END EXECUTE_STAGE;

ARCHITECTURE behavioural OF EXECUTE_STAGE IS

    signal input : std_logic_vector(33 downto 0);
    signal mux_out : std_logic_vector(16 downto 0);
    signal alu_out : std_logic_vector(16 downto 0);

    signal alu_RD2 : std_logic_vector(16 downto 0);
    signal alu_RD1 : std_logic_vector(16 downto 0);
    signal sel_RD1 : std_logic_vector(1 downto 0);
    signal sel_RD2 : std_logic_vector(1 downto 0);
BEGIN
    alu_16_0 :entity work.ALU port map 
    (
        rst      => rst,
        alu_mode => alumode,
        in1      => alu_RD1,
        in2      => alu_RD2,
        result   => alu_out,
        z_flag   => z_flag,
        n_flag   => n_flag
    );
    input <=  alu_out(16) & '0' 
            & alu_out(15) & usr_input(15) 
            & alu_out(14) & usr_input(14)
            & alu_out(13) & usr_input(13) 
            & alu_out(12) & usr_input(12) 
            & alu_out(11) & usr_input(11) 
            & alu_out(10) & usr_input(10) 
            & alu_out(9)  & usr_input(9) 
            & alu_out(8)  & usr_input(8) 
            & alu_out(7)  & usr_input(7) 
            & alu_out(6)  & usr_input(6) 
            & alu_out(5)  & usr_input(5) 
            & alu_out(4)  & usr_input(4) 
            & alu_out(3)  & usr_input(3) 
            & alu_out(2)  & usr_input(2) 
            & alu_out(1)  & usr_input(1) 
            & alu_out(0)  & usr_input(0);
    mux_d : entity work.MUX_ARRAY GENERIC MAP (num => 17) PORT MAP ( 
        data_in  => input,
        S        => usr_flag, 
        data_out => mux_out
    );
    
    
    -- pass input from idex latch through a 2:1 mux with the input of the ar result in the exmem latch. using a comparator circuit to select.
    MUX3_1_0 : entity work.MUX3_1_16 port map (
        SEL => sel_RD1,
        A => in_exmem_forwarded_data,
        B => in_memwb_forwarded_data,
        C => RD1,
        D => alu_RD1
    );
    MUX3_1_1 : entity work.MUX3_1_16 port map (
        SEL => sel_RD2,
        A => in_exmem_forwarded_data,
        B => in_memwb_forwarded_data,
        C => RD2,
        D => alu_RD2
    );

    sel_RD2 <= "00" when in_rc_address = in_exmem_forwarding_address else
               "01" when in_rc_address = in_memwb_forwarding_address else
               "10";
    sel_RD1 <= "00" when in_rb_address = in_exmem_forwarding_address else
               "01" when in_rb_address = in_memwb_forwarding_address else
               "10";

    AR <= mux_out; --change this
      
    out_memwb <= in_memwb;
    out_regwb <= in_regwb;
    out_rdst  <= in_rdst;
    out_usr_flag <= usr_flag;
END behavioural;