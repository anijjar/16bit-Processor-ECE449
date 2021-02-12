
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU_16 is
    port(
        -- master control inputs
        rst : in std_logic;
        clk : in std_logic;
        -- control input
        alu_mode : in std_logic_vector(2 downto 0);
        -- data inputs
        in1 : in std_logic_vector(2 downto 0);
        in2 : in std_logic_vector(2 downto 0);
        -- data output
        result : out std_logic_vector(2 downto 0);
        -- control output
        -- ov_flag : out std_logic;
        z_flag : out std_logic;
        n_flag : out std_logic -- no;
    );
end ALU_16;

architecture behavioural of ALU_16 is

    signal ;
begin 
    if (rst = '1') then
        -- not sure if output needs to be set to zero
        -- RF8_16 does not do this
        result <= (others => '0');
        z_flag <= '0';
        n_flag <= '0';
        -- set all internal values to default; zero
    else 
        case alu_mode(2 downto 0) is
            when "000" => -- NOP
                result <= (others => '0');
                z_flag <= '0';
                n_flag <= '0';
                -- set internal values to default?
            when "001" => -- ADD
                
            when "010" => -- SUB

            when "011" => -- MUL

            when "100" => -- NAND

            when "101" => -- SHL

            when "110" => -- SHR

            when "111" => -- TEST
                if (in1 = X"0000") then -- zero value
                    z_flag <= '1';
                    n_flag <= '0';
                elsif (in1(to_integer(unsigned(15))) = '0') then
                    z_flag <= '0';
                    n_flag <= '1';
                else 
                    z_flag <= '0';
                    n_flag <= '0';
                end if;
        end case;
    end if;

end behavioural ; -- behavioural