// provide enable and clear..
// when done == 1 , disable the enable signal from the controller, 

module pipelined_bellman_ford (clk, clear, enable, stg1_mux_control, source_address, predecessor_rd_addr, predecessor_out, done);

input clk, clear, enable, stg1_mux_control;
input [4:0] source_address, predecessor_rd_addr;

output reg [4:0] predecessor_out;
output done;
// debug
//output [17:0] compute_outa, compute_outb, compute_outc, compute_outd;

wire [13:0] i0, i1,i2,i3;
wire [4:0] mux_out;

wire [20:0] stg1_pipeline_register_input_A, stg1_pipeline_register_input_B, stg1_pipeline_register_input_C, 
			stg1_pipeline_register_input_D, stage1_sort_input_A, stage1_sort_input_B, stage1_sort_input_C, stage1_sort_input_D;
			
wire [21:0] stg2_sorting_blk_out_A, stg2_sorting_blk_out_B, stg2_sorting_blk_out_C, stg2_sorting_blk_out_D;
wire [21:0] stg2_pipeline_reg_out_A, stg2_pipeline_reg_out_B, stg2_pipeline_reg_out_C, stg2_pipeline_reg_out_D;

			

wire [6:0] w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3;

wire [11:0] w_i_pred0;

wire [4:0] j0_addr, j1_addr, j2_addr, j3_addr;

// FOR mem-read 
wire [28:0] stg3_memread_fwd_blck_ip_A, stg3_memread_fwd_blck_ip_B, stg3_memread_fwd_blck_ip_C, stg3_memread_fwd_blck_ip_D;
wire [28:0] stg3_fwd_block_op_A, stg3_fwd_block_op_B, stg3_fwd_block_op_C, stg3_fwd_block_op_D;

wire [28:0] stg4_fwd_blk_ip_A, stg4_fwd_blk_ip_B, stg4_fwd_blk_ip_C, stg4_fwd_blk_ip_D;
wire [28:0] stg4_comp_blk_ip_A, stg4_comp_blk_ip_B, stg4_comp_blk_ip_C, stg4_comp_blk_ip_D;

wire [17:0] stg4_comp_blk_op_A, stg4_comp_blk_op_B, stg4_comp_blk_op_C, stg4_comp_blk_op_D;
wire [17:0] stg4_pipeline_reg_out_A, stg4_pipeline_reg_out_B, stg4_pipeline_reg_out_C, stg4_pipeline_reg_out_D;

wire [11:0] w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3;

wire UP ;

wire [4:0] pointer_address_to_mem;

// ************************************ stage 1 ******************************************************************************

stage1 stage1_read ( .clk(clk), .clear(clear) , .enable(enable), .output1(i0), .output2(i1), .output3(i2), .output4(i3) , 
										.pointer_address(pointer_address_to_mem));

mux_5_bit_2_input stg1_mux (.ip0(i0[9:5]), .ip1(predecessor_rd_addr), .select(stg1_mux_control), .out(mux_out)); // fill ip1 and select from ns

regFile register_output (.clk(clk), .rst(clear), .sourceaddr(source_address), .readaddr_i0(mux_out), .readaddr_i1(i1[9:5]), .readaddr_i2(i2[9:5]),
						 .readaddr_i3(i3[9:5]), .readaddr_j0(j0_addr), .readaddr_j1(j1_addr), .readaddr_j2(j2_addr), .readaddr_j3(j3_addr), 						 
						 .writeaddr_j0(stg4_pipeline_reg_out_A[11:7]), .writeaddr_j1(stg4_pipeline_reg_out_B[11:7]),  
						 .writeaddr_j2(stg4_pipeline_reg_out_C[11:7]), .writeaddr_j3(stg4_pipeline_reg_out_D[11:7]),  
						 .w_i_pred0(w_i_pred0), .w_i1(w_i1), .w_i2(w_i2), .w_i3(w_i3),
						 .w_j0(w_j0), .w_j1(w_j1), .w_j2(w_j2), .w_j3(w_j3) , 
						 .w_j_pred0(w_j_pred0), .w_j_pred1(w_j_pred1), .w_j_pred2(w_j_pred2), .w_j_pred3(w_j_pred3), 
						 .wr_en0(stg4_pipeline_reg_out_A[17]), .wr_en1(stg4_pipeline_reg_out_B[17]), 
						 .wr_en2(stg4_pipeline_reg_out_C[17]), .wr_en3(stg4_pipeline_reg_out_D[17]));  
	
	
assign stg1_pipeline_register_input_A = {i0[13:10], i0[9:5], i0[4:0], w_i_pred0[11:5]};
assign stg1_pipeline_register_input_B = {i1[13:10], i1[9:5], i1[4:0], w_i1};
assign stg1_pipeline_register_input_C = {i2[13:10], i2[9:5], i2[4:0], w_i2};
assign stg1_pipeline_register_input_D = {i3[13:10], i3[9:5], i3[4:0], w_i3};

/// ************** stage_1_pipelined - register ***********************************


register pipeline_stg1 ( .clk(clk), .clear(clear), .enable(enable), .in_data1(stg1_pipeline_register_input_A), .in_data2(stg1_pipeline_register_input_B), 
						.in_data3(stg1_pipeline_register_input_C), .in_data4(stg1_pipeline_register_input_D), 
						.out_data1(stage1_sort_input_A), .out_data2(stage1_sort_input_B), .out_data3(stage1_sort_input_C),.out_data4(stage1_sort_input_D));

defparam pipeline_stg1.WORD_SIZE = 21;

// ******************************************** stage2_ sorting ***********************************************

sorting_block stage2 (stage1_sort_input_A, stage1_sort_input_B, stage1_sort_input_C, stage1_sort_input_D, stg2_sorting_blk_out_A, 
					  stg2_sorting_blk_out_B, stg2_sorting_blk_out_C, stg2_sorting_blk_out_D);


// ************** stage_2_pipelined - register ***********************************

register pipeline_stg2 ( .clk(clk), .clear(clear), .enable(enable), .in_data1(stg2_sorting_blk_out_A), .in_data2(stg2_sorting_blk_out_B), 
						.in_data3(stg2_sorting_blk_out_C), .in_data4(stg2_sorting_blk_out_D), 
						.out_data1(stg2_pipeline_reg_out_A), .out_data2(stg2_pipeline_reg_out_B), .out_data3(stg2_pipeline_reg_out_C),
						.out_data4(stg2_pipeline_reg_out_D));

defparam pipeline_stg2.WORD_SIZE = 22;

// ******************************************** stage3_ mem_read *************************************************

assign j0_addr = stg2_pipeline_reg_out_A [11:7];
assign j1_addr = stg2_pipeline_reg_out_B [11:7];
assign j2_addr = stg2_pipeline_reg_out_C [11:7];
assign j3_addr = stg2_pipeline_reg_out_D [11:7];

assign stg3_memread_fwd_blck_ip_A = { stg2_pipeline_reg_out_A, w_j0 };
assign stg3_memread_fwd_blck_ip_B = { stg2_pipeline_reg_out_B, w_j1 };
assign stg3_memread_fwd_blck_ip_C = { stg2_pipeline_reg_out_C, w_j2 };
assign stg3_memread_fwd_blck_ip_D = { stg2_pipeline_reg_out_D, w_j3 };


forwardblock frwd_mem_read_stg ( .inp_1(stg3_memread_fwd_blck_ip_A), .inp_2(stg3_memread_fwd_blck_ip_B), 
								 .inp_3(stg3_memread_fwd_blck_ip_C), .inp_4(stg3_memread_fwd_blck_ip_D), 
								 .inpf_1(stg4_pipeline_reg_out_A), .inpf_2(stg4_pipeline_reg_out_B), 
								 .inpf_3(stg4_pipeline_reg_out_C), .inpf_4(stg4_pipeline_reg_out_D), 
								 .out_1(stg3_fwd_block_op_A), .out_2(stg3_fwd_block_op_B), .out_3(stg3_fwd_block_op_C), .out_4(stg3_fwd_block_op_D));


// ************** stage_3_pipelined - register ***********************************


register pipeline_stg3 ( .clk(clk), .clear(clear), .enable(enable), .in_data1(stg3_fwd_block_op_A), .in_data2(stg3_fwd_block_op_B), 
						.in_data3(stg3_fwd_block_op_C), .in_data4(stg3_fwd_block_op_D), 
						.out_data1(stg4_fwd_blk_ip_A), .out_data2(stg4_fwd_blk_ip_B), .out_data3(stg4_fwd_blk_ip_C),
						.out_data4(stg4_fwd_blk_ip_D));

defparam pipeline_stg3.WORD_SIZE = 29;


// ******************************************** stage4_ computational block *************************************************

forwardblock frwd_comp_stg ( .inp_1(stg4_fwd_blk_ip_A), .inp_2(stg4_fwd_blk_ip_B), 
								 .inp_3(stg4_fwd_blk_ip_C), .inp_4(stg4_fwd_blk_ip_D), 
								 .inpf_1(stg4_pipeline_reg_out_A), .inpf_2(stg4_pipeline_reg_out_B),
								 .inpf_3(stg4_pipeline_reg_out_C), .inpf_4(stg4_pipeline_reg_out_D), 
								 .out_1(stg4_comp_blk_ip_A), .out_2(stg4_comp_blk_ip_B), .out_3(stg4_comp_blk_ip_C), .out_4(stg4_comp_blk_ip_D));

computation_block stg4_compute (.mem_w0(stg4_comp_blk_ip_A), .mem_w1(stg4_comp_blk_ip_B), .mem_w2(stg4_comp_blk_ip_C), .mem_w3(stg4_comp_blk_ip_D),
								.out0(stg4_comp_blk_op_A), .out1(stg4_comp_blk_op_B), .out2(stg4_comp_blk_op_C), .out3(stg4_comp_blk_op_D) );
								

// *************************************************** stage_4_pipelined - register **********************************************


register pipeline_stg4 ( .clk(clk), .clear(clear), .enable(enable), .in_data1(stg4_comp_blk_op_A), .in_data2(stg4_comp_blk_op_B), 
						.in_data3(stg4_comp_blk_op_C), .in_data4(stg4_comp_blk_op_D), 
						.out_data1(stg4_pipeline_reg_out_A), .out_data2(stg4_pipeline_reg_out_B), .out_data3(stg4_pipeline_reg_out_C),
						.out_data4(stg4_pipeline_reg_out_D));

defparam pipeline_stg4.WORD_SIZE = 18;

assign w_j_pred0 = {stg4_pipeline_reg_out_A[6:0], stg4_pipeline_reg_out_A[16:12]};
assign w_j_pred1 = {stg4_pipeline_reg_out_B[6:0], stg4_pipeline_reg_out_B[16:12]};
assign w_j_pred2 = {stg4_pipeline_reg_out_C[6:0], stg4_pipeline_reg_out_C[16:12]};
assign w_j_pred3 = {stg4_pipeline_reg_out_D[6:0], stg4_pipeline_reg_out_D[16:12]};

//**************************************************************************************************

always @ ( posedge clk ) begin 
	predecessor_out = w_i_pred0[4:0];
end

/*assign compute_outa = stg4_pipeline_reg_out_A;
assign compute_outb = stg4_pipeline_reg_out_B;
assign compute_outc = stg4_pipeline_reg_out_C;
assign compute_outd = stg4_pipeline_reg_out_D;*/



//****************************************** early_stop_logic ***************************************************************************

assign UP = stg4_pipeline_reg_out_A[17] | stg4_pipeline_reg_out_B[17] | stg4_pipeline_reg_out_C[17] | stg4_pipeline_reg_out_D[17] ;

early_stop early_stop_logic ( .UP( UP ), .clk( clk ), .clr( clear ), .addr( pointer_address_to_mem ), .done( done ) ); 

endmodule

