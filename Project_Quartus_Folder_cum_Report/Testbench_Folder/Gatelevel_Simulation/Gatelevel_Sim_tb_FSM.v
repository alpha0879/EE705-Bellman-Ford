`timescale 1ns/100ps
module tb_FSM;

	reg clk, KEY = 0;
	reg [10:0] SW = 10'd0;
	wire LEDR, LEDG ,hsync, vsync;
	wire [2:0] red , green;
	wire [1:0] blue;

	wire watch_vga_clk;
	wire watch_sys_reset;
	wire watch_done_compute;
	wire [1:0] watch_new_dest_rest;
	wire watch_global_clear;
	wire watch_global_en;
	wire watch_select_input_predecessor;
	wire [2:0] watch_present_state;
	wire [4:0] watch_source_addr; 
	wire [4:0] watch_dest_addr;
    wire [4:0] watch_predecessor_addr;
	wire watch_vga_disp;
	wire watch_vga_write;
    wire watch_vga_clr;

FSM FSM_dut(clk, KEY, SW, LEDR, LEDG, hsync, vsync, red , green, blue ,
		watch_vga_clk, watch_sys_reset, watch_done_compute, watch_new_dest_rest,
		watch_global_clear, watch_global_en, watch_select_input_predecessor , watch_present_state,
		watch_source_addr, watch_dest_addr, watch_predecessor_addr,
		watch_vga_disp, watch_vga_write, watch_vga_clr);

always #10 clk = ~clk;
initial
//#252000000 $finish;
#6000 $finish;
initial begin
	clk = 0;
	
	SW[4:0] = 5'd1;//00111
	#25;
	//#100;
	KEY = 1'b0; #20; KEY = 1'b1;
	#50;
	
	SW[5] = 1'b1;	
	@(LEDG)begin
		if(LEDG == 1)
			SW[10:6] = 5'd7;
		end
	//#20;
	#50;
	SW[5]=0;
	@(LEDG) begin
	 if(LEDG==0)begin
		//#250000000;
		#60;
		SW[5] = 1;
		end
	end
	
	//SW[5] = 1;
	@(LEDG) begin
	if(LEDG == 1)
		SW[10:6] = 5'd12;
		end
	#40;
	SW[5]=0;
	
	@(LEDG) begin
		if(LEDG==0) begin
		//#252000000;
		#50;
		KEY = 1'b0;
		end
	end
	
	SW[4:0] = 5'd9;//00111
	#25;
	KEY = 1'b0; #20; KEY = 1'b1;
	#50;
	SW[5] = 1'b1;
	
	@(LEDG)begin
		if(LEDG == 1)
			SW[10:6] = 5'd2;
		end
	#40;
	SW[5]=0;
	
	@(LEDG) begin
		if(LEDG==0) begin
		//#252000000;
		#50;
		KEY = 1'b0;
		end
	end					
	
	
end

endmodule