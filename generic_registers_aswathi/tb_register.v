`timescale 1 ns / 100 ps
module tb_register;

reg clk=0;
reg [7:0]in_data1,in_data2,in_data3,in_data4;
wire [7:0] out_data1,out_data2,out_data3,out_data4;

register dut (clk,in_data1,in_data2,in_data3,in_data4,out_data1,out_data2,out_data3,out_data4);

always begin
  #1 clk = ~clk;
end 
initial begin
   in_data1 = 8'hff;
   in_data2= 8'hAB;
   in_data3 = 8'hCD;
   in_data4 = 8'h23;
   
   #10;
   in_data1 = 8'h20;
end 					  
 initial #20 $finish;				  
endmodule