transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/stage1.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/sorting_block.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/register.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/regFile.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/program_counter.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/pipelined_bellman_ford.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/mux_5_bit_2_input.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/forwardblock.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/early_stop.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/computation_block.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/FSM.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/pll.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA/db {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/module_display1.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/rom_lut.v}

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/TESTING_NEW\ VGA {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/TESTING_NEW VGA/tb_FSM_V2.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_FSM_V2

add wave *
view structure
view signals
run -all
