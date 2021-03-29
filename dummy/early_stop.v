// early stopping 
// UP=up1| up2|up3|up4;
//make sure that addr is an externalsignal
// remove the delays :/
 `timescale 1 ns / 1 ps
module early_stop(UP,clk,clr,/*,addr*/,done,xyz);
input wire UP,clk,clr;
reg [4:0] addr=5'b11100;
output reg done=0;
output wire[5:0] xyz;
reg [5:0] count=6'b000001;

assign xyz=count;

always@(posedge clk)
begin
if (clr)
begin
#3;
addr=0;
end
else
begin
#3;
addr=addr+4;
end
end

always@(posedge clk)
begin
if (clr)
begin
done=0;
count=1;
end
else if (addr==5'b00000)
	begin
	if (count!=0)
		done=0;
	else
		done=1;
	if (UP)
	count=1;
	else
	count=0;
	end
else if(UP)
	count=count+6'b000001;
	
end
endmodule
 `timescale 1 ns / 1 ps
 module tb_early_stop;
 reg tclr,tclk,tUP;
 wire [5:0]xyz;
 wire tdone;
 early_stop e(tUP,tclk,tclr,/*,addr*/,tdone,xyz);
 initial 
 begin
 tclk=0;
 tUP=0;
 tclr=0;
end
 always
 begin
 #10;
 tclk<=~tclk;
 end
 initial
 begin
 #5;
 tclr=1;
 #60;
 tclr=0;
 #26;
 tUP=1;
 #60;
 tUP=0;
 #20;
 tUP=1;
 #40;
 tUP=0;
 #20;
 tUP=1;
 #40;
 tUP=0;
 end
 endmodule
 