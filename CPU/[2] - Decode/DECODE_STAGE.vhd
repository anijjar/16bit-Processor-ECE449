LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY DECODE_STAGE IS
    PORT (
        rst     : in  std_logic;
        opcode  : in  std_logic_vector( 6 downto 0);
        ra      : in  std_logic_vector( 2 downto 0);
        rb      : in  std_logic_vector( 2 downto 0);
        rc      : in  std_logic_vector( 2 downto 0);
        RF1d    : in  std_logic_vector(16 downto 0);
        RF2d    : in  std_logic_vector(16 downto 0);
        RF1a    : out std_logic_vector( 2 downto 0);
        RF2a    : out std_logic_vector( 2 downto 0);
        RD1     : out std_logic_vector(16 downto 0);
        RD2     : out std_logic_vector(16 downto 0);
        alumode : out std_logic_vector( 2 downto 0);
        memwb   : out std_logic;
        regwb   : out std_logic;
        usr_flag : out std_logic;
        rdst    : out std_logic_vector( 2 downto 0)
        );        
END DECODE_STAGE;

ARCHITECTURE behavioural OF DECODE_STAGE IS

    component DECODE_CONTROLLER is port 
    (
        rst     : in  std_logic;
        opcode  : in  std_logic_vector( 6 downto 0);
        alumode : out std_logic_vector( 2 downto 0);
        ra      : in  std_logic_vector( 2 downto 0);
        rb      : in  std_logic_vector( 2 downto 0);
        rc      : in  std_logic_vector( 2 downto 0);
        rdst    : out std_logic_vector( 2 downto 0);
        r1a     : out std_logic_vector( 2 downto 0);
        r2a     : out std_logic_vector( 2 downto 0);
        altd2   : out std_logic_vector(16 downto 0);
        r2den   : out std_logic;
        regwb   : out std_logic;
        memwb   : out std_logic;
        usr_flag : out std_logic
    );
    end component DECODE_CONTROLLER;

    signal altr2d   : std_logic_vector(16 downto 0) := (others =>'0');
    signal altr2sel : std_logic := '0';
    signal input : std_logic_vector(33 downto 0);
BEGIN
    decode_controller_0 : DECODE_CONTROLLER port map 
    (
        rst     => rst,
        opcode  => opcode,
        alumode => alumode,
        ra      => ra,
        rb      => rb,
        rc      => rc,
        rdst    => rdst,
        r1a     => RF1a,
        r2a     => RF2a,
        altd2   => altr2d,
        r2den   => altr2sel,
        regwb   => regwb,
        memwb   => memwb,
        usr_flag => usr_flag
    );

    -- S=0 selects RF2d, S=1 selects altr2d
    -- plz verify becasue this unit is so confusing
    input <= altr2d(16) & RF2d(16) & altr2d(15) & RF2d(15) & altr2d(14) & RF2d(14) & altr2d(13) & RF2d(13) & altr2d(12) & RF2d(12) & altr2d(11) & RF2d(11) & altr2d(10) & RF2d(10) & altr2d(9) & RF2d(9) & altr2d(8) & RF2d(8) & altr2d(7) & RF2d(7) & altr2d(6) & RF2d(6) & altr2d(5) & RF2d(5) & altr2d(4) & RF2d(4) & altr2d(3) & RF2d(3) & altr2d(2) & RF2d(2) & altr2d(1) & RF2d(1) & altr2d(0) & altr2d(0) ;
    mux_d : entity work.MUX_ARRAY GENERIC MAP (num => 17) PORT MAP
    ( 
        data_in  => input,
        S        => altr2sel, 
        data_out => RD2
    );

    RD1 <= RF1d;

END behavioural;