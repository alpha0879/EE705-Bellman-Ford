module FSM(CLOCK_50, KEY, SW, LEDR, LEDG, hsync, vsync, red , green, blue);
	input CLOCK_50;
    input KEY;
	input [10:0]SW;
	output LEDR;
	output LEDG;
	output hsync, vsync;
	output [2:0]red,green;
	output [1:0] blue;
    
	localparam 
		START = 3'd0,
		INIT = 3'd1,
		COMPUTE = 3'd2,
		DEST_INP = 3'd3,
		DEST_READ = 3'd4,
		RECURSION = 3'd5,
		VGA_DISP = 3'd6;
	
	reg[2:0] present_state, next_state;	
	wire vga_clk, sys_reset, done_compute;
	wire [4:0] predecessor_out;
	wire[1:0] new_dest_rest;	
	wire[10:0] button_input;
	wire vga_disp, vga_write, vga_clr ;
	wire global_clear, global_en, select_input_predecessor ;
	reg [4:0] source_addr, dest_addr, predecessor_addr;
	
	
	pll	pll_inst (
	.inclk0 ( CLOCK_50 ),
	.c0 ( vga_clk )
	);

	assign button_input = SW[10:0];
	assign sys_reset = KEY;
	assign new_dest_rest = {SW[5],KEY}; //{dest_inp_en,reset}
	
	pipelined_bellman_ford compute_stg(.clk(CLOCK_50), .clear(global_clear), .enable(global_en), 
															.stg1_mux_control(select_input_predecessor), .source_address(source_addr), 
															.predecessor_rd_addr(predecessor_addr), .predecessor_out(predecessor_out), .done(done_compute));
															
	module_display1 vga_module(.index_5(predecessor_addr),.write_en(vga_write),.FSM_clk(CLOCK_50),.clk_25(vga_clk),.clr(vga_clr),.display_on(vga_disp),
								.hsync(hsync),.vsync(vsync),.red(red),.green(green), .blue(blue)  ); 
								
//Output logic
assign LEDR = (present_state == START) || (present_state == INIT) || (present_state == COMPUTE);
assign LEDG = (present_state == DEST_INP) || (present_state == DEST_READ) || (present_state == RECURSION);
assign vga_disp = (present_state == VGA_DISP) ;
assign vga_write = (present_state == DEST_INP) || (present_state == DEST_READ) || (present_state == RECURSION);
assign vga_clr = (present_state == DEST_INP) ;
assign global_clear = (present_state == INIT) ;
assign global_en = (present_state == COMPUTE) ;
assign select_input_predecessor = (present_state == DEST_READ) || (present_state == RECURSION) ;

always@(*) begin
	case(present_state)
			START:  begin										
						source_addr = 5'b00000;
						dest_addr = 5'b00000;
						predecessor_addr = 5'b00000;					
				    end
			INIT:		begin					
						source_addr = button_input[4:0];
						predecessor_addr = 5'b00000;
						dest_addr = 5'b00000;
						end
			COMPUTE:		begin
							source_addr = button_input[4:0];							
							dest_addr = 5'b00000;
							predecessor_addr = 5'b00000;
							end
			DEST_INP:	begin
							dest_addr = button_input[10:6]; // destination 
							source_addr = button_input[4:0];							
							predecessor_addr = 5'b00000;
							end
			DEST_READ:	begin							
							source_addr = button_input[4:0];
							dest_addr = button_input[10:6];
							predecessor_addr = dest_addr;													
							end
			RECURSION:begin						
						    source_addr = button_input[4:0];
							dest_addr = button_input[10:6];
							
							if(predecessor_out!=source_addr)
								begin								
								predecessor_addr = predecessor_out;
								end								
							else 
								begin
								predecessor_addr = source_addr;
								end
							
							if(predecessor_out == 5'd0) 
								begin
								predecessor_addr = source_addr;
								end
						  end
			VGA_DISP:begin
						    source_addr = button_input[4:0];							
							dest_addr = button_input[10:6];
							predecessor_addr = 5'b00000;
						end
						
			default:	begin										
						source_addr = 5'b00000;
						dest_addr = 5'b00000;
						predecessor_addr = 5'b00000;					
						end
			endcase
end
								
//Synchronous state transition	
	always@(posedge CLOCK_50) begin
			if(!sys_reset) 
			present_state <= START;
	 else 
			present_state <= next_state;
	end

// State transition logic
	always@(*) begin	
	    next_state = present_state;
		case(present_state)
			START:  begin																
						if(button_input[5])
							next_state = INIT;
						else 
							next_state = START;							
				    end
			INIT:	begin										
						next_state = COMPUTE;							
					end
			COMPUTE:	begin
							if(done_compute) begin
												next_state = DEST_INP;
											end								
							else
								next_state = COMPUTE;		
								
						end
			DEST_INP:	begin			
							if(!button_input[5])
								next_state = DEST_READ;
							else
								next_state = DEST_INP;							
						end
			DEST_READ:	begin														
							next_state = RECURSION;								
						end
			RECURSION:	begin
							
							if(predecessor_out!=source_addr)
								begin								
								next_state = RECURSION;
								end								
							else 
								begin
								next_state = VGA_DISP; 
								end
							if(predecessor_out == 5'd0) 
								begin
								next_state = VGA_DISP;
								end
								
						   end
			VGA_DISP:	begin
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