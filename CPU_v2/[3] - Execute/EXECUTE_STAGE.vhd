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
        AR        : out std_logic_vector(16 downto 0);
        z_flag    : out std_logic;
        n_flag    : out std_logic;
        in_memwb  : in  std_logic;
        out_memwb : out std_logic;
        in_regwb  : in  std_logic;
        out_regwb : out std_logic;
        in_rdst   : in  std_logic_vector( 2 downto 0);
        out_rdst  : out std_logic_vector( 2 downto 0)
        );        
END EXECUTE_STAGE;

ARCHITECTURE behavioural OF EXECUTE_STAGE IS

    component ALU_16 is port 
    (
        rst      : in  std_logic;
        alu_mode : in  std_logic_vector( 2 downto 0);
        in1      : in  std_logic_vector(16 downto 0);
        in2      : in  std_logic_vector(16 downto 0);
        result   : out std_logic_vector(16 downto 0);
        z_flag   : out std_logic;
        n_flag   : out std_logic
    );
    end component ALU_16;
    signal input : std_logic_vector(33 downto 0);
    signal mux_out : std_logic_vector(16 downto 0);
    signal alu_out : std_logic_vector(16 downto 0);
BEGIN
    alu_16_0 : ALU_16 port map 
    (
        rst      => rst,
        alu_mode => alumode,
        in1      => RD1,
        in2      => RD2,
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
    AR <= mux_out;
    out_memwb <= in_memwb;
    out_regwb <= in_regwb;
    out_rdst  <= in_rdst;

END behavioural;