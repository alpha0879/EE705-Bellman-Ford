transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA/VGAtest {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/VGAtest/module_display1.v}

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA/VGAtest {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/VGAtest/TestBench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TestBench

add wave *
view structure
view signals
run -all
