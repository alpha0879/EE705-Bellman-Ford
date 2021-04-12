
module program_counter (clk,clear,enable,count);

input clk;
input clear;
input enable;
output reg [4:0] count = 0;


always @(posedge clk) begin
 
 if (clear) count <= 4'b0;
 else if ( enable )
  begin
	count <= count + 5'd4;
  end
 end

endmodule
 