library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;
use IEEE.std_logic_signed.all;

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
    SIGNAL ra : std_logic_vector(15 DOWNTO 0);
    SIGNAL rb : std_logic_vector(15 DOWNTO 0);
    SIGNAL rc : std_logic_vector(15 DOWNTO 0);
    SIGNAL cl : INTEGER;
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
                cl <= TO_INTEGER(UNSIGNED(in2)); -- this is some constant 
--                result <= ra SLL cl WHEN cl > 0;
            WHEN "110" => -- SHR
                ra <= in1; -- ra
                cl <= TO_INTEGER(UNSIGNED(in2)); -- this is some constant 
--                result <= ra SRL cl WHEN cl > 0;
            WHEN "111" => -- TEST
                ra <= in1;
                IF (TO_INTEGER(SIGNED(ra)) = 0) THEN
                    z_flag <= '1';
                ELSE
                    z_flag <= '0';
                END IF;
                IF (TO_INTEGER(SIGNED(ra)) < 0) THEN
                    n_flag <= '1';
                ELSE
                    n_flag <= '0';
                END IF;
            WHEN OTHERS => NULL;
        END CASE;
    END IF;
END PROCESS;
END behavioural ; -- behavioural