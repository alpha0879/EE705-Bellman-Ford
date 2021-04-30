`timescale 1ns/100ps
module tb_FSM;

reg clk, KEY = 0;
reg [10:0] SW = 10'd0;
wire LEDR, LEDG ,hsync, vsync;
wire [2:0] red , green;
wire [1:0] blue;

FSM FSM_dut(clk, KEY, SW, LEDR, LEDG, hsync, vsync, red , green, blue);

always #10 clk = ~clk;
initial
//#252000000 $finish;
#6000 $finish;
initial begin
	clk = 0;
	
	SW[4:0] = 5'd1;//00111
	//#15;
	#100;
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
	#15;
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