module FSM_V2(CLOCK_50, KEY, SW, LEDR, LEDG);
	input CLOCK_50;
    input [0:0]KEY;
	input [5:0]SW;
	output reg [0:0]LEDR;
	output reg [0:0]LEDG;
    
	localparam 
		START = 3'd0,
		INIT = 3'd1,
		COMPUTE = 3'd2,
		DEST_INP = 3'd3,
		DEST_READ = 3'd4,
		RECURSION = 3'd5,
		VGA_DISP = 3'd6;
	
	reg[2:0] present_state, next_state;
	
	wire vga_clk, sys_reset, done_compute;//sys_clk;
	wire hsync, vsync;
	wire [4:0] predecessor_out;
	wire[1:0] new_dest_rest;
	wire[2:0]red,green;
	wire[1:0] blue;
	wire[5:0] button_input;
	reg vga_disp, vga_write, vga_clr = 1'b0;
	reg global_clear, global_en, select_input_predecessor =1'b0;
	reg [4:0] source_addr, dest_addr, predecessor_addr;
	
	//system_clock clk_gen(.inp_clk(CLOCK_50), .sys_clk(sys_clk), .vga_clk(vga_clk));
	
	pll	pll_inst (
	.inclk0 ( CLOCK_50 ),
	.c0 ( vga_clk )
	);

	assign button_input = SW[5:0];
	assign sys_reset = KEY[0];
	assign new_dest_rest = {SW[5],KEY[0]}; //{dest_inp_en, new_dest, reset}
	
	pipelined_bellman_ford compute_stg(.clk(CLOCK_50), .clear(global_clear), .enable(global_en), 
															.stg1_mux_control(select_input_predecessor), .source_address(source_addr), 
															.predecessor_rd_addr(predecessor_addr), .predecessor_out(predecessor_out), .done(done_compute));
															
	module_display vga_module(.index_5(predecessor_addr),.write_en(vga_write),.FSM_clk(CLOCK_50),.clk_25(vga_clk),.clr(vga_clr),.display_on(vga_disp),
								.hsync(hsync),.vsync(vsync),.red(red),.green(green), .blue(blue)  ); 
								
//Synchronous state transition	
	always@(posedge CLOCK_50) begin
			if(!sys_reset) 
			present_state <= START;
	 else 
			present_state <= next_state;
	end

// State transition and Output logic
	always@(*) begin	
	    next_state = present_state;
		case(present_state)
			START:  begin					
						LEDR[0] = 1'b1;
						LEDG[0] = 1'b0;
						vga_disp = 1'b0;
						vga_write = 1'b0;
						vga_clr = 1'b0;
						
						source_addr = 5'b00000;
						dest_addr = 5'b00000;
						predecessor_addr = 5'b00000;
					
						global_clear = 1'b0;
						global_en = 1'b0; 
						select_input_predecessor = 1'b0;

						
						if(button_input[5])
							next_state = INIT;
						else 
							next_state = START;
							
				    end
			INIT:	begin
						LEDR[0] = 1'b1;
						LEDG[0] = 1'b0;
						vga_disp = 1'b0;
						vga_write = 1'b0;
						vga_clr = 1'b0;
						
						source_addr = SW[4:0];
						predecessor_addr = 5'b00000;
						dest_addr = 5'b00000;
						
						global_clear  = 1'b1;
						global_en  = 1'b0;
						select_input_predecessor = 1'b0;
						
						next_state = COMPUTE;
							
					end
			COMPUTE:	begin
							LEDR[0] = 1'b1;
							LEDG[0] = 1'b0;
							vga_write = 1'b0;
							vga_disp = 1'b0;
							vga_clr = 1'b0;
							
							dest_addr = 5'b00000;
							predecessor_addr = 5'b00000;
							
							global_clear  = 1'b0;
							global_en  = 1'b1;
							select_input_predecessor = 1'b0;
							
							
							if(done_compute) begin
												next_state = DEST_INP;
											end								
							else
								next_state = COMPUTE;		
								
						end
			DEST_INP:	begin
							dest_addr = SW[4:0]; // destination 
							LEDR[0] =1'b0;
							LEDG[0] = 1'b1;	
							global_en = 1'b0;
							global_clear = 1'b0;
							select_input_predecessor = 1'b0;
							
							predecessor_addr = 5'b00000;
							
							vga_disp = 1'b0;
							vga_write = 1'b1;
							vga_clr = 1'b1;
							
							if(!button_input[5])
								next_state = DEST_READ;
							else
								next_state = DEST_INP;							
						end
			DEST_READ:	begin
							LEDR[0] =1'b0;
							LEDG[0] = 1'b1;	
							dest_addr = SW[4:0];
							
							global_en = 1'b0;
							global_clear = 1'b0;
							vga_write = 1'b1;
							vga_clr = 1'b0;
							vga_disp = 1'b0;
							predecessor_addr = dest_addr;							
							select_input_predecessor = 1'b1;
							
							next_state = RECURSION;								
						end
			RECURSION:	begin
							LEDR[0] =1'b0;
							LEDG[0] = 1'b1;	
							dest_addr = SW[4:0];
							
							global_clear  = 1'b0;
							global_en = 1'b0;	
							vga_write = 1'b1;
							vga_clr = 1'b0;						
							vga_disp = 1'b0;
							select_input_predecessor = 1'b1;
							if(predecessor_out!=source_addr)
								begin								
								predecessor_addr = predecessor_out;
								next_state = RECURSION;
								end								
							else 
								begin
								predecessor_addr = source_addr;
								next_state = VGA_DISP; 
								end
							
							if(predecessor_addr == 5'd0) 
								begin
								predecessor_addr = source_addr;
								next_state = VGA_DISP;
								end
						end
			VGA_DISP:	begin
						    vga_write = 1'b0;
							vga_clr = 1'b0;
							LEDG[0] = 1'b0;
							LEDR[0] =1'b0;
							vga_disp = 1'b1;
							
							dest_addr = SW[4:0];
							predecessor_addr = 5'b00000;
							
							global_clear  = 1'b0;
							global_en = 1'b0;							
							select_input_predecessor = 1'b0;
							
							if(new_dest_rest == (2'b00||2'b10))
								next_state = START;
							else if(new_dest_rest == 2'b11)
								next_state = DEST_INP;
							else
								next_state = VGA_DISP;
						end
			default:	begin
							
							next_state = START;	
						end
		endcase
	end

endmodule
//...............................................clock_gen............................................
//module system_clock(inp_clk, sys_clk,vga_clk);
//	input inp_clk;
//	output sys_clk,vga_clk;
//	
//	reg[3:0] clock_counter= 4'd0;
//	assign sys_clk = clock_counter[3];
//	assign vga_clk = clock_counter[0];
//	
//    always@(posedge inp_clk) begin
//	  clock_counter = clock_counter+1;
//	end
//
//endmodule


//----------------------------------------------stage_1---------------------------------------
module stage1 ( clk, clear , enable, output1, output2, output3, output4, pointer_address ); 

 input clk;
 input clear;
 input enable;
 output [13:0] output1, output2, output3, output4;
 output [4:0] pointer_address;
 wire [4:0] pointer;
 wire clear_or_zero;
 wire mem_is_zero;
 
 /* initial 
  begin 
     output1 = 0;
	 output2 = 0;
	 output3 = 0;
	 output4 = 0;
  end*/
  
  assign clear_or_zero = clear | mem_is_zero ;
  
  assign pointer_address = pointer;
  
  program_counter pc (clk, clear_or_zero, enable, pointer );
  rom_lut mem1 ( pointer, output1, output2, output3, output4, mem_is_zero );
 
 endmodule
 
//.......................................program counter............................................

module program_counter (clk,clear,enable,count);

input clk;
input clear;
input enable;
output reg [4:0] count = 0;


always @(posedge clk) begin
 
 if (clear) count <= 4'b0;
 else if ( enable )
  begin
	count <= count + 5'd4;
  end
 end

endmodule
 
 //.............................................rom_lut.............................................
 /*
  ROM - LOOK UP TABLE
  OUT1 OUT2 OUT3 OUT4 REPRESENTS THE 4 OUTPUTS READ AT A TIME 
  OUT[13:10] DEPICTS W(I,J)
  OUT[9:5] DEPICTS I
  OUT [4:0] DEPICTS J
*/

module rom_lut ( pointer, out1, out2, out3, out4, mem_is_zero );
 
// input read_enable;
 input [4:0] pointer;

 output reg [13:0] out1, out2, out3, out4;
 output mem_is_zero;
 
 reg [13:0] rom_lut [0:31];
 
 initial 
  begin 
     out1 = 0;
	 out2 = 0;
	 out3 = 0;
	 out4 = 0;
  end
  
  initial begin 
    $readmemb ("rom_input.mif",rom_lut);
  end
  
  always @(*) begin 
   //if (read_enable ) begin 
      out1 = rom_lut[pointer];
	  out2 = rom_lut[pointer+1];
	  out3 = rom_lut[pointer+2];
	  out4 = rom_lut[pointer+3];
	//end
  end
  
  assign mem_is_zero = ( rom_lut[pointer+4] == 14'b0 ) ? 1 : 0;
  
endmodule
//.......................................mux_i_pred_selector...........................
module mux_5_bit_2_input(ip0, ip1, select, out);

	output reg [4:0] out;
	
	input  [4:0] ip0, ip1;
	input  select;
	
	always@(*) begin
		case(select)
			0: out = ip0;
			1: out = ip1;
			default: out = ip0;
		endcase
	end
	
endmodule
//.........................................reg_file.....................................
`define ADDRESS_LEN 5 
`define NODE_WEIGHT_BITSIZE 7
`define MEMORYWORD_BITSIZE 12 
`define REG_SIZE 32 

module regFile (clk, rst, sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3, 
w_i_pred0, w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3 , w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3, wr_en0, wr_en1, wr_en2, wr_en3);
  input clk, rst, wr_en0, wr_en1, wr_en2, wr_en3;
  input [`ADDRESS_LEN-1:0] sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3;
  input [`MEMORYWORD_BITSIZE-1:0] w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3;
  output [`NODE_WEIGHT_BITSIZE-1:0] w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3; 
  output [`MEMORYWORD_BITSIZE-1:0] w_i_pred0; // This is 12 bit wide memory word which includes w[i] and predecessor , predecessor is required to be read during recursive read stage
 
   
  reg [`MEMORYWORD_BITSIZE-1:0] regMem [0:`REG_SIZE-1];
  integer i;

  always @ (negedge clk) begin
    if (rst) begin
      for (i = 0; i < `REG_SIZE; i = i + 1)
		if ( i == sourceaddr )
			regMem[i] <= {`MEMORYWORD_BITSIZE{1'b0}}; // sourceaddr which is read from the user at the start stage of FSM and the corresponding memory word is set 0 as per bell man ford algorithm
		else
			regMem[i] <= { 1'b1, {`MEMORYWORD_BITSIZE-1{1'b0}}};
	end
    else begin
		if (wr_en0) begin 
			regMem[writeaddr_j0] <= w_j_pred0;
		end
		if (wr_en1) begin 
			regMem[writeaddr_j1] <= w_j_pred1;
		end
		if (wr_en2) begin	
			regMem[writeaddr_j2] <= w_j_pred2;
		end
		if (wr_en3) begin
			regMem[writeaddr_j3] <= w_j_pred3;
		end
	end
  end
  
  
  assign w_i_pred0 = (regMem[readaddr_i0]); // 12 bit wide memory word read for accessing predecessor at recursive read stage
  assign w_i1 = (regMem[readaddr_i1][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_i2 = (regMem[readaddr_i2][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_i3 = (regMem[readaddr_i3][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j0 = (regMem[readaddr_j0][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j1 = (regMem[readaddr_j1][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j2 = (regMem[readaddr_j2][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j3 = (regMem[readaddr_j3][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
endmodule // regFile

//...................................computation_block....................................................................

module computation_block(mem_w0,mem_w1,mem_w2,mem_w3,out0,out1,out2,out3);

input wire [28:0] mem_w0,mem_w1,mem_w2,mem_w3;
output wire [17:0] out0,out1,out2,out3;
compute comp0 (mem_w0,out0);
compute comp1 (mem_w1,out1);
compute comp2 (mem_w2,out2);
compute comp3 (mem_w3,out3);

endmodule

module compute(A_in,A_out);
//For A_in
//6:0--->W[j]
//13:7--->W[i]
//18:14--->index j
//23:19--->index i
//27:24---->W[i,j]
//28---->update

//For A_out
//6:0--->W[j]
//11:7--->index j
//16:12-->index i
//17---->update signal
input wire [28:0] A_in;
output reg[17:0] A_out;
wire [6:0] relaxation;
assign relaxation={3'b000,A_in[27:24]}+A_in[13:7];
always@(A_in,relaxation)
begin
	if (A_in[28]==1'b1)
		begin
		if (relaxation<A_in[6:0])
			begin
			A_out[6:0]=relaxation;
			A_out[17]=1'b1;
			end
		else
			begin
			A_out[6:0]=A_in[6:0];
			A_out[17]=1'b0;
			end
		end
	else
		   begin
			A_out[6:0]=A_in[6:0];
			A_out[17]=1'b0;
		   end
	
	A_out[11:7]=A_in[18:14];
	A_out[16:12]=A_in[23:19];
	end
endmodule

//...............................data_forward.......................................

module forwardblock(inp_1,inp_2,inp_3,inp_4,inpf_1,inpf_2,inpf_3,inpf_4, out_1,out_2,out_3,out_4);

  input[28:0] inp_1,inp_2,inp_3,inp_4; // up(1)[28],wij(4)[27:24], i(5)[23:19], j(5)[18:14], wi(7)[13:7], wj(7)[6:0] -- input mem word
  input[17:0] inpf_1,inpf_2,inpf_3,inpf_4; // up(1)[17], i(5)[16:12], j(5)[11:7], wj(7)[6:0]  ---  forwarded mem word
  output reg [28:0] out_1,out_2,out_3,out_4; //up(1),wij(4), i(5), j(5), wi(7), wj(7)
  
  reg [28:0] inp_array[0:3];
  reg [17:0] inpf_array[0:3];
  integer i,j;

  always@(*) begin
	 inp_array[0] = inp_1;
	 inp_array[1] = inp_2;
	 inp_array[2] = inp_3;
	 inp_array[3] = inp_4;
	   
     inpf_array[0] = inpf_1;
	 inpf_array[1] = inpf_2;
	 inpf_array[2] = inpf_3;
     inpf_array[3] = inpf_4;
	 
	 for (i=0; i<=3; i=i+1) begin  // forwarded word
		for(j=0;j<=3; j=j+1) begin // Input word 
		  if((inpf_array[i][17]&& inp_array[j][28]) && (inpf_array[i][11:7] == inp_array[j][18:14])) begin
		     inp_array[j][6:0] = inpf_array[i][6:0]; 
		  end
		  if(inpf_array[i][11:7] == inp_array[j][23:19]) begin
		     inp_array[j][13:7] = inpf_array[i][6:0]; 
		  end
		end
	 end
	out_1 = inp_array[0];
	out_2 = inp_array[1];
	out_3 = inp_array[2];
	out_4 = inp_array[3];	 
  end
endmodule

//............................................. register...................................................

module register #(parameter WORD_SIZE = 8)
					  (input clk, 
					   input clear, 
					   input enable,
					   input [WORD_SIZE-1:0] in_data1,in_data2,in_data3,in_data4,
					   output reg [WORD_SIZE-1:0] out_data1,out_data2,out_data3,out_data4);

always@(posedge clk) begin
		if ( clear ) begin 
			out_data1= 0;
			out_data2= 0;
			out_data3= 0;
			out_data4= 0;
		end
		else if ( enable ) begin
			out_data1 = in_data1;
			out_data2 = in_data2;
			out_data3 = in_data3;
			out_data4 = in_data4;
		end
	end
endmodule
//........................................ sortng block..................................................

//corresponding to p=4
module sorting_block(A,B,C,D,A_new,B_new,C_new,D_new);
input wire [20:0] A,B,C,D;//21 bit word, no update signal
output wire[21:0] A_new,B_new,C_new,D_new;
wire [21:0] A_,B_,C_,D_;//22 bit word, with update signal added
wire [21:0] temp [0:7];
assign A_={1'b1,A};
assign B_={1'b1,B};
assign C_={1'b1,C};
assign D_={1'b1,D};
bitonic_sort C1(A_,B_,temp[0],temp[1]);
bitonic_sort C2(C_,D_,temp[2],temp[3]);
bitonic_sort C3(temp[0],temp[2],temp[4],temp[5]);
bitonic_sort C4(temp[1],temp[3],temp[6],temp[7]);
bitonic_sort C5(temp[4],temp[6],A_new,B_new);
bitonic_sort C6(temp[5],temp[7],C_new,D_new);
endmodule
//********************************* Bitonic sort ************************************************
module bitonic_sort(A,B,LT,GT);
//For A,B,LT,GT
//6:0-->W[i]
//11:7-->index j
//16:12---->index i
//20:17---->W[i,j]
//21----->update signal
input wire [21:0] A,B;//21th bit is update signal: 1 means valid update
output reg[21:0] LT,GT;
reg [6:0] W_A,W_B;
always@(A,B)
begin//start of always
if (A[21]==1'b1 && B[21]==1'b1)//update signals are equla and are 1
	begin
	if(A[11:7]==B[11:7])
		begin
		W_A={3'b000,A[20:17]}+A[6:0];
		W_B={3'b000,B[20:17]}+B[6:0];
		if(W_A<W_B)
			begin
			LT=A[21:0];
			GT={1'b0,B[20:0]};
			end
		else
			begin
			LT=B[21:0];
			GT={1'b0,A[20:0]};
			end
		end
	else if(A[11:7]<B[11:7])
		begin 
		LT=A[21:0];
		GT=B[21:0];
		end
	else
		begin
		LT=B[21:0];
		GT=A[21:0];
		end
	
	end
	else if(A[21]==1'b1 && B[21]==1'b0)
		begin
		LT=A[21:0];
		GT=B[21:0];
		end
	else if(A[21]==1'b0 && B[21]==1'b1)
		begin
		LT=B[21:0];
		GT=A[21:0];
		end
	else
		begin
		LT=A[21:0];
		GT=B[21:0];
		end
		
	
end//end of always
endmodule 
//......................................... early stop...............................
// early stopping 
// UP=up1| up2|up3|up4;

module early_stop( UP, clk, clr, addr, done ); 
	input UP, clk, clr;
	input [4:0] addr ;
	output reg done = 0;	
	
	reg [5:0] count = 6'b000001;
	reg initial_latency = 1;
	
	always@(posedge clk) begin
	if ( clr ) begin
		done = 0;
		count = 1;
		initial_latency = 1;
	end
	
	else if ( addr == 5'b00000 ) begin
		if ( count != 0 )
			done = 0;
		else
			done = 1;
		
		if ( UP || initial_latency ) begin 
			count = 1;
			initial_latency = 0;
			end 				
		else 
		    count = 0;
	end
	else if ( UP )
		count = count + 6'b000001;		
	end
endmodule

//...................pipeline...........................................
module pipelined_bellman_ford (clk, clear, enable, stg1_mux_control, source_address, predecessor_rd_addr, predecessor_out, done);

input clk, clear, enable, stg1_mux_control ;
input [4:0] source_address, predecessor_rd_addr;

output reg[4:0] predecessor_out;
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
always@(posedge clk)begin
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

//*********************************************  VGA Module ******************************************
module module_display(index_5,write_en,FSM_clk,clk_25,clr,display_on,hsync,vsync,red,green,blue);
input [4:0] index_5;
input wire write_en,FSM_clk,clr,display_on,clk_25;
output hsync,vsync;
output reg [2:0]  red,green;
output reg [1:0] blue;
wire [4:0]index_bar;
wire update_signal,clr_vga;
wire [15:0] k;
reg [0:0] graph[0:19199];

initial
begin
$readmemb("graph_1D.mif",graph);
end
assign clr_vga=1'b0;

display_unit D1(index_5,write_en,FSM_clk,clr,display_on,index_bar,update_signal);
vga_controller V1 (clk_25,clr_vga,hsync,vsync,k);
encoder E1(k,index_bar);
always@(posedge clk_25)
begin
	
	
	
	red<={3{graph[k]|update_signal}};
	green<={3{graph[k]|update_signal}};
	blue<={2{graph[k]|update_signal}};
	
end
endmodule


module display_unit(index_5,write_en,FSM_clk,clr,display_on,index_bar,update_signal);
input [4:0] index_5;//5 bit value corresponding to nodes from FSM(writing address)
input write_en,FSM_clk,clr,display_on;//Most of them are from FSM
input [4:0] index_bar;//reading address from encoder block
output wire update_signal;
integer i;
reg [0:31] up=32'h00000000;
wire temp0,temp1;

assign temp0=up[index_bar];
assign update_signal=temp0 & display_on;

//part 1
always@(posedge FSM_clk)
begin
	if(clr)
		begin
		for(i=0;i<32;i=i+1)
			begin
			up[i]<=1'b0;
			end
		end
	else if(write_en)
		begin
		up[index_5]<=1'b1;
		end
end
endmodule
//module 2
//This is a combinational block that converts  16 bits  index value to corresponding  5 bits index for nodes ; for remaining points(16 bits), the corresponding 5 bit value will be zero
module encoder(input_16,output_5);
input [15:0]input_16;
output wire[4:0] output_5;
reg [4:0] index_bar;
assign output_5=index_bar;
always@(input_16)
begin
	case(input_16)//x+y*160 of the node   and it will give us the index corresponding to the particular nodes
		16'b0000110011001011: index_bar=5'b00001;
		16'b0000010000101000: index_bar=5'b00010;
		16'b0000010111001010: index_bar=5'b00011;
		16'b0001010110101111: index_bar=5'b00100;
		16'b0001100010011110: index_bar=5'b00101;
		16'b0000110010010001: index_bar=5'b00110;
		16'b0001101001011001: index_bar=5'b00111;
		16'b0010011001101110: index_bar=5'b01000;
		16'b0010011111010000: index_bar=5'b01001;
		16'b0011001110100000: index_bar=5'b01010;
		16'b0010111011000010: index_bar=5'b01011;
		16'b0011110100100111: index_bar=5'b01100;
		16'b0100011110110101: index_bar=5'b01101;
		16'b0100000010111010: index_bar=5'b01110;
		16'b0100100000101011: index_bar=5'b01111;
		16'b0011100110111100: index_bar=5'b10000;
		16'b0100011011010000: index_bar=5'b10001;
		16'b0100011000000101: index_bar=5'b10010;
		16'b0011011100011111: index_bar=5'b10011;
		16'b0011001010100011: index_bar=5'b10100;
		16'b0010000100100100: index_bar=5'b10101;
		16'b0010101010011101: index_bar=5'b10110;
		16'b0010011110010010: index_bar=5'b10111;
		default : 				 index_bar=5'b00000;
	endcase

end
endmodule


//module 4--vga controller
//clk-->25MHz 
module vga_controller (clk,clr,hsync,vsync,k);
input wire  clk,clr;
output wire hsync,vsync;
parameter [9:0] h_pixels=10'b1100100000;//800
parameter [9:0] v_lines=10'b1000001001;//521
parameter [9:0] hbp=10'b0010010000;//144
parameter [9:0] hfp=10'b1100010000;//784
parameter [9:0] vbp=10'b0000011111;//31
parameter [9:0] vfp=10'b0111111111;//511
reg vsenable=1'b0;
reg  [9:0]  hcs=10'b0000000000;
reg  [9:0]  vcs=10'b0000000000;
wire vid_on;
output reg [15:0] k=16'h0000;
assign hsync=(hcs<128)?1'b0:1'b1;
assign vsync=(vcs<2)?1'b0:1'b1;
assign vid_on=((hcs>=hbp-1 && hcs<hfp-1)&& (vcs>=vbp &&vcs<vfp-1))?1'b1:1'b0;//-1 specifically for this

always@(posedge clk)
begin
	if(hcs==10'b0000000000 && vcs==10'b0000000000)
				k<=16'h0000;
	
			
	else if(hcs[1:0]==2'b00 && vcs[1:0]==2'b11 && vid_on==1'b1)
				k<=k+16'h0001;
		
	
end

always@(posedge clk or posedge clr)
begin
	if(clr)
	
	begin
	hcs<=10'b0000000000;
	vsenable<=0;
	end
	
	else if (hcs==h_pixels-2)
	begin
	hcs<=hcs+10'b0000000001;
	vsenable<=1;
	end
	
	else if (hcs==h_pixels-1)
	begin
	hcs<=10'b0000000000;
	vsenable<=0;
	end
	
	else 
	begin
	hcs<=hcs+10'b0000000001;
	vsenable<=0;
	end
	end

always@(posedge clk or posedge clr)
begin
	if(clr)
	vcs<=10'b0000000000;
	else if (vsenable==1)
	begin
		if (vcs==v_lines-1) 
			vcs<=10'b0000000000;
		else
			vcs<=vcs+10'b0000000001;
		end
end
endmodule