//*********************************************  VGA Module ******************************************
module module_display(index_5,write_en,FSM_clk,clk_25,clr,display_on,hsync,vsync,red,green,blue);
input [4:0] index_5;
input wire write_en,FSM_clk,clr,display_on,clk_25;
output hsync,vsync;
output reg [2:0]  red,green;
output reg [1:0] blue;
wire [4:0]index_bar;
wire update_signal,clr_vga;
wire [15:0] k;
reg [0:0] graph[0:19199];

initial
begin
$readmemb("graph_1D.mif",graph);
end
assign clr_vga=1'b0;

display_unit D1(index_5,write_en,FSM_clk,clr,display_on,index_bar,update_signal);
vga_controller V1 (clk_25,clr_vga,hsync,vsync,k);
encoder E1(k,index_bar);
always@(posedge clk_25)
begin
	
	
	
	red<={3{graph[k]|update_signal}};
	green<={3{graph[k]|update_signal}};
	blue<={2{graph[k]|update_signal}};
	
end
endmodule