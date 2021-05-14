transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/pll.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/stage1.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/sorting_block.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/register.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/regFile.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/program_counter.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/pipelined_bellman_ford.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/mux_5_bit_2_input.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/forwardblock.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/early_stop.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/computation_block.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/fsm.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing/db {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/rom_lut.v}
vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/module_display1.v}

vlog -vlog01compat -work work +incdir+G:/G/STUDIES/M.Tech/MOODLE/VLSI\ Design\ lab/Project/FSM/FSM_Timing {G:/G/STUDIES/M.Tech/MOODLE/VLSI Design lab/Project/FSM/FSM_Timing/tb_FSM.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_FSM

add wave *
view structure
view signals
run -all
