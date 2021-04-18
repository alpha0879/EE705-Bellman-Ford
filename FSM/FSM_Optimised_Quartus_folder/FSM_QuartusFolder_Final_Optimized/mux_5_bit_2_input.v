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