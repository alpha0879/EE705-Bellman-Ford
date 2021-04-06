## Generated SDC file "pipelined_bellman_ford.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Tue Apr 06 20:35:46 2021"

##
## DEVICE  "EP4CE6F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 16.000 -waveform { 0.000 8.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {clear}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {enable}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_rd_addr[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_rd_addr[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_rd_addr[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_rd_addr[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_rd_addr[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {source_address[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {source_address[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {source_address[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {source_address[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {source_address[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {stg1_mux_control}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {done}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_out[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_out[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_out[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_out[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {predecessor_out[4]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

