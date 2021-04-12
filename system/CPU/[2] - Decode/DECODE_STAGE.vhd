LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY DECODE_STAGE IS
    GENERIC (
        N : INTEGER := 16
    );
    PORT (
        rst : IN STD_LOGIC;
        in_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_data : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        in_RF1d : IN STD_LOGIC_VECTOR(N DOWNTO 0);
        in_RF2d : IN STD_LOGIC_VECTOR(N DOWNTO 0);
        in_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        in_pc : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        in_pc2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

        in_ex_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_ex_forwarding_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        in_ex_forwarded_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        in_ex_m1 : in std_logic;
        in_exmem_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_exmem_forwarding_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        in_exmem_forwarded_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        in_exmem_m1 : in std_logic;
        in_wb_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        in_wb_forwarding_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        in_wb_forwarded_data : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
        in_wb_m1 : in std_logic;

        out_RF1a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_RF2a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_RD1 : OUT STD_LOGIC_VECTOR(N DOWNTO 0);
        out_RD2 : OUT STD_LOGIC_VECTOR(N DOWNTO 0);
        out_alumode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_ra : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        out_brch_tkn : OUT STD_LOGIC;
        out_brch_adr : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        out_m1 : OUT STD_LOGIC
    );
END DECODE_STAGE;

ARCHITECTURE behavioural OF DECODE_STAGE IS
    SIGNAL altr2d : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL altr2sel : STD_LOGIC := '0';
    SIGNAL pc_17 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL inter_RD2 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL inter_RD2_16 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL adder_v : STD_LOGIC := '0';
    SIGNAL calc_adr_16 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL calc_adr : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL addend : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL addend_16 : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ifBr : STD_LOGIC := '0';
    SIGNAL ifReturn : STD_LOGIC := '0';
    SIGNAL brch_adr_17 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL r1_adr : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL r2_adr : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc2_17 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL sig_RD1 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL sig_RD2 : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');

    SIGNAL fwd_RF1d : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    --SIGNAL fwd_RF2d : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL sel_RD1 : STD_LOGIC := '0';
    SIGNAL sel_RD2 : STD_LOGIC := '0';
    SIGNAL if_brsub : STD_LOGIC := '0';
    SIGNAL disp : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
    SIGNAL rd2_out_final : STD_LOGIC_VECTOR(N DOWNTO 0) := (OTHERS => '0');
BEGIN
    -- async signal converstions
    pc_17 <= '0' & in_pc;
    pc2_17 <= '0' & in_pc2;
    out_RD2 <= rd2_out_final;--inter_RD2;
    calc_adr <= adder_v & calc_adr_16;
    inter_RD2_16 <= inter_RD2(N - 1 DOWNTO 0);
    addend_16 <= addend(N - 1 DOWNTO 0);--addend(N - 2 DOWNTO 0)&'0'; --added 2x here by left shifting by 1. changed N-1 to N-2
    -- sig_RD1 <= in_RF1d;
    -- sig_RD2 <= in_RF2d;
    --out_RD1 <= sig_RD1;
    out_RD1 <= in_RF1d;
    --out_RD2 <= fwd_RF2d;
    out_brch_adr <= brch_adr_17(N - 1 DOWNTO 0);
    out_RF1a <= r1_adr;
    out_RF2a <= r2_adr;

    decode_controller_0 : ENTITY work.DECODE_CONTROLLER PORT MAP (
        rst => rst,
        opcode => in_opcode,
        alumode => out_alumode,
        data => in_data,
        flags => in_flags,
        ra => out_ra,
        r1a => r1_adr,
        r2a => r2_adr,
        alt2d => altr2d,
        r2den => altr2sel,
        out_m1 => out_m1,
        brch_tkn => out_brch_tkn,
        ifBr => ifBr,
        ifReturn => ifReturn,
        pc2 => pc2_17,
        if_brsub => if_brsub,
        disp => disp
        );

    -- selects if data is taken from the reg or made from controller
    mux_rd2 : ENTITY work.MUX17_2x1 PORT MAP
        (
        SEL => altr2sel,
        A => in_RF2d,
        B => altr2d,
        C => inter_RD2
        );
    -- selects pc va
    mux_brsub : ENTITY work.MUX17_2x1 PORT MAP
        (
        SEL => if_brsub,
        A => inter_RD2, --normal op
        B => disp, -- pc2
        C => rd2_out_final
        );
    -- calculates the new branch address, taken or not
    branch_adder_0 : ENTITY work.ADD_SUB_16 PORT MAP
        (
        rst => rst,
        a => addend_16,
        b => inter_RD2_16,
        f => calc_adr_16,
        ci => '0',
        v => adder_v
        );

    -- selects between PC and R[a] for the first input of the BRR or BR instruction
    mux_addend : ENTITY work.MUX17_2x1 PORT MAP
        (
        SEL => ifBr,
        A => pc_17,
        B => fwd_RF1d, --in_RF2d, --fwd_RF2d,
        C => addend
        );

    -- selects the new pc value based on if it's a return call
    mux_return : ENTITY work.MUX17_2x1 PORT MAP
        (
        SEL => ifReturn,
        A => calc_adr,
        B => fwd_RF1d,--in_RF1d, --fwd_RF1d, this input needs to be the latest r7 value
        C => brch_adr_17
        );

    PROCESS (fwd_RF1d, in_RF1d, in_ex_forwarded_data, in_ex_forwarding_address, in_ex_opcode, in_exmem_opcode, in_exmem_forwarding_address, in_exmem_forwarded_data, in_wb_opcode, in_wb_forwarding_address, in_wb_forwarded_data, in_opcode, r1_adr, r2_adr)
    BEGIN
    -- for the BR instructions (changed from r2 to r1)
        IF((in_opcode = "1000011") OR (in_opcode = "1000100") OR (in_opcode = "1000101") OR (in_opcode = "1001001") OR (in_opcode = "1000110")) then
            if((in_ex_opcode /= "0010000" or in_ex_opcode /= "1000111") or 
            (in_exmem_opcode /= "0010000" or in_exmem_opcode /= "1000111") or 
            (in_wb_opcode /= "0010000" or in_wb_opcode /= "1000111")) then--dont do on load or return
                if(r1_adr = in_ex_forwarding_address) then
                    fwd_RF1d <= in_ex_forwarded_data;
                elsif(r1_adr = in_exmem_forwarding_address) then
                    fwd_RF1d <=  in_exmem_forwarded_data;
                elsif(r1_adr = in_wb_forwarding_address) then
                    fwd_RF1d <= in_wb_forwarded_data;
                else
                    fwd_RF1d <= in_RF1d;
                end if;
            else
                fwd_RF1d <= in_RF1d;
            end if;
    -- for the RETURN instruction
        elsif(in_opcode = "1000111") then
            -- if both ex and mem stages are load immediate. get both data and concate together to be fed into the PC
            -- dotn worry about case if there are two back to back upper/lowers. doesnt happen in project.
            if((in_ex_opcode = "0010010") and (in_exmem_opcode = "0010010")) then
                if(in_ex_m1 = '1') then
                    fwd_RF1d <= '0'&in_ex_forwarded_data(7 downto 0) & in_exmem_forwarded_data(7 downto 0);
                else
                    fwd_RF1d <= '0'&in_exmem_forwarded_data(7 downto 0) & in_ex_forwarded_data(7 downto 0);                    
                end if;
            -- otherwise if any other instruction is writing to register 7, use that result.
            elsif(in_ex_forwarding_address = "111") then
                fwd_RF1d <= in_ex_forwarded_data;
            elsif(in_exmem_forwarding_address = "111") then
                fwd_RF1d <= in_exmem_forwarded_data;
            elsif(in_wb_forwarding_address = "111") then 
                fwd_RF1d <= in_wb_forwarded_data;
            -- other otherwise, use register value
            else 
            fwd_RF1d <= in_RF1d; 
            end if;
        else
            fwd_RF1d <= in_RF1d;
        end if;
    END PROCESS;
    -- so the whole idea for forwarding is wrong. We were propagating a forwarded value when we should have been using it only the branching condition. we were also looking at the exmem stage only - rookie mistake. we need to look at each stage of the pipeline and see if the last 3 instructions were going to write a result into the target, r[a], register. 

    -- we need the result forwarded from all three stages for br

    -- for the return MUX, we need to check all three stages of the pipeline and either forward the latest r7 result, or reconstruct it from the loadimm instructions.

END behavioural;