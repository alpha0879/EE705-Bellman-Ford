`timescale 1ns/100ps
module tb_FSM_V2;

reg clk, KEY;
reg [5:0] SW;
wire LEDR, LEDG;

FSM FSM_dut(clk, KEY, SW, LEDR, LEDG);


always #10 clk = ~clk;
initial
#252000000 $finish;
//#6000 $finish;
initial begin
	clk = 0;
	
	//SW[4:0] = 5'd1;
	SW[4:0] = 5'd1;//00111
	#15;
	KEY = 1'b0; #20; KEY = 1'b1;
	#50;
	
	SW[5] = 1'b1;	
	@(LEDG)begin
		if(LEDG == 1)
			SW[4:0] = 5'd7;
		end
	#20;
	SW[5]=0;
	@(LEDG) begin
	 if(LEDG==0)begin
		#250000000;
		SW[5] = 1;
		end
	end
	
	//SW[5] = 1;
/*	@(LEDG) begin
	if(LEDG == 1)
		SW[4:0] = 5'd12;
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
	
	SW[4:0] = 5'd6;//00111
	#15;
	KEY = 1'b0; #20; KEY = 1'b1;
	#50;
	SW[5] = 1'b1;
	
	@(LEDG)begin
		if(LEDG == 1)
			SW[4:0] = 5'd7;
		end
	#40;
	SW[5]=0;
	
	@(LEDG) begin
		if(LEDG==0) begin
		//#252000000;
		#50;
		KEY = 1'b0;
		end
	end					*/
	
	
end

endmodule