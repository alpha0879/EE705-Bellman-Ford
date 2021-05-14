`define ADDRESS_LEN 5 
`define NODE_WEIGHT_BITSIZE 7
`define MEMORYWORD_BITSIZE 12 
`define REG_SIZE 32 

module regFile_tb;
  reg clk, rst, wr_en0, wr_en1, wr_en2, wr_en3;
  reg [`ADDRESS_LEN-1:0] sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3;
  reg [`MEMORYWORD_BITSIZE-1:0] w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3;
  wire [`NODE_WEIGHT_BITSIZE-1:0] w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3;
  wire [`MEMORYWORD_BITSIZE-1:0] w_i_pred0;

  regFile uut (clk, rst, sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3, 
w_i_pred0, w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3 , w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3, wr_en0, wr_en1, wr_en2, wr_en3);
	
	initial
	begin   
	   rst <= 1'b1;
	   sourceaddr <= 5'b00011;	   
	   #12;
	   
	   rst <= 1'b0; 
	   readaddr_j0 <= 5'b00000;
	   readaddr_j1 <= 5'b00001;
	   readaddr_j2 <= 5'b00010;
	   readaddr_j3 <= 5'b00011;
	   writeaddr_j0 <= 5'b00000;
	   writeaddr_j1 <= 5'b00001;
	   writeaddr_j2 <= 5'b00010;
	   writeaddr_j3 <= 5'b00011;
	   
	   wr_en0 <= 1'b1;
	   wr_en1 <= 1'b0;
	   wr_en2 <= 1'b1;
	   wr_en3 <= 1'b1;
	   
	   w_j_pred0 <= 12'b100111110101;
	   w_j_pred1 <= 12'b011110010101;
	   w_j_pred2 <= 12'b111010000111;
	   w_j_pred3 <= 12'b000000110010;
	   #10;
	   
	   writeaddr_j0 <= 5'b00100;
	   writeaddr_j1 <= 5'b00101;
	   writeaddr_j2 <= 5'b00110;
	   writeaddr_j3 <= 5'b00111;
	   
	   wr_en0 <= 1'b1;
	   wr_en1 <= 1'b1;
	   wr_en2 <= 1'b1;
	   wr_en3 <= 1'b1;
	   
	   w_j_pred0 <= 12'b011101011101;
	   w_j_pred1 <= 12'b111001110111;
	   w_j_pred2 <= 12'b100011010101;
	   w_j_pred3 <= 12'b000110010011;
	   #10;
	    
	   readaddr_i0 <= 5'b00100;
	   readaddr_i1 <= 5'b00101;
	   readaddr_i2 <= 5'b00110;
	   readaddr_i3 <= 5'b00111;
	   readaddr_j0 <= 5'b00000;
	   readaddr_j1 <= 5'b00001;
	   readaddr_j2 <= 5'b00010;
	   readaddr_j3 <= 5'b00011;
	   #10;
	   
	   
	end
	
    always 
	  begin
		 clk = 1'b1; 
		 #5; 

		 clk = 1'b0;
		 #5; 
	end
endmodule // regFile