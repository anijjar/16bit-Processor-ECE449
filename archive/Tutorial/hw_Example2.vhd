----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/03/2020 12:50:04 PM
-- Design Name: 
-- Module Name: RemoteHardware - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw_Example2 is
port (
	    display_clock: in STD_LOGIC;
		debug_clock : in std_logic;
		copy_transfer: in std_logic;
		data_in: in std_logic;
		data_out: out std_logic;
		local_led: out std_logic_vector( 15 downto 0 );
		local_seg: out std_logic_vector( 6 downto 0 );
		local_an: out std_logic_vector( 3 downto 0 )
);
end hw_Example2;

architecture Behavioral of hw_Example2 is

component Example2 is
	Port ( 
	  a,b,c,d        : in STD_LOGIC;
	  Y1,Y2,Y3,Y4,Y5 : out STD_LOGIC
--       display_clock: in STD_LOGIC;
--       sw: in STD_LOGIC_VECTOR( 15 downto 0 );
--       led: out STD_LOGIC_VECTOR( 15 downto 0 );
--       digit_select: out STD_LOGIC_VECTOR( 3 downto 0 );
--       segment_select: out STD_LOGIC_VECTOR( 6 downto 0 );
--       btnC: in STD_LOGIC;
--       btnU: in STD_LOGIC;
--       btnD: in STD_LOGIC;
--       btnL: in STD_LOGIC;
--       btnR: in STD_LOGIC;
--       keyboard_col_data: out std_logic_vector ( 3 downto 0 );
--       keyboard_row_data: in std_logic_vector ( 3 downto 0 )
 
	);			 
end component Example2;



signal TemporaryBuffer: std_logic_vector( 1023 downto 0);

signal input_stream: std_logic_vector( 36 downto 0 );
signal output_stream: std_logic_vector( 47 downto 0 );
signal input_count: unsigned ( 7 downto 0 ); 
signal output_count: unsigned ( 7 downto 0 ); 
signal Digit4: std_logic_vector( 6 downto 0 );
signal Digit3: std_logic_vector( 6 downto 0 );
signal Digit2: std_logic_vector( 6 downto 0 );
signal Digit1: std_logic_vector( 6 downto 0 );
signal HexKeyboard: std_logic_vector( 15 downto 0 );

signal sw: std_logic_vector ( 15 downto 0 );
signal btnC: std_logic;
signal btnU: STD_LOGIC;
signal btnD: STD_LOGIC;
signal btnL: STD_LOGIC;
signal btnR: STD_LOGIC;
signal keyboard_col_data: std_logic_vector ( 3 downto 0 );
signal keyboard_row_data: std_logic_vector ( 3 downto 0 );

signal digit_select: STD_LOGIC_VECTOR( 3 downto 0 );
signal segment_select: STD_LOGIC_VECTOR( 6 downto 0 ); 
signal led: STD_LOGIC_VECTOR( 15 downto 0 );

--
-- Receive switch data
--

begin

Ex2: Example2 port map  -- 
	( 
       	  a => sw(0),
	  b => sw(1),
	  c => sw(2),
	  d => sw(3),
	  Y1 => led(0),
	  Y2 => led(1),
	  Y3 => led(2),
	  Y4 => led(3),
	  Y5 => led(4)
--       display_clock => display_clock,
--       sw => sw,
--       led => led,
--       digit_select => digit_select,
--       segment_select => segment_select,
--       btnC => btnC,
--       btnU => btnU,
--       btnD => btnD,
--       btnL => btnL,
--       btnR => btnR,
--       keyboard_col_data => keyboard_col_data,
--       keyboard_row_data => keyboard_row_data
	);		 





    process( display_clock, digit_select, segment_select )
    begin
        if ( rising_edge( display_clock )) then
            if ( digit_select = "1110" ) then
                Digit1 <= not segment_select;
            end if;
            
            if ( digit_select = "1101" ) then
                Digit2 <= not segment_select;
            end if;
            
            if ( digit_select = "1011" ) then
                Digit3 <= not segment_select;
            end if;
            
            if ( digit_select = "0111" ) then
                Digit4 <= not segment_select;
            end if;
        end if;
    end process;


    process( debug_clock, copy_transfer, data_in )
    begin
        if rising_edge( debug_clock ) then
            if ( copy_transfer = '0' ) then
                input_count <= x"00";
            else      
                if ( input_count < 37 ) then
                    input_stream(36 downto 0 ) <= input_stream( 35 downto 0 ) & data_in;
                    input_count <= input_count + x"01";
                else
                    sw <= input_stream( 36 downto 21 );
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
                output_stream( 47 downto 32 ) <= led;
                output_stream( 31 downto 24 ) <= "0" & Digit4;
                output_stream( 23 downto 16 ) <= "0" & Digit3;
                output_stream( 15 downto  8 ) <= "0" & Digit2;
                output_stream(  7 downto  0 ) <= "0" & Digit1;
                          
             else      
                if ( output_count < 48 ) then
                    output_stream(47 downto 0) <= output_stream(46 downto 0) & "0";
--                    data_out <= output_stream( to_integer( output_count ));
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
    
    
    
    
    data_out <= output_stream(47);
    local_an <= digit_select;
    local_seg <= segment_select; 
    local_led <= led;   
    
    
--   DebugStreamDataOut <= TemporaryBuffer(1023);
end Behavioral;
