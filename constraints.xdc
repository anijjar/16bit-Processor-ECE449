## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports display_clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports display_clock]
	#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]

set_property PACKAGE_PIN J1 [get_ports {debug_clock}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {debug_clock}]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports debug_clock]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {debug_clock_IBUF}]

set_property PACKAGE_PIN K17 [get_ports {clock}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {clock}]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {clock_IBUF}]
	
## Switches
set_property PACKAGE_PIN V17 [get_ports {dip_switches[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[0]}]
set_property PACKAGE_PIN V16 [get_ports {dip_switches[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[1]}]
set_property PACKAGE_PIN W16 [get_ports {dip_switches[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[2]}]
set_property PACKAGE_PIN W17 [get_ports {dip_switches[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[3]}]
set_property PACKAGE_PIN W15 [get_ports {dip_switches[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[4]}]
set_property PACKAGE_PIN V15 [get_ports {dip_switches[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[5]}]
set_property PACKAGE_PIN W14 [get_ports {dip_switches[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[6]}]
set_property PACKAGE_PIN W13 [get_ports {dip_switches[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[7]}]
set_property PACKAGE_PIN V2 [get_ports {dip_switches[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[8]}]
set_property PACKAGE_PIN T3 [get_ports {dip_switches[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[9]}]
set_property PACKAGE_PIN T2 [get_ports {dip_switches[10]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[10]}]
set_property PACKAGE_PIN R3 [get_ports {dip_switches[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[11]}]
set_property PACKAGE_PIN W2 [get_ports {dip_switches[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[12]}]
set_property PACKAGE_PIN U1 [get_ports {dip_switches[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[13]}]
set_property PACKAGE_PIN T1 [get_ports {dip_switches[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[14]}]
set_property PACKAGE_PIN R2 [get_ports {dip_switches[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dip_switches[15]}]
 

## LEDs
set_property PACKAGE_PIN U16 [get_ports {local_leds[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[0]}]
set_property PACKAGE_PIN E19 [get_ports {local_leds[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[1]}]
set_property PACKAGE_PIN U19 [get_ports {local_leds[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[2]}]
set_property PACKAGE_PIN V19 [get_ports {local_leds[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[3]}]
set_property PACKAGE_PIN W18 [get_ports {local_leds[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[4]}]
set_property PACKAGE_PIN U15 [get_ports {local_leds[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[5]}]

set_property PACKAGE_PIN U14 [get_ports {local_leds[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[6]}]
set_property PACKAGE_PIN V14 [get_ports {local_leds[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[7]}]
set_property PACKAGE_PIN V13 [get_ports {local_leds[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[8]}]
set_property PACKAGE_PIN V3 [get_ports {local_leds[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[9]}]
set_property PACKAGE_PIN W3 [get_ports {local_leds[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[10]}]
set_property PACKAGE_PIN U3 [get_ports {local_leds[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[11]}]
set_property PACKAGE_PIN P3 [get_ports {local_leds[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[12]}]
set_property PACKAGE_PIN N3 [get_ports {local_leds[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[13]}]
set_property PACKAGE_PIN P1 [get_ports {local_leds[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[14]}]
set_property PACKAGE_PIN L1 [get_ports {local_leds[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_leds[15]}]
	
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {local_seven_segment[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[0]}]
set_property PACKAGE_PIN W6 [get_ports {local_seven_segment[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[1]}]
set_property PACKAGE_PIN U8 [get_ports {local_seven_segment[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[2]}]
set_property PACKAGE_PIN V8 [get_ports {local_seven_segment[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[3]}]
set_property PACKAGE_PIN U5 [get_ports {local_seven_segment[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[4]}]
set_property PACKAGE_PIN V5 [get_ports {local_seven_segment[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[5]}]
set_property PACKAGE_PIN U7 [get_ports {local_seven_segment[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_seven_segment[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]							
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {local_digit_select[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_digit_select[0]}]
set_property PACKAGE_PIN U4 [get_ports {local_digit_select[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_digit_select[1]}]
set_property PACKAGE_PIN V4 [get_ports {local_digit_select[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_digit_select[2]}]
set_property PACKAGE_PIN W4 [get_ports {local_digit_select[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {local_digit_select[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports {btnC}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {btnC}]

set_property PACKAGE_PIN T18 [get_ports btnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnU]

set_property PACKAGE_PIN W19 [get_ports btnL]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnL]

set_property PACKAGE_PIN T17 [get_ports {btnL}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {btnL}]

set_property PACKAGE_PIN U17 [get_ports btnD]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnD]
 


##Pmod Header JA
##Sch name = JA1
#set_property PACKAGE_PIN J1 [get_ports {debug_clock}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {debug_clock}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {copy_transfer}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {copy_transfer}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {data_in}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {data_out}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_out}]
	
##Sch name = JA7
#set_property PACKAGE_PIN H1 [get_ports {JA[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Sch name = JA8
#set_property PACKAGE_PIN K2 [get_ports {JA[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Sch name = JA9
#set_property PACKAGE_PIN H2 [get_ports {JA[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Sch name = JA10
#set_property PACKAGE_PIN G3 [get_ports {JA[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]



##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {in_port[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[8]}]
#Sch name = in_port2
set_property PACKAGE_PIN A16 [get_ports {in_port[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[9]}]
#Sch name = in_port3
set_property PACKAGE_PIN B15 [get_ports {in_port[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[10]}]
#Sch name = in_port4
set_property PACKAGE_PIN B16 [get_ports {in_port[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[11]}]
#Sch name = in_port7
set_property PACKAGE_PIN A15 [get_ports {in_port[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[12]}]
#Sch name = in_port8
set_property PACKAGE_PIN A17 [get_ports {in_port[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[13]}]
#Sch name = in_port9
set_property PACKAGE_PIN C15 [get_ports {in_port[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[14]}]
#Sch name = in_port10 
set_property PACKAGE_PIN C16 [get_ports {in_port[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[15]}]
 


##Pmod Header JC
##Sch name = JC1
#set_property PACKAGE_PIN K17 [get_ports {debounced_pulse}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {debounced_pulse}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {ack_signal}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ack_signal}]
##Sch name = in_port3
set_property PACKAGE_PIN N17 [get_ports {AuxStep}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AuxStep}]
##Sch name = in_port4
set_property PACKAGE_PIN P18 [get_ports {AuxNext}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AuxNext}]
##Sch name = in_port7
set_property PACKAGE_PIN L17 [get_ports {AuxResume}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AuxResume}]
##Sch name = in_port8
set_property PACKAGE_PIN M19 [get_ports {in_port[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[5]}]
##Sch name = in_port9
set_property PACKAGE_PIN P17 [get_ports {in_port[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[6]}]
##Sch name = in_port10
set_property PACKAGE_PIN R18 [get_ports {in_port[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_port[7]}]


##Pmod Header JXADC
##Sch name = XA1_P
#set_property PACKAGE_PIN J3 [get_ports {JXADC[0]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[0]}]
##Sch name = XA2_P
#set_property PACKAGE_PIN L3 [get_ports {JXADC[1]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[1]}]
##Sch name = XA3_P
#set_property PACKAGE_PIN M2 [get_ports {JXADC[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[2]}]
##Sch name = XA4_P
#set_property PACKAGE_PIN N2 [get_ports {JXADC[3]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[3]}]
##Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
##Sch name = XA2_N
#set_property PACKAGE_PIN M3 [get_ports {JXADC[5]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[5]}]
##Sch name = XA3_N
#set_property PACKAGE_PIN M1 [get_ports {JXADC[6]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[6]}]
##Sch name = XA4_N
#set_property PACKAGE_PIN N1 [get_ports {JXADC[7]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[7]}]



##VGA Connector
#set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[0]}]
#set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[1]}]
#set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[2]}]
#set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[3]}]
#set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[0]}]
#set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[1]}]
#set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[2]}]
#set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[3]}]
#set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[0]}]
#set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[1]}]
#set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[2]}]
#set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[3]}]
#set_property PACKAGE_PIN P19 [get_ports Hsync]						
	#set_property IOSTANDARD LVCMOS33 [get_ports Hsync]
#set_property PACKAGE_PIN R19 [get_ports Vsync]						
	#set_property IOSTANDARD LVCMOS33 [get_ports Vsync]


##USB-RS232 Interface
#set_property PACKAGE_PIN B18 [get_ports RsRx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
#set_property PACKAGE_PIN A18 [get_ports RsTx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports RsTx]


##USB HID (PS/2)
#set_property PACKAGE_PIN C17 [get_ports PS2Clk]						
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
	#set_property PULLUP true [get_ports PS2Clk]
#set_property PACKAGE_PIN B17 [get_ports PS2Data]					
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
	#set_property PULLUP true [get_ports PS2Data]


##Quad SPI Flash
##Note that CCLK_0 cannot be placed in 7 series devices. You can access it using the
##STARTUPE2 primitive.
#set_property PACKAGE_PIN D18 [get_ports {QspiDB[0]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[0]}]
#set_property PACKAGE_PIN D19 [get_ports {QspiDB[1]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[1]}]
#set_property PACKAGE_PIN G18 [get_ports {QspiDB[2]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[2]}]
#set_property PACKAGE_PIN F18 [get_ports {QspiDB[3]}]				
	#set_property IOSTANDARD LVCMOS33 [get_ports {QspiDB[3]}]
#set_property PACKAGE_PIN K19 [get_ports QspiCSn]					
	#set_property IOSTANDARD LVCMOS33 [get_ports QspiCSn]