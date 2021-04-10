`timescale 1us/1ns

module pipelined_bellman_ford_tb;

reg clk, clear, enable, stg1_mux_control;
reg[4:0] source_address, predecessor_rd_addr;
wire [4:0] predecessor_out;
wire done;
//wire [17:0] compute_outa, compute_outb, compute_outc, compute_outd;


pipelined_bellman_ford uut (clk, clear, enable, stg1_mux_control, source_address, predecessor_rd_addr, predecessor_out, done );

always #10 clk = ~clk;

initial begin 
 clk = 0;
 source_address = 5'd1;
 predecessor_rd_addr = 5'd0;
 
 enable = 0;
 clear = 1;
 stg1_mux_control = 0;
 
 #25 clear = 0;
 enable = 1;
 end
 
endmodule