//TestBench :(
`timescale 1 ns/ 1ps
module TestBench;
reg [4:0] index_5;
reg write_en,FSM_clk,clk_50,clr,display_on;
wire hsync,vsync;
wire [2:0] red,green;
wire [1:0] blue;
module_display1 MM(index_5,write_en,FSM_clk,clk_50,clr,display_on,hsync,vsync,red,green,blue);
initial
begin
index_5=5'b00000;
write_en=0;
FSM_clk=1;
clk_50=1;
display_on=0;
clr=0;
end
always
begin
#50;
FSM_clk<=~FSM_clk;
end
always
begin
#10;
clk_50<=~clk_50;
end
initial
begin
#25;
clr=1;
#100;
index_5=5'b00001;
#50;
clr=0;
#50;
index_5=5'b00010;
#50
write_en=1;
#50;
index_5=5'b00011;
#85;
write_en=0;
#15;
index_5=5'b00100;
#150;
display_on=1;
end
endmodule
