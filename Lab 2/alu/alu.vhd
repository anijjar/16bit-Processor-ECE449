
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY register_file IS
PORT (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    --read signals
    rd_index1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    rd_index2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    rd_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rd_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    --write signals
    wr_index : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_enable : IN STD_LOGIC);
END register_file;

ARCHITECTURE behavioural OF register_file IS

TYPE reg_array IS ARRAY (INTEGER RANGE 0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
--internals signals
SIGNAL reg_file : reg_array;
BEGIN


case alu_mode(2 downto 0) is
    when "101" => -- SHL

    when "110" => -- SHR  
end case
END behavioural;