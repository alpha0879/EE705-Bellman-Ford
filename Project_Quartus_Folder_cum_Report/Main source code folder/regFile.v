`define ADDRESS_LEN 5 
`define NODE_WEIGHT_BITSIZE 7
`define MEMORYWORD_BITSIZE 12 
`define REG_SIZE 32 

module regFile (clk, rst, sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3, 
w_i_pred0, w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3 , w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3, wr_en0, wr_en1, wr_en2, wr_en3);
  input clk, rst, wr_en0, wr_en1, wr_en2, wr_en3;
  input [`ADDRESS_LEN-1:0] sourceaddr, readaddr_i0, readaddr_i1, readaddr_i2, readaddr_i3, readaddr_j0, readaddr_j1, readaddr_j2, readaddr_j3 , writeaddr_j0, writeaddr_j1, writeaddr_j2, writeaddr_j3;
  input [`MEMORYWORD_BITSIZE-1:0] w_j_pred0, w_j_pred1, w_j_pred2, w_j_pred3;
  output [`NODE_WEIGHT_BITSIZE-1:0] w_i1, w_i2, w_i3, w_j0, w_j1, w_j2, w_j3; 
  output [`MEMORYWORD_BITSIZE-1:0] w_i_pred0; // This is 12 bit wide memory word which includes w[i] and predecessor , predecessor is required to be read during recursive read stage

  reg [`MEMORYWORD_BITSIZE-1:0] regMem [0:`REG_SIZE-1];
  integer i;

  always @ (posedge clk) begin
    if (rst) begin
      for (i = 0; i < `REG_SIZE; i = i + 1)
		if ( i == sourceaddr )
			regMem[i] <= {`MEMORYWORD_BITSIZE{1'b0}}; // sourceaddr which is read from the user at the start stage of FSM and the corresponding memory word is set 0 as per bell man ford algorithm
		else
			regMem[i] <= { 1'b1, {`MEMORYWORD_BITSIZE-1{1'b0}}};
	end
    else begin
		if (wr_en0) begin 
			regMem[writeaddr_j0] <= w_j_pred0;
		end
		if (wr_en1) begin 
			regMem[writeaddr_j1] <= w_j_pred1;
		end
		if (wr_en2) begin	
			regMem[writeaddr_j2] <= w_j_pred2;
		end
		if (wr_en3) begin
			regMem[writeaddr_j3] <= w_j_pred3;
		end
	end
  end

  assign w_i_pred0 = (regMem[readaddr_i0]); // 12 bit wide memory word read for accessing predecessor at recursive read stage
  assign w_i1 = (regMem[readaddr_i1][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_i2 = (regMem[readaddr_i2][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_i3 = (regMem[readaddr_i3][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j0 = (regMem[readaddr_j0][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j1 = (regMem[readaddr_j1][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j2 = (regMem[readaddr_j2][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
  assign w_j3 = (regMem[readaddr_j3][`MEMORYWORD_BITSIZE-1 -: `NODE_WEIGHT_BITSIZE]);
endmodule // regFile