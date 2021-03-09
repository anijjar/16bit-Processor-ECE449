library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LBS_16_TB is
--  Port ( );
end LBS_16_TB;

architecture Behavioral of LBS_16_TB is
    -- RBS signals
    SIGNAL LBS_16_D_IN, LBS_16_D_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL LBS_16_SHIFT : STD_LOGIC_VECTOR (3 DOWNTO 0);
begin

    LBS_16: entity work.LBS_16 PORT MAP(LBS_16_D_IN, LBS_16_SHIFT, LBS_16_D_OUT);
    LBS_16_tests : process 
    constant period: time := 20 ns;
    begin
    -- '1' case
        LBS_16_D_IN <= X"0001";
        LBS_16_SHIFT <= X"1";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for LBS_16_D_IN = 0x0001" severity error;
    -- 'F' case
      LBS_16_D_IN <= X"000F";
        RBS_16_SHIFT <= X"2";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000011")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for LBS_16_D_IN = 0x000F" severity error;
    -- 'F00F' case
      LBS_16_D_IN <= X"F00F";
        RBS_16_SHIFT <= X"8";
        wait for period;
        assert (RBS_16_D_OUT = "0000000011110000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for LBS_16_D_IN = 0xF00F" severity error;
    -- 'FFFF' case
         LBS_16_D_IN <= X"FFFF";
        RBS_16_SHIFT <= X"F";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for LBS_16_D_IN = 0xFFFF" severity error;
    wait;
    end process;


end Behavioral;
