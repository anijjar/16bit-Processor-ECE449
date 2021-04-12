
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; -- for shifts

entity DECODE_CONTROLLER is
    port(
        rst      : in  std_logic;
        -- opcode from the 16-bit instruction
        opcode   : in  std_logic_vector( 6 downto 0);
        -- determined ALU mode from opcode, only used for format A
        alumode  : out std_logic_vector( 2 downto 0);
        -- the rest of the 16-bit instruction
        data     : in  std_logic_vector( 8 downto 0);
        -- flags are received from the EXECUTE stage to determine
        -- if branch is taken or not
        -- flags are Z & N & V
        flags    : in  std_logic_vector( 2 downto 0);
        -- address of destination register, ie ra
        -- defaulted to 000 (R0)
        ra     : out std_logic_vector( 2 downto 0);
        -- address of first operand, ie rb
        -- defaulted to 000 (R0)
        r1a      : out std_logic_vector( 2 downto 0);
        -- address of second operand, ie rc
        -- defaulted to 000 (R0)
        r2a      : out std_logic_vector( 2 downto 0);
        -- alternative data, eq cl in shift insturctions
        -- default value is zeros
        alt2d    : out std_logic_vector(16 downto 0);
        -- enables alternative data for D2, eg cl in shifting intructions
        -- 0 is return from register file, 1 is alternative data
        r2den    : out std_logic;
        -- informs WRIEBACK stage if register writeback is required
        -- 0 is no, 1 is yes
        --regwb    : out std_logic;
        -- informs MEMORY stage if memory writeback is required
        -- 0 is no, 1 is yes
        --memwb    : out std_logic;
        -- Memory Read-back: 0 for no, 1 for yes
        --memrd    : out std_logic;
        --
        out_m1 : out std_logic;
        -- tells the CPU that there's user input
        -- forwarded to the execute stage
        -- 0 normal ALU output, 1 for user input
        ----usr_flag : out std_logic;
        -- sent to the fecth stage, communicates if the branch has been
        -- taken. 0 is pc+2, 1 is new PC.
        brch_tkn : out std_logic;
        -- on any BR instruction, selects input the new-PC adder
        -- 0 selects PC (BRR), 1 selects value at R[ra] (Br)
        -- to be added to specified displacement
        ifBr     : out std_logic;
        -- on a RETURN instruction, set high to select the value from RFD1
        -- to be used as the new PC
        ifReturn : out std_logic;
        -- flag to infrom the data forwarding if the address of the 
        -- operands are important, ie NOP neither address is 
        -- important but are set to a default value of 000
        -- but to prevent a confflcit from acutal use of R0
        -- this flag enables checks for data forwarding
        ----fwd_flag : out std_logic_vector(1 downto 0);
        -- pc+2
        pc2 : in std_logic_vector(16 downto 0);
        -- for picking pc+2 or passthru data generated in this function
        -- only used for Fomrat L
        -- default passthru data is zeros
        ----passthru_data : out std_logic_vector(16 downto 0);
        -- select 0 for passthru data, 1 for pc+2
       -- --passthru_flag : out std_logic
       if_Brsub     : out std_logic;
       disp    : out std_logic_vector(16 downto 0)
    );
end DECODE_CONTROLLER;

architecture behavioural of DECODE_CONTROLLER is
begin
    process(rst, opcode, data, flags, pc2)
    begin
    if (rst = '1') then
        alumode  <= "000";
        ra     <= "000";
        r1a      <= "000";
        r2a      <= "000";
        r2den    <= '0';
        alt2d    <= (others => '0');
        brch_tkn <= '0';
        ifBr     <= '0';
        ifReturn <= '0';
        out_m1 <= '0';
        if_brsub <= '0';
        disp <= (others => '0');
    else 
        case opcode(6 downto 0) is
            when "0000000" => 
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '0';      
                brch_tkn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                disp <= (others => '0');

            -- ADD
            when "0000001" => 
                alumode <= "001";
                ra     <= data(8 downto 6);
                r1a      <= data(5 downto 3);
                r2a      <= data(2 downto 0);
                r2den    <= '0';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                        if_brsub <= '0';
                disp <= (others => '0');

            -- SUB
            when "0000010" => 
                alumode <= "010";
                ra     <= data(8 downto 6);
                r1a      <= data(5 downto 3);
                r2a      <= data(2 downto 0);
                r2den    <= '0';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                disp <= (others => '0');
                

            -- MUL
            when "0000011" => 
                alumode <= "011";
                ra     <= data(8 downto 6);
                r1a      <= data(5 downto 3);
                r2a      <= data(2 downto 0);
                r2den    <= '0';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
if_brsub <= '0';
                                disp <= (others => '0');
                                
            -- NAND
            when "0000100" => 
                alumode <= "100";
                ra     <= data(8 downto 6);
                r1a      <= data(5 downto 3);
                r2a      <= data(2 downto 0);
                r2den    <= '0';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');

            -- SHL
            when "0000101" => 
                alumode <= "101";
                ra     <= data(8 downto 6);
                r1a      <= data(8 downto 6);
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <=  data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3 downto 0);
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
                
            -- SHR
            when "0000110" => 
                alumode <= "110";
                ra     <= data(8 downto 6);
                r1a      <= data(8 downto 6);
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <=  data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3) & data(3 downto 0);
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';

            -- TEST
            when "0000111" => 
                alumode <= "111";
                ra     <= data(8 downto 6);
                r1a      <= data(8 downto 6);
                r2a      <= "000"; 
                r2den    <= '1';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');

            -- OUT
            when "0100000" => 
                alumode <= "000";
                ra     <= data(8 downto 6);
                r1a      <= data(8 downto 6);
                r2a      <= "000"; 
                r2den    <= '1';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');

            -- IN
            when "0100001" => 
                alumode <= "000";
                ra     <= data(8 downto 6);
                r1a      <= data(8 downto 6);
                r2a      <= "000"; 
                r2den    <= '1';
                alt2d    <= (others => '0');
                brch_tkn <= '0';
                ifBr     <= '0';
                ifReturn <= '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');

            -- BRR
            when "1000000" => 
                brch_tkn <= '1';
                ifBr     <= '0';
                ifReturn <= '0';
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');

            -- BRR.N
            when "1000001" =>
                brch_tkn <= flags(1);
                ifBr     <= '0';
                ifReturn <= '0';
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BRR.Z
            when "1000010" => 
                brch_tkn <= flags(2);
                ifBr     <= '0';
                ifReturn <= '0';
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BRR.V
            when "1001000" => 
                brch_tkn <= flags(0); 
                ifBr     <= '0';
                ifReturn <= '0';
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8) & data(8 downto 0) & '0';  
                out_m1 <= '0';    
                if_brsub <= '0';
                                disp <= (others => '0');    
            
            -- BR
            when "1000011" =>
                brch_tkn <= '1';
                ra     <= data(8 downto 6);
                ifBr     <= '1';
                ifReturn <= '0';
                alumode  <= "000";
                r1a      <= data(8 downto 6);
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BR.N
            when "1000100" =>
                brch_tkn <= flags(1);
                ra     <= data(8 downto 6);
                ifBr     <= '1';
                ifReturn <= '0';
                alumode  <= "000";
                r1a      <= data(8 downto 6);
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BR.Z
            when "1000101" =>
                brch_tkn <= flags(2);
                ra     <= data(8 downto 6);
                ifBr     <= '1';
                ifReturn <= '0';
                alumode  <= "000";
                r1a      <= data(8 downto 6);
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BR.V
            when "1001001" =>
                brch_tkn <= flags(0);
                ra     <= data(8 downto 6);
                ifBr     <= '1';
                ifReturn <= '0';
                alumode  <= "000";
                r1a      <= data(8 downto 6);-- swapped r1a with r2a
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '0';
                                disp <= (others => '0');
            
            -- BR.SUB
            when "1000110" =>
                brch_tkn <= '1';
                ra     <= "111";
                ifBr     <= '1';
                ifReturn <= '0';
                alumode  <= "000";
                r1a      <= data(8 downto 6); --dest is handled in wb controller.
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5) & data(5 downto 0) & '0';
                out_m1 <= '0';
                if_brsub <= '1';
                disp <= pc2;
            
            -- RETURN
            when "1000111" =>
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "111";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '1';   
                brch_tkn <= '1';
                out_m1 <= '0';
                if_brsub <= '0';
                                                disp <= (others => '0');

            -- Load
            when "0010000" => 
                alumode <= "000";
                ra    <= data(8 downto 6);
                r1a     <= data(8 downto 6);
                r2a     <= data(5 downto 3);
                r2den   <= '0';
                alt2d   <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '0';   
                brch_tkn <= '0';
                out_m1 <= '0';if_brsub <= '0';
                                                                disp <= (others => '0');

            -- store
            when "0010001" => 
                alumode <= "000"; 
                ra    <= data(8 downto 6);
                r1a     <= data(8 downto 6);
                r2a     <= data(5 downto 3);
                r2den   <= '0';
                alt2d   <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '0';   
                brch_tkn <= '0'; 
                out_m1 <= '0';if_brsub <= '0';
                                                                disp <= (others => '0');

            -- loadimm
            when "0010010" => 
                alumode  <= "000"; 
                ra     <= "111"; -- changed from ra
                r1a      <= "000"; -- cahnged from 111
                r2a      <= "111";
                r2den    <= '1';
                alt2d    <= '0'& X"00" & data(7 downto 0);
                ifBr     <= '0';
                ifReturn <= '0';   
                brch_tkn <= '0';
                out_m1 <= data(8);if_brsub <= '0';
                                                                disp <= (others => '0');

            -- MOV
            when "0010011" => 
                alumode <= "000";
                ra    <= data(8 downto 6);
                r1a     <= data(8 downto 6);
                r2a     <= data(5 downto 3);
                r2den   <= '0';
                alt2d   <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '0';   
                brch_tkn <= '0';
                out_m1 <= '0';if_brsub <= '0';
                                                                disp <= (others => '0');
                
            -- not an ALU operation
            when others    => 
                alumode  <= "000";
                ra     <= "000";
                r1a      <= "000";
                r2a      <= "000";
                r2den    <= '1';
                alt2d    <= (others => '0'); 
                ifBr     <= '0';
                ifReturn <= '0';      
                brch_tkn <= '0';
                out_m1 <= '0';if_brsub <= '0';
                                                                disp <= (others => '0');

        end case;
        
    end if;
    end process;
end behavioural ; -- behavioural