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