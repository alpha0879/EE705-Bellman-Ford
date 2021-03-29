module stage1 ( clk, clear , enable, output1, output2, output3, output4); 

 input clk;
 input clear;
 input enable;
 output [13:0] output1, output2, output3, output4;
 
 wire [4:0] pointer;
 wire clear_or_zero;
 wire mem_is_zero;
 
 /* initial 
  begin 
     output1 = 0;
	 output2 = 0;
	 output3 = 0;
	 output4 = 0;
  end*/
  
  assign clear_or_zero = clear | mem_is_zero ;
  
  program_counter pc (clk, clear_or_zero, enable, pointer );
  rom_lut mem1 ( pointer, output1, output2, output3, output4, mem_is_zero );
 
 endmodule