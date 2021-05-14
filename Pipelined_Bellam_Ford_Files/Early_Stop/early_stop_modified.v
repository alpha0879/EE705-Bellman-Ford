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
 