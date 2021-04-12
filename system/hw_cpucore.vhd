

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY hw_CpuCore IS
   PORT (
      display_clock : IN STD_LOGIC;
      clock : IN STD_LOGIC;
      local_leds : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      local_seven_segment : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      local_digit_select : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 5);
      ack_signal : OUT STD_LOGIC;

      debug_clock : IN STD_LOGIC;
      copy_transfer : IN STD_LOGIC;
      data_in : IN STD_LOGIC;
      data_out : OUT STD_LOGIC;

      AuxStep : OUT STD_LOGIC;
      AuxNext : OUT STD_LOGIC;
      AuxResume : OUT STD_LOGIC
   );
END hw_CpuCore;

ARCHITECTURE Behavioral OF hw_CpuCore IS

   COMPONENT System IS
      PORT (
         btnU : IN STD_LOGIC;
         btnD : IN STD_LOGIC;
         btnL : IN STD_LOGIC;
         btnR : IN STD_LOGIC;
         btnC : IN STD_LOGIC;

         leds : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
         dip_switches : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         seven_segment : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         digit_select : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

         clock : IN STD_LOGIC;
         display_clock : IN STD_LOGIC;
         ack_signal : OUT STD_LOGIC;

         in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 5)
      );
   END COMPONENT System;

   SIGNAL TemporaryBuffer : STD_LOGIC_VECTOR(1023 DOWNTO 0);

   SIGNAL input_stream : STD_LOGIC_VECTOR(39 DOWNTO 0);
   SIGNAL output_stream : STD_LOGIC_VECTOR(59 DOWNTO 0);
   SIGNAL input_count : unsigned (7 DOWNTO 0);
   SIGNAL output_count : unsigned (7 DOWNTO 0);
   SIGNAL Digit4 : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL Digit3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL Digit2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL Digit1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL HexKeyboard : STD_LOGIC_VECTOR(15 DOWNTO 0);

   SIGNAL dip_switches : STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL btnC : STD_LOGIC;
   SIGNAL btnU : STD_LOGIC;
   SIGNAL btnD : STD_LOGIC;
   SIGNAL btnL : STD_LOGIC;
   SIGNAL btnR : STD_LOGIC;
   SIGNAL keyboard_col_data : STD_LOGIC_VECTOR (3 DOWNTO 0);
   SIGNAL keyboard_row_data : STD_LOGIC_VECTOR (3 DOWNTO 0);

   SIGNAL digit_select : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL seven_segment : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL leds : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL JC0 : STD_LOGIC;
   SIGNAL ack : STD_LOGIC;
   --
   -- Receive switch data
   --

BEGIN
   Core : System PORT MAP
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

   PROCESS (display_clock, digit_select, seven_segment)
   BEGIN
      IF (rising_edge(display_clock)) THEN
         IF (digit_select = "1110") THEN
            Digit1 <= NOT seven_segment;
         END IF;

         IF (digit_select = "1101") THEN
            Digit2 <= NOT seven_segment;
         END IF;

         IF (digit_select = "1011") THEN
            Digit3 <= NOT seven_segment;
         END IF;

         IF (digit_select = "0111") THEN
            Digit4 <= NOT seven_segment;
         END IF;
      END IF;
   END PROCESS;
   PROCESS (debug_clock, copy_transfer, data_in)
   BEGIN
      IF rising_edge(debug_clock) THEN
         IF (copy_transfer = '0') THEN
            input_count <= x"00";
         ELSE
            IF (input_count < 40) THEN
               input_stream(39 DOWNTO 0) <= input_stream(38 DOWNTO 0) & data_in;
               input_count <= input_count + x"01";
            ELSE
               AuxStep <= input_stream(39);
               AuxNext <= input_stream(38);
               AuxResume <= input_stream(37);
               dip_switches <= input_stream(36 DOWNTO 21);
               btnU <= input_stream(20);
               btnC <= input_stream(19);
               btnD <= input_stream(18);
               btnL <= input_stream(17);
               btnR <= input_stream(16);
               HexKeyboard <= input_stream(15 DOWNTO 0);
            END IF;
         END IF;

      END IF;
   END PROCESS;

   --
   -- Send LED data
   --

   PROCESS (debug_clock, copy_transfer)
   BEGIN
      IF rising_edge(debug_clock) THEN
         IF (copy_transfer = '0') THEN
            output_count <= x"00";

            output_stream(59) <= clock;
            output_stream(58) <= in_port(7);
            output_stream(57) <= ack;
            output_stream(56) <= in_port(6);
            output_stream(55 DOWNTO 48) <= in_port(15 DOWNTO 8);

            output_stream(47 DOWNTO 32) <= leds;
            output_stream(31 DOWNTO 24) <= "0" & Digit4;
            output_stream(23 DOWNTO 16) <= "0" & Digit3;
            output_stream(15 DOWNTO 8) <= "0" & Digit2;
            output_stream(7 DOWNTO 0) <= "0" & Digit1;

         ELSE
            IF (output_count < (59 + 1)) THEN
               output_stream(59 DOWNTO 0) <= output_stream(58 DOWNTO 0) & "0";
               output_count <= output_count + x"01";
            END IF;
         END IF;

      END IF;
   END PROCESS;

   PROCESS (display_clock, keyboard_col_data, HexKeyboard)
   BEGIN
      IF (keyboard_col_data = "0111") THEN
         keyboard_row_data <= NOT HexKeyboard(15 DOWNTO 12);

      ELSIF (keyboard_col_data = "1011") THEN
         keyboard_row_data <= NOT HexKeyboard(11 DOWNTO 8);

      ELSIF (keyboard_col_data = "1101") THEN
         keyboard_row_data <= NOT HexKeyboard(7 DOWNTO 4);

      ELSIF (keyboard_col_data = "1110") THEN
         keyboard_row_data <= NOT HexKeyboard(3 DOWNTO 0);

      ELSE
         keyboard_row_data <= "1111";
      END IF;
   END PROCESS;
   data_out <= output_stream(59);
   local_digit_select <= digit_select;
   local_seven_segment <= seven_segment;
   local_leds <= leds;
   ack_signal <= ack;

END Behavioral;