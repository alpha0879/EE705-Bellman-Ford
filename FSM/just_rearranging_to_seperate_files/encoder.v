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
