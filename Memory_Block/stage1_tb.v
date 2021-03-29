`timescale 1ns/1ps

module stage1_tb;

reg clk, clear, enable;
wire [13:0] output1,output2, output3, output4;


stage1 topmodule ( clk, clear , enable, output1, output2, output3, output4); 

initial begin 
 clk = 0;
 clear = 1;
 enable = 0;
 forever #10 clk = ~clk;
 
 end
 
 initial begin   
  #25 clear = 0;
  #25 enable = 1;
  #1000 $finish();
  
 end
 
endmodule