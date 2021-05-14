## Generated SDC file "FSM.out.sdc"

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

## DATE    "Sun Apr 18 20:55:02 2021"

##
## DEVICE  "EP4CE22F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pll_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 2 -master_clock {CLOCK_50} [get_pins {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {KEY}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[0]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[1]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[2]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[3]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[4]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[5]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[6]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[7]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[8]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[9]}]
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {SW[10]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {LEDG}]
set_output_delay -add_delay  -clock [get_clocks {CLOCK_50}]  1.000 [get_ports {LEDR}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {blue[0]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {blue[1]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {green[0]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {green[1]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {green[2]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {hsync}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {red[0]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {red[1]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {red[2]}]
set_output_delay -add_delay  -clock [get_clocks {pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {vsync}]


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

