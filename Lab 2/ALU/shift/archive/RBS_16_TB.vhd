library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RBS_16_TB is
--  Port ( );
end RBS_16_TB;

architecture Behavioral of RBS_16_TB is
    -- RBS signals
    SIGNAL RBS_16_D_IN, RBS_16_D_OUT : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL RBS_16_SHIFT : STD_LOGIC_VECTOR (3 DOWNTO 0);
begin

    RBS_16: entity work.RBS_16 PORT MAP(RBS_16_D_IN, RBS_16_SHIFT, RBS_16_D_OUT);
    RBS_16_tests : process 
    constant period: time := 20 ns;
    begin
    -- '1' case
        RBS_16_D_IN <= X"0001";
        RBS_16_SHIFT <= X"1";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for RBS_16_D_IN = 0x0001" severity error;
    -- 'F' case
        RBS_16_D_IN <= "0000000000001111";
        RBS_16_SHIFT <= "0010";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000011")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for RBS_16_D_IN = 0x000F" severity error;
    -- 'F00F' case
        RBS_16_D_IN <= "1111000000001111";
        RBS_16_SHIFT <= "1000";
        wait for period;
        assert (RBS_16_D_OUT = "0000000011110000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for RBS_16_D_IN = 0xF00F" severity error;
    -- 'FFFF' case
        RBS_16_D_IN <= "1111111111111111";
        RBS_16_SHIFT <= "1111";
        wait for period;
        assert (RBS_16_D_OUT = "0000000000000000")  -- expected output
        -- error will be reported if out is not 0
            report "test failed for RBS_16_D_IN = 0xFFFF" severity error;
    wait;
    end process;


end Behavioral;
