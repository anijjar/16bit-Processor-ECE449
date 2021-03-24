LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY DECODE_STAGE IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst     : in  std_logic;
      in_opcode  : in  std_logic_vector( 6 downto 0);
      in_ra      : in  std_logic_vector( 2 downto 0);
      in_rb      : in  std_logic_vector( 2 downto 0);
      in_rc      : in  std_logic_vector( 2 downto 0);
      in_RF1d    : in  std_logic_vector(N downto 0);
      in_RF2d    : in  std_logic_vector(N downto 0);
      out_RF1a    : out std_logic_vector( 2 downto 0);
      out_RF2a    : out std_logic_vector( 2 downto 0);
      out_RD1     : out std_logic_vector(N downto 0);
      out_RD2     : out std_logic_vector(N downto 0);
      out_alumode : out std_logic_vector( 2 downto 0);
      out_memwb   : out std_logic;
      out_regwb   : out std_logic;
      out_usr_flag : out std_logic;
      out_rdst    : out std_logic_vector( 2 downto 0);
      out_rb      : out  std_logic_vector( 2 downto 0);
      out_rc      : out  std_logic_vector( 2 downto 0)
      );        
END DECODE_STAGE;

ARCHITECTURE behavioural OF DECODE_STAGE IS


    signal altr2d   : std_logic_vector(N downto 0) := (others =>'0');
    signal altr2sel : std_logic := '0';
    signal input : std_logic_vector((N*2)+1 downto 0);
BEGIN
    decode_controller_0 : entity work.DECODE_CONTROLLER port map 
    (
        rst     => rst,
        opcode  => in_opcode,
        alumode => out_alumode,
        ra      => in_ra,
        rb      => in_rb,
        rc      => in_rc,
        rdst    => out_rdst,
        r1a     => out_RF1a,
        r2a     => out_RF2a,
        altd2   => altr2d,
        r2den   => altr2sel,
        regwb   => out_regwb,
        memwb   => out_memwb,
        usr_flag => out_usr_flag
    );
    out_rb <= in_rb;
    out_rc <= in_rc;
    
    -- S=0 selects RF2d, S=1 selects altr2d
       input <= altr2d(16) & in_RF2d(16) 
         & altr2d(15) & in_RF2d(15) 
         & altr2d(14) & in_RF2d(14) 
         & altr2d(13) & in_RF2d(13) 
         & altr2d(12) & in_RF2d(12) 
         & altr2d(11) & in_RF2d(11) 
         & altr2d(10) & in_RF2d(10) 
         & altr2d(9) & in_RF2d(9) 
         & altr2d(8) & in_RF2d(8) 
         & altr2d(7) & in_RF2d(7) 
         & altr2d(6) & in_RF2d(6) 
         & altr2d(5) & in_RF2d(5) 
         & altr2d(4) & in_RF2d(4) 
         & altr2d(3) & in_RF2d(3) 
         & altr2d(2) & in_RF2d(2) 
         & altr2d(1) & in_RF2d(1) 
         & altr2d(0) & altr2d(0);

    mux_d : entity work.MUX_ARRAY GENERIC MAP (num => 17) PORT MAP ( 
        data_in  => input,
        S        => altr2sel, 
        data_out => out_RD2 --alu input 2
    );

    out_RD1 <= in_RF1d;

END behavioural;