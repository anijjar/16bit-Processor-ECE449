
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
    --write operation 
    PROCESS (clk)
    BEGIN
        IF (clk = '0' AND clk'event) THEN
            IF (rst = '1') THEN
                FOR i IN 0 TO 7 LOOP
                    reg_file(i) <= (OTHERS => '0');
                END LOOP;
            ELSIF (wr_enable = â€˜1') THEN
                CASE wr_index(2 DOWNTO 0) IS
                    WHEN "000" => reg_file(0) <= wr_data;
                        --fill this part
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    --read operation
    rd_data1 <=
        reg_file(0) WHEN(rd_index1 = "000") ELSE
        reg_file(1) WHEN(rd_index1 = "001") ELSE
        reg_file(2) WHEN(rd_index1 = "010") ELSE
        reg_file(3) WHEN(rd_index1 = "011") ELSE
        reg_file(4) WHEN(rd_index1 = "100") ELSE
        reg_file(5) WHEN(rd_index1 = "101") ELSE
        reg_file(6) WHEN(rd_index1 = "110") ELSE
        reg_file(7);

    rd_data2 <=
        --fill this part

    END behavioural;