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
        in_opcode : in std_logic_vector( 6 downto 0);
        
        in_rb_address     : in  std_logic_vector( 2 downto 0);
        in_rc_address     : in  std_logic_vector( 2 downto 0);
        in_exmem_opcode : in std_logic_vector( 6 downto 0);
        in_exmem_forwarding_address : in  std_logic_vector( 2 downto 0);
        in_exmem_forwarded_data : in std_logic_vector(16 downto 0);
        in_memwb_opcode : in std_logic_vector( 6 downto 0);
        in_memwb_forwarding_address : in  std_logic_vector( 2 downto 0);
        in_memwb_forwarded_data : in std_logic_vector(16 downto 0);

        passthru_flag : in std_logic;
        in_passthru_data : in std_logic_vector(16 downto 0);
        fwd_flag : in std_logic_vector(1 downto 0);
        
        AR        : out std_logic_vector(16 downto 0);
        out_z_flag    : out std_logic;
        out_n_flag    : out std_logic;
        out_v_flag    : out std_logic
        );        
END EXECUTE_STAGE;

ARCHITECTURE behavioural OF EXECUTE_STAGE IS

    signal mux_out : std_logic_vector(16 downto 0);
    signal alu_out : std_logic_vector(16 downto 0);

    signal alu_RD2 : std_logic_vector(16 downto 0);
    signal alu_RD1 : std_logic_vector(16 downto 0);
    signal sel_RD1 : std_logic_vector(1 downto 0);
    signal sel_RD2 : std_logic_vector(1 downto 0);

    signal user_input_17 : std_logic_vector(16 downto 0);
    signal ar_flag : std_logic_vector(1 downto 0);
    signal pass_or_rc : std_logic;
     signal pass_or_rc_in : std_logic_vector(16 downto 0);
BEGIN
    alu_16_0 :entity work.ALU_16 port map 
    (
        rst      => rst,
        alu_mode => alumode,
        in1      => alu_RD1,
        in2      => alu_RD2,
        result   => alu_out,
        z_flag   => out_z_flag,
        n_flag   => out_n_flag,
        v_flag   => out_v_flag
    );

    user_input_17 <= '0' & usr_input;
    ar_flag <= passthru_flag & usr_flag;
    mux17_3x1_ar : entity work.MUX3_1_16 port map 
    (
        SEL => ar_flag,
        A => alu_out,
        B => user_input_17,
        --C => in_passthru_data,
        C => pass_or_rc_in, -- for the mov instruction
        D => mux_out
    );    
    -- selects passthrough data or rc data
    MUX2_1_0 : entity work.MUX17_2x1 port map (
        SEL => pass_or_rc,
        A => in_passthru_data,
        B => alu_RD2,
        C => pass_or_rc_in
    );
    pass_or_rc <= '1' when (in_opcode = "0010011") else '0'; -- for mov instruction forwarding
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
    -- if there is a nop instruction before, dont forward.
    sel_RD2 <= "00" when ((in_rc_address = in_exmem_forwarding_address) 
                           and (fwd_flag(0) = '1') 
                           and (
                               (in_exmem_opcode /= "0000000") 
                               and (in_exmem_opcode /= "1000000") 
                               and (in_exmem_opcode /= "1000001") 
                               and (in_exmem_opcode /= "1000010") 
                               and (in_exmem_opcode /= "1001000")
                               and (in_exmem_opcode /= "1000011") -- br
                               and (in_exmem_opcode /= "1000100") 
                               and (in_exmem_opcode /= "1000101") 
                               and (in_exmem_opcode /= "1001001") 
                               --and (in_exmem_opcode /= "1000110") --brr.sub
                               )
                           )
                           else
               "01" when ((in_rc_address = in_memwb_forwarding_address)
                           and (fwd_flag(0) = '1') 
                           and (
                               (in_memwb_opcode /= "0000000") -- nop
                               and (in_memwb_opcode /= "1000000") --brr
                               and (in_memwb_opcode /= "1000001") --brr.n
                               and (in_memwb_opcode /= "1000010") --brr.z
                               and (in_memwb_opcode /= "1001000") -- brr.v
                               and (in_memwb_opcode /= "1000011") -- br
                               and (in_memwb_opcode /= "1000100") 
                               and (in_memwb_opcode /= "1000101") 
                               and (in_memwb_opcode /= "1001001") 
                               --and (in_memwb_opcode /= "1000110") --brr.sub
                               )
                           )
                           else
               "10";
    sel_RD1 <= "00" when ((in_rb_address = in_exmem_forwarding_address) 
                           and (fwd_flag(1) = '1') 
                           and (
                                (in_exmem_opcode /= "0000000") 
                                and (in_exmem_opcode /= "1000000") 
                                and (in_exmem_opcode /= "1000001") 
                                and (in_exmem_opcode /= "1000010") 
                                and (in_exmem_opcode /= "1001000") 
                                and (in_exmem_opcode /= "1000011") -- br
                                and (in_exmem_opcode /= "1000100") 
                                and (in_exmem_opcode /= "1000101") 
                                and (in_exmem_opcode /= "1001001") 
                                --and (in_exmem_opcode /= "1000110") --brr.sub (will need for return)
                                )
                           )
                           else
               "01" when ((in_rb_address = in_memwb_forwarding_address)
                           and (fwd_flag(1) = '1')
                           and ((in_memwb_opcode /= "0000000") 
                           and (in_memwb_opcode /= "1000000") 
                           and (in_memwb_opcode /= "1000001") 
                           and (in_memwb_opcode /= "1000010") 
                           and (in_memwb_opcode /= "1001000")
                           and (in_memwb_opcode /= "1000011") -- br
                           and (in_memwb_opcode /= "1000100") 
                           and (in_memwb_opcode /= "1000101") 
                           and (in_memwb_opcode /= "1001001") 
                           --and (in_memwb_opcode /= "1000110") --brr.sub
                            )
                           )
                           else
               "10";
    AR <= mux_out;


END behavioural;