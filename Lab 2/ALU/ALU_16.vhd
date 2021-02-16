
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ALU_16 IS
    PORT(
        -- master control inputs
        rst : IN std_logic;
        clk : IN std_logic;
        -- control INput
        alu_mode : IN std_logic_vector(2 DOWNTO 0);
        -- data INputs
        IN1 : IN std_logic_vector(15 DOWNTO 0);
        IN2 : IN std_logic_vector(15 DOWNTO 0);
        -- data output
        result : out std_logic_vector(15 DOWNTO 0);
        -- control output
        -- ov_flag : out std_logic;
        z_flag : out std_logic;
        n_flag : out std_logic);
END ALU_16;

ARCHITECTURE behavioural OF ALU_16 IS
    SIGNAL ra : std_logic_vector(2 DOWNTO 0);
    SIGNAL rb : std_logic_vector(2 DOWNTO 0);
    SIGNAL rc : std_logic_vector(2 DOWNTO 0);
    SIGNAL cl : std_logic_vector(3 DOWNTO 0);
BEGIN 
PROCESS(rst, alu_mode, in1, in2)
BEGIN
    IF (rst = '1') THEN
        -- not sure if output needs to be set to zero
        -- RF8_16 does not do this
        result <= (others => '0');
        z_flag <= '0';
        n_flag <= '0';
        -- set all internal values to default; zero
    ELSE 
        CASE alu_mode(2 DOWNTO 0) IS
            WHEN "000" => -- NOP
                result <= (others => '0');
                z_flag <= '0';
                n_flag <= '0';
                -- set internal values to default?
            WHEN "001" => -- ADD
                
            WHEN "010" => -- SUB

            WHEN "011" => -- MUL

            WHEN "100" => -- NAND
                result <= in1 NAND in2;
            WHEN "101" => -- SHL
                ra <= in1; -- ra
                cl <= in2(3 DOWNTO 0); -- this is some constant 
                result <= shift_left(in1, cl) WHEN cl > B"0000";
            WHEN "110" => -- SHR
                ra <= in1 -- ra
                cl <= in2(3 DOWNTO 0) -- this is some constant 
                result <= shift_right(in1, cl) WHEN cl > B"0000";
            WHEN "111" => -- TEST
                IF (in1 = X"0000") THEN -- zero value
                    z_flag <= '1';
                    n_flag <= '0';
                ELSIF (in1(to_integer(unsigned(15))) = '0') THEN
                    z_flag <= '0';
                    n_flag <= '1';
                ELSE
                    z_flag <= '0';
                    n_flag <= '0';
                END IF;
            WHEN OTHERS => NULL;
        END CASE;
    END IF;
END PROCESS;
END behavioural ; -- behavioural