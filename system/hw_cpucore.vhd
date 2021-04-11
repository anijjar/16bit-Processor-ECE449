

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity hw_CpuCore is
port (
        display_clock: in STD_LOGIC;
        clock: in STD_LOGIC;
        local_leds: out std_logic_vector( 15 downto 0 );
        local_seven_segment: out std_logic_vector( 6 downto 0 );
        local_digit_select: out std_logic_vector( 3 downto 0 );
        in_port: in std_logic_vector( 15 downto 5 );
        ack_signal: out std_logic;

        debug_clock : in std_logic;
        copy_transfer: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic;
        
        AuxStep: out std_logic;
        AuxNext: out std_logic;
        AuxResume: out std_logic
);
end hw_CpuCore;

architecture Behavioral of hw_CpuCore is

component System is
	Port ( 
        btnU: in std_logic;
        btnD: in std_logic;
        btnL: in std_logic;
        btnR: in std_logic;
        btnC: in std_logic;

        leds: out std_logic_vector( 15 downto 0 );
        dip_switches: in std_logic_vector( 15 downto 0 );
        seven_segment: out std_logic_vector( 6 downto 0 );
        digit_select: out std_logic_vector( 3 downto 0 );

        clock : in std_logic;
        display_clock: in std_logic;
        ack_signal: out std_logic;

        in_port : in std_logic_vector(15 downto 5)
);
end component System;



signal TemporaryBuffer: std_logic_vector( 1023 downto 0);

signal input_stream: std_logic_vector( 39 downto 0 );
signal output_stream: std_logic_vector( 59 downto 0 );
signal input_count: unsigned ( 7 downto 0 ); 
signal output_count: unsigned ( 7 downto 0 ); 
signal Digit4: std_logic_vector( 6 downto 0 );
signal Digit3: std_logic_vector( 6 downto 0 );
signal Digit2: std_logic_vector( 6 downto 0 );
signal Digit1: std_logic_vector( 6 downto 0 );
signal HexKeyboard: std_logic_vector( 15 downto 0 );

signal dip_switches: std_logic_vector ( 15 downto 0 );
signal btnC: std_logic;
signal btnU: STD_LOGIC;
signal btnD: STD_LOGIC;
signal btnL: STD_LOGIC;
signal btnR: STD_LOGIC;
signal keyboard_col_data: std_logic_vector ( 3 downto 0 );
signal keyboard_row_data: std_logic_vector ( 3 downto 0 );

signal digit_select: STD_LOGIC_VECTOR( 3 downto 0 );
signal seven_segment: STD_LOGIC_VECTOR( 6 downto 0 ); 
signal leds: STD_LOGIC_VECTOR( 15 downto 0 );
signal JC0: STD_LOGIC;
signal ack: STD_LOGIC;
--
-- Receive switch data
--

begin
Core: System port map
( 
        display_clock => display_clock,
        clock => clock, 
        btnC => btnC,
        btnU => btnU,
        btnD => btnD,
        btnL => btnL,
        btnR => btnR,

        digit_select => digit_select,
        seven_segment => seven_segment,
        leds => leds,
        dip_switches => dip_switches,
        in_port => in_port,
        ack_signal => ack

);





    process( display_clock, digit_select, seven_segment )
    begin
        if ( rising_edge( display_clock )) then
            if ( digit_select = "1110" ) then
                Digit1 <= not seven_segment;
            end if;

            if ( digit_select = "1101" ) then
                Digit2 <= not seven_segment;
            end if;

            if ( digit_select = "1011" ) then
                Digit3 <= not seven_segment;
            end if;

            if ( digit_select = "0111" ) then
                Digit4 <= not seven_segment;
            end if;
        end if;
    end process;


    process( debug_clock, copy_transfer, data_in )
    begin
        if rising_edge( debug_clock ) then
            if ( copy_transfer = '0' ) then
                input_count <= x"00";
            else
                if ( input_count < 40 ) then
                    input_stream(39 downto 0 ) <= input_stream( 38 downto 0 ) & data_in;
                    input_count <= input_count + x"01";
                else
                    AuxStep <= input_stream( 39 );
                    AuxNext <= input_stream( 38 );
                    AuxResume <= input_stream( 37 );
                    dip_switches <= input_stream( 36 downto 21 );
                    btnU <= input_stream( 20 );
                    btnC <= input_stream( 19 );
                    btnD <= input_stream( 18 );
                    btnL <= input_stream( 17 );
                    btnR <= input_stream( 16 );
                    HexKeyboard <= input_stream( 15 downto 0 );
                end if;
            end if;

         end if;
    end process;

--
-- Send LED data
--

    process( debug_clock, copy_transfer )
    begin
        if rising_edge( debug_clock ) then
            if ( copy_transfer = '0' ) then
                output_count <= x"00";

                output_stream( 59 ) <= clock;
                output_stream( 58 ) <= in_port( 7 );
                output_stream( 57 ) <= ack;
                output_stream( 56 ) <= in_port( 6 ); 
                output_stream( 55 downto 48 ) <= in_port( 15 downto 8 );

                output_stream( 47 downto 32 ) <= leds;
                output_stream( 31 downto 24 ) <= "0" & Digit4;
                output_stream( 23 downto 16 ) <= "0" & Digit3;
                output_stream( 15 downto  8 ) <= "0" & Digit2;
                output_stream(  7 downto  0 ) <= "0" & Digit1;

             else
                if ( output_count < ( 59 + 1 )) then
                    output_stream(59 downto 0) <= output_stream(58 downto 0) & "0";
                    output_count <= output_count + x"01";
                end if;
            end if;

         end if;
    end process;

    process ( display_clock, keyboard_col_data, HexKeyboard )
    begin
        if ( keyboard_col_data = "0111" ) then
            keyboard_row_data <= not HexKeyboard( 15 downto 12 );

        elsif( keyboard_col_data = "1011" ) then
            keyboard_row_data <= not HexKeyboard( 11 downto 8 );

        elsif( keyboard_col_data = "1101" ) then
            keyboard_row_data <= not HexKeyboard(  7 downto 4 );

        elsif ( keyboard_col_data = "1110" ) then
            keyboard_row_data <= not HexKeyboard( 3 downto 0 );

        else
            keyboard_row_data <= "1111";
        end if;
     end process;




    data_out <= output_stream(59);
    local_digit_select <= digit_select;
    local_seven_segment <= seven_segment; 
    local_leds <= leds;
    ack_signal <= ack;

end Behavioral;