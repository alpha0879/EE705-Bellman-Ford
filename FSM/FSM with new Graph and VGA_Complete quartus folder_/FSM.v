module FSM(CLOCK_50, KEY, SW, LEDR, LEDG);
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
	
	
	pll	pll_inst (
	.inclk0 ( CLOCK_50 ),
	.c0 ( vga_clk )
	);

	assign button_input = SW[5:0];
	assign sys_reset = KEY[0];
	assign new_dest_rest = {SW[5],KEY[0]}; //{dest_inp_en,reset}
	
	pipelined_bellman_ford compute_stg(.clk(CLOCK_50), .clear(global_clear), .enable(global_en), 
															.stg1_mux_control(select_input_predecessor), .source_address(source_addr), 
															.predecessor_rd_addr(predecessor_addr), .predecessor_out(predecessor_out), .done(done_compute));
															
	module_display1 vga_module(.index_5(predecessor_addr),.write_en(vga_write),.FSM_clk(CLOCK_50),.clk_25(vga_clk),.clr(vga_clr),.display_on(vga_disp),
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
						
						source_addr = button_input[4:0];
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
							dest_addr = button_input[4:0]; // destination 
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
							dest_addr = button_input[4:0];
							
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
							dest_addr = button_input[4:0];
							
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
							
							dest_addr = button_input[4:0];
							predecessor_addr = 5'b00000;
							
							global_clear  = 1'b0;
							global_en = 1'b0;							
							select_input_predecessor = 1'b0;
							
							if((new_dest_rest == 2'b00)||(new_dest_rest ==2'b10))
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