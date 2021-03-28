module register #(parameter WORD_SIZE = 8)
					  (input clk,
					   input [WORD_SIZE-1:0] in_data1,in_data2,in_data3,in_data4,
					   output reg [WORD_SIZE-1:0] out_data1,out_data2,out_data3,out_data4);

always@(posedge clk) begin
			out_data1=in_data1;
			out_data2=in_data2;
			out_data3=in_data3;
			out_data4=in_data4;
		end
endmodule