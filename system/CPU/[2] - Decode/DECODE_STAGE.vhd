LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY DECODE_STAGE IS
   GENERIC (
      N : INTEGER := 16
   );
   PORT (
      rst          : in  std_logic;
      in_opcode    : in  std_logic_vector(6 downto 0);
      in_data      : in  std_logic_vector(8 downto 0);
      in_RF1d      : in  std_logic_vector(N downto 0);
      in_RF2d      : in  std_logic_vector(N downto 0);
      in_flags     : in  std_logic_vector(2 downto 0);
      in_pc        : in  std_logic_vector(N-1 downto 0);
      in_pc2       : in  std_logic_vector(N-1 downto 0);
      in_exmem_opcode : in std_logic_vector( 6 downto 0);
      in_exmem_forwarding_address : in  std_logic_vector( 2 downto 0);
      in_exmem_forwarded_data : in std_logic_vector(16 downto 0);
      in_exmem_forwarding_fwd_flag : in std_logic_vector(1 downto 0);
      out_RF1a     : out std_logic_vector(2 downto 0);
      out_RF2a     : out std_logic_vector(2 downto 0);
      out_RD1      : out std_logic_vector(N downto 0);
      out_RD2      : out std_logic_vector(N downto 0);
      out_alumode  : out std_logic_vector(2 downto 0);
      out_memwb    : out std_logic;
      out_memrd    : out std_logic;
      out_regwb    : out std_logic;
      out_usr_flag : out std_logic;
      out_rdst     : out std_logic_vector(2 downto 0);
      out_brch_tkn : out std_logic;
      out_brch_adr : out std_logic_vector(N-1 downto 0);
      out_passthru : out std_logic_vector(N downto 0);
      out_fwd_flag : out std_logic_vector(1 downto 0);
      out_passthru_flag : out std_logic;
      out_m1       : out std_logic
    );        
END DECODE_STAGE;

ARCHITECTURE behavioural OF DECODE_STAGE IS
    signal altr2d       : std_logic_vector(  N downto 0) := (others =>'0');
    signal altr2sel     : std_logic := '0';
    signal pc_17        : std_logic_vector(  N downto 0) := (others => '0');
    signal inter_RD2    : std_logic_vector(  N downto 0) := (others => '0');
    signal inter_RD2_16 : std_logic_vector(N-1 downto 0) := (others => '0');
    signal adder_v      : std_logic := '0';
    signal calc_adr_16  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal calc_adr     : std_logic_vector(  N downto 0) := (others => '0');
    signal addend       : std_logic_vector(  N downto 0) := (others => '0');
    signal addend_16    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal ifBr         : std_logic := '0';
    signal ifReturn     : std_logic := '0';
    signal brch_adr_17  : std_logic_vector(  N downto 0) := (others => '0');
    signal r1_adr       : std_logic_vector(  2 downto 0) := (others => '0');
    signal r2_adr       : std_logic_vector(  2 downto 0) := (others => '0');
    signal pc2_17       : std_logic_vector(  N downto 0):= (others => '0');
    signal sig_RD1      : std_logic_vector(  N downto 0):= (others => '0');
    signal sig_RD2      : std_logic_vector(  N downto 0):= (others => '0');
    
    signal forward_output_RD1: std_logic_vector(  N downto 0):= (others => '0');
    signal forward_output_RD2: std_logic_vector(  N downto 0):= (others => '0');
    signal sel_RD1 : std_logic:= '0';
    signal sel_RD2 : std_logic:= '0';

BEGIN
    -- async signal converstions
    pc_17  <= '0'&in_pc;
    pc2_17 <= '0'&in_pc2;
    out_RD2 <= inter_RD2;
    calc_adr <= adder_v&calc_adr_16;
    inter_RD2_16 <= inter_RD2(N-1 downto 0);
    addend_16 <= addend(N-1 downto 0);
    sig_RD1 <= in_RF1d;
    sig_RD2 <= in_RF2d;
    --out_RD1 <= sig_RD1;
    out_RD1 <= forward_output_RD1;
    --out_RD2 <= forward_output_RD2;
    out_brch_adr <= brch_adr_17(N-1 downto 0);
    out_RF1a <= r1_adr;
    out_RF2a <= r2_adr;

    decode_controller_0 : entity work.DECODE_CONTROLLER port map 
    (
        rst      => rst,
        opcode   => in_opcode,
        alumode  => out_alumode,
        data     => in_data,
        flags    => in_flags,
        rdst     => out_rdst,
        r1a      => r1_adr,
        r2a      => r2_adr,
        altd2    => altr2d,
        r2den    => altr2sel,
        regwb    => out_regwb,
        memwb    => out_memwb,
        memrd    => out_memrd,
        out_m1   => out_m1,
        usr_flag => out_usr_flag,
        brch_tkn => out_brch_tkn,
        ifBr     => ifBr,
        ifReturn => ifReturn,
        fwd_flag => out_fwd_flag,
        pc2      => pc2_17,
        passthru_data => out_passthru,
        passthru_flag => out_passthru_flag
    );

    -- selects if data is taken from the reg or made from controller
    mux_rd2 : entity work.MUX17_2x1 port map 
    (
        SEL => altr2sel,
        A   => forward_output_RD2,
        B   => altr2d,
        C   => inter_RD2
    );

    -- calculates the new branch address, taken or not

    branch_adder_0 : entity work.ADD_SUB_16 port map 
    (
        rst => rst,
        a   => addend_16,
        b   => inter_RD2_16,
        f   => calc_adr_16,
        ci  => '0',
        v   => adder_v
    );

    -- selects between disp and R[a] to be added to pc
    mux_addend : entity work.MUX17_2x1 port map 
    (
        SEL => ifBr,
        A   => pc_17,
        B   => forward_output_RD2,
        C   => addend
    );
    
    -- selects the new pc value baseed on if it's a return call
    mux_return : entity work.MUX17_2x1 port map 
    (
        SEL => ifReturn,
        A   => calc_adr,
        B   => forward_output_RD1,
        C   => brch_adr_17
    );   
     
    -- if r1_adr = in_exmem_forwarding_address? in_exmem_forwarded_data : sig_RD1
    mux_forwarding_1 : entity work.MUX17_2x1 port map (
        SEL => sel_RD1,
        A => in_exmem_forwarded_data,
        B => sig_RD1,
        C => forward_output_RD1
    );
    
    sel_RD1 <= '0' when ((r1_adr = in_exmem_forwarding_address)
                         and ((in_exmem_opcode /= "0000000") 
                              and (in_exmem_opcode /= "1000000") 
                              and (in_exmem_opcode /= "1000001") 
                              and (in_exmem_opcode /= "1000010") 
                              and (in_exmem_opcode /= "1001000")
                              and (in_exmem_opcode /= "1000011") -- br
                              and (in_exmem_opcode /= "1000100") 
                              and (in_exmem_opcode /= "1000101") 
                              and (in_exmem_opcode /= "1001001")
                              )
                          ) 
               else '1';
  mux_forwarding_2 : entity work.MUX17_2x1 port map (
       SEL => sel_RD2,
       A => in_exmem_forwarded_data,
       B => sig_RD2,
       C => forward_output_RD2
   );
    sel_RD2 <= '0' when ((r2_adr = in_exmem_forwarding_address)
                                    and ((in_exmem_opcode /= "0000000") 
                                         and (in_exmem_opcode /= "1000000") 
                                         and (in_exmem_opcode /= "1000001") 
                                         and (in_exmem_opcode /= "1000010") 
                                         and (in_exmem_opcode /= "1001000")
                                         and (in_exmem_opcode /= "1000011") -- br
                                         and (in_exmem_opcode /= "1000100") 
                                         and (in_exmem_opcode /= "1000101") 
                                         and (in_exmem_opcode /= "1001001")
                                         )
                                     ) 
                          else '1';
--    in_exmem_opcode : in std_logic_vector( 6 downto 0);
--    in_exmem_forwarding_address : in  std_logic_vector( 2 downto 0);
--    in_exmem_forwarded_data : in std_logic_vector(16 downto 0);
--    in_exmem_forwarding_fwd_flag : in std_logic_vector(1 downto 0);
END behavioural;