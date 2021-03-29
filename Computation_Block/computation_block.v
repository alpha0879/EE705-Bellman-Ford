
module computation_block(mem_w0,mem_w1,mem_w2,mem_w3,out0,out1,out2,out3);

input wire [28:0] mem_w0,mem_w1,mem_w2,mem_w3;
output wire [17:0] out0,out1,out2,out3;
compute comp0 (mem_w0,out0);
compute comp1 (mem_w1,out1);
compute comp2 (mem_w2,out2);
compute comp3 (mem_w3,out3);

endmodule


module compute(A_in,A_out);
//For A_in
//6:0--->W[j]
//13:7--->W[i]
//18:14--->index j
//23:19--->index i
//27:24---->W[i,j]
//28---->update

//For A_out
//6:0--->W[j]
//11:7--->index j
//16:12-->index i
//17---->update signal
input wire [28:0] A_in;
output reg[17:0] A_out;
wire [6:0] relaxation;
assign relaxation={3'b000,A_in[27:24]}+A_in[13:7];
always@(A_in,relaxation)
begin
	if (A_in[28]==1'b1)
		begin
		if (relaxation<A_in[6:0])
			begin
			A_out[6:0]=relaxation;
			A_out[17]=1'b1;
			end
		else
			begin
			A_out[6:0]=A_in[6:0];
			A_out[17]=1'b0;
			end
		end
	else
		   begin
			A_out[6:0]=A_in[6:0];
			A_out[17]=1'b0;
		   end
	
	A_out[11:7]=A_in[18:14];
	A_out[16:12]=A_in[23:19];
	end
endmodule
//Test bench of compute
`timescale 1 ns/1 ps
module tb_compute;
reg [28:0] TA_in;
wire [17:0] TA_out;
compute com(TA_in,TA_out);
initial 
begin
#20;
TA_in<=29'b10010110110010000110111001111;//result should be 111011001000011101
#20;
TA_in<=29'b00010110110010000110111001111;//result should be 011011001001001111
#20;
TA_in<=29'b10010110110010000110110001111;//result should be 011011001000001111
#20;
TA_in<=29'b00010110110010000110110001111;//result should be 011011001000001111
#20;

end
endmodule
