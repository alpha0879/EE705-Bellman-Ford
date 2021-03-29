//corresponding to p=4
module sorting_block(A,B,C,D,A_new,B_new,C_new,D_new);
input wire [20:0] A,B,C,D;//21 bit word, no update signal
output wire[21:0] A_new,B_new,C_new,D_new;
wire [21:0] A_,B_,C_,D_;//22 bit word, with update signal added
wire [21:0] temp [0:7];
assign A_={1'b1,A};
assign B_={1'b1,B};
assign C_={1'b1,C};
assign D_={1'b1,D};
bitonic_sort C1(A_,B_,temp[0],temp[1]);
bitonic_sort C2(C_,D_,temp[2],temp[3]);
bitonic_sort C3(temp[0],temp[2],temp[4],temp[5]);
bitonic_sort C4(temp[1],temp[3],temp[6],temp[7]);
bitonic_sort C5(temp[4],temp[6],A_new,B_new);
bitonic_sort C6(temp[5],temp[7],C_new,D_new);
endmodule

module bitonic_sort(A,B,LT,GT);
//For A,B,LT,GT
//6:0-->W[i]
//11:7-->index j
//16:12---->index i
//20:17---->W[i,j]
//21----->update signal
input wire [21:0] A,B;//21th bit is update signal: 1 means valid update
output reg[21:0] LT,GT;
reg [6:0] W_A,W_B;
always@(A,B)
begin//start of always
if (A[21]==1'b1 && B[21]==1'b1)//update signals are equla and are 1
	begin
	if(A[11:7]==B[11:7])
		begin
		W_A={3'b000,A[20:17]}+A[6:0];
		W_B={3'b000,B[20:17]}+B[6:0];
		if(W_A<W_B)
			begin
			LT=A[21:0];
			GT={1'b0,B[20:0]};
			end
		else
			begin
			LT=B[21:0];
			GT={1'b0,A[20:0]};
			end
		end
	else if(A[11:7]<B[11:7])
		begin 
		LT=A[21:0];
		GT=B[21:0];
		end
	else
		begin
		LT=B[21:0];
		GT=A[21:0];
		end
	
	end
	else if(A[21]==1'b1 && B[21]==1'b0)
		begin
		LT=A[21:0];
		GT=B[21:0];
		end
	else if(A[21]==1'b0 && B[21]==1'b1)
		begin
		LT=B[21:0];
		GT=A[21:0];
		end
	else
		begin
		LT=A[21:0];
		GT=B[21:0];
		end
		
	
end//end of always
endmodule 
