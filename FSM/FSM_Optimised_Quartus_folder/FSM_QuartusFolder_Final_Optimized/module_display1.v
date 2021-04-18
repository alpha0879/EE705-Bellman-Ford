
//module_display1 takes input_(5  bits input),write_en,clr, display_on from FSM;
//apart from that it takes 2 clks 50MHz and FSM clk
//output generated are hsync, vsync , red[2:0],green[2:0],blue[1:0];-->to be given to topmost level entity

module module_display1(index_5,write_en,FSM_clk,clk_25,clr,display_on,hsync,vsync,red,green,blue);
input [4:0] index_5;
input wire write_en,FSM_clk,clr,display_on,clk_25;
output hsync,vsync;
output wire [2:0]  red,green;
output wire [1:0] blue;
wire [4:0]index_bar;
wire update_signal,clr_vga;
wire [15:0] k;//19 bits
wire vid_on;
reg [0:0] graph[0:62499];
wire signal;
assign signal=graph[k]|update_signal;
initial
begin
$readmemb("graph_1D.mif",graph);//graph_1D.mif contains graph of  size 250x250
end
assign clr_vga=1'b0;

display_unit D1(index_5,write_en,FSM_clk,clr,display_on,index_bar,update_signal);
//clk_divider CK_DIV(clk_50,clk_25);
vga_controller V1 (clk_25,clr_vga,hsync,vsync,k,vid_on);
encoder E1(k,index_bar);

	
	//What doe this means???
	//giving 111 to a particular channel will cause the maximum of that color ie, if red==111,blue=00, green=111, will cause  the screen to be red
	//giving all channel 000 will result in black
	//giving all channel the maximum value will result in white
	assign red=vid_on?{3{signal}}:3'b000;
	assign green=vid_on?{3{signal}}:3'b000;
	assign blue=vid_on?{2{signal}}:2'b00;

endmodule


module display_unit(index_5,write_en,FSM_clk,clr,display_on,index_bar,update_signal);
input [4:0] index_5;//5 bit value corresponding to nodes from FSM(writing address)
input write_en,FSM_clk,clr,display_on;//Most of them are from FSM
input [4:0] index_bar;//reading address from encoder block
output wire update_signal;
integer i;
reg [0:31] up=32'h7FFFFFFF;//it is initialised to all ones for demostration purpose
//FSM should clear this RAM before writing!!!!!
wire temp0,temp1;

assign temp0=up[index_bar];
assign update_signal=temp0 & display_on;//will print the original graph if display_on is zero , else it will show  markings on certain nodes depending upon is written to 32x1 RAM
//we can read the content of RAM asynchronously
//part 1
always@(posedge FSM_clk)//On posedge of FSM_clk, and clr has been asserted  with clear the entire RAM(32x1)
//At posedge of the clk when write_en is asserted  then we write 1 for corresponding index(mem address=index))

begin
	if(clr)
		begin
		for(i=0;i<32;i=i+1)
			begin
			up[i]<=1'b0;
			end
		end
	else if(write_en)
		begin
		up[index_5]<=1'b1;
		end
end
endmodule


//module 2

//This is a combinational block that converts  16 bits  index value to corresponding  5 bits index for nodes ; for remaining points(16 bits), the corresponding 5 bit value will be zero
//Here we map index to a point on node center(lets say it as x)and all other neighbours(8) of that point x.
//Any other point other than these points will have index value set to 0.
module encoder(input_16,output_5);
input [15:0]input_16;
output wire[4:0] output_5;
reg [4:0] index_bar;
assign output_5=index_bar;
always@(input_16)
begin
	case(input_16)//x+y*250 of the node   and it will give us the index corresponding to the particular nodes

16'b0010001110100111: index_bar=5'b00001;
16'b0010001110101000: index_bar=5'b00001;
16'b0010001110100110: index_bar=5'b00001;
16'b0010001010101101: index_bar=5'b00001;
16'b0010010010100001: index_bar=5'b00001;
16'b0010001010101110: index_bar=5'b00001;
16'b0010001010101100: index_bar=5'b00001;
16'b0010010010100010: index_bar=5'b00001;
16'b0010010010100000: index_bar=5'b00001;
16'b0001101000010010: index_bar=5'b00010;
16'b0001101000010011: index_bar=5'b00010;
16'b0001101000010001: index_bar=5'b00010;
16'b0001100100011000: index_bar=5'b00010;
16'b0001101100001100: index_bar=5'b00010;
16'b0001100100011001: index_bar=5'b00010;
16'b0001100100010111: index_bar=5'b00010;
16'b0001101100001101: index_bar=5'b00010;
16'b0001101100001011: index_bar=5'b00010;
16'b0001100110101101: index_bar=5'b00011;
16'b0001100110101110: index_bar=5'b00011;
16'b0001100110101100: index_bar=5'b00011;
16'b0001100010110011: index_bar=5'b00011;
16'b0001101010100111: index_bar=5'b00011;
16'b0001100010110100: index_bar=5'b00011;
16'b0001100010110010: index_bar=5'b00011;
16'b0001101010101000: index_bar=5'b00011;
16'b0001101010100110: index_bar=5'b00011;
16'b0100010100001010: index_bar=5'b00100;
16'b0100010100001011: index_bar=5'b00100;
16'b0100010100001001: index_bar=5'b00100;
16'b0100010000010000: index_bar=5'b00100;
16'b0100011000000100: index_bar=5'b00100;
16'b0100010000010001: index_bar=5'b00100;
16'b0100010000001111: index_bar=5'b00100;
16'b0100011000000101: index_bar=5'b00100;
16'b0100011000000011: index_bar=5'b00100;
16'b0011101111110011: index_bar=5'b00101;
16'b0011101111110100: index_bar=5'b00101;
16'b0011101111110010: index_bar=5'b00101;
16'b0011101011111001: index_bar=5'b00101;
16'b0011110011101101: index_bar=5'b00101;
16'b0011101011111010: index_bar=5'b00101;
16'b0011101011111000: index_bar=5'b00101;
16'b0011110011101110: index_bar=5'b00101;
16'b0011110011101100: index_bar=5'b00101;
16'b0011100110111111: index_bar=5'b00110;
16'b0011100111000000: index_bar=5'b00110;
16'b0011100110111110: index_bar=5'b00110;
16'b0011100011000101: index_bar=5'b00110;
16'b0011101010111001: index_bar=5'b00110;
16'b0011100011000110: index_bar=5'b00110;
16'b0011100011000100: index_bar=5'b00110;
16'b0011101010111010: index_bar=5'b00110;
16'b0011101010111000: index_bar=5'b00110;
16'b0110001011011011: index_bar=5'b00111;
16'b0110001011011100: index_bar=5'b00111;
16'b0110001011011010: index_bar=5'b00111;
16'b0110000111100001: index_bar=5'b00111;
16'b0110001111010101: index_bar=5'b00111;
16'b0110000111100010: index_bar=5'b00111;
16'b0110000111100000: index_bar=5'b00111;
16'b0110001111010110: index_bar=5'b00111;
16'b0110001111010100: index_bar=5'b00111;
16'b0110111011010100: index_bar=5'b01000;
16'b0110111011010101: index_bar=5'b01000;
16'b0110111011010011: index_bar=5'b01000;
16'b0110110111011010: index_bar=5'b01000;
16'b0110111111001110: index_bar=5'b01000;
16'b0110110111011011: index_bar=5'b01000;
16'b0110110111011001: index_bar=5'b01000;
16'b0110111111001111: index_bar=5'b01000;
16'b0110111111001101: index_bar=5'b01000;
16'b0111000000001000: index_bar=5'b01001;
16'b0111000000001001: index_bar=5'b01001;
16'b0111000000000111: index_bar=5'b01001;
16'b0110111100001110: index_bar=5'b01001;
16'b0111000100000010: index_bar=5'b01001;
16'b0110111100001111: index_bar=5'b01001;
16'b0110111100001101: index_bar=5'b01001;
16'b0111000100000011: index_bar=5'b01001;
16'b0111000100000001: index_bar=5'b01001;
16'b1001100111101111: index_bar=5'b01010;
16'b1001100111110000: index_bar=5'b01010;
16'b1001100111101110: index_bar=5'b01010;
16'b1001100011110101: index_bar=5'b01010;
16'b1001101011101001: index_bar=5'b01010;
16'b1001100011110110: index_bar=5'b01010;
16'b1001100011110100: index_bar=5'b01010;
16'b1001101011101010: index_bar=5'b01010;
16'b1001101011101000: index_bar=5'b01010;
16'b1000111101100100: index_bar=5'b01011;
16'b1000111101100101: index_bar=5'b01011;
16'b1000111101100011: index_bar=5'b01011;
16'b1000111001101010: index_bar=5'b01011;
16'b1001000001011110: index_bar=5'b01011;
16'b1000111001101011: index_bar=5'b01011;
16'b1000111001101001: index_bar=5'b01011;
16'b1001000001011111: index_bar=5'b01011;
16'b1001000001011101: index_bar=5'b01011;
16'b1011001010010000: index_bar=5'b01100;
16'b1011001010010001: index_bar=5'b01100;
16'b1011001010001111: index_bar=5'b01100;
16'b1011000110010110: index_bar=5'b01100;
16'b1011001110001010: index_bar=5'b01100;
16'b1011000110010111: index_bar=5'b01100;
16'b1011000110010101: index_bar=5'b01100;
16'b1011001110001011: index_bar=5'b01100;
16'b1011001110001001: index_bar=5'b01100;
16'b1101110001111111: index_bar=5'b01101;
16'b1101110010000000: index_bar=5'b01101;
16'b1101110001111110: index_bar=5'b01101;
16'b1101101110000101: index_bar=5'b01101;
16'b1101110101111001: index_bar=5'b01101;
16'b1101101110000110: index_bar=5'b01101;
16'b1101101110000100: index_bar=5'b01101;
16'b1101110101111010: index_bar=5'b01101;
16'b1101110101111000: index_bar=5'b01101;
16'b1100001111101111: index_bar=5'b01110;
16'b1100001111110000: index_bar=5'b01110;
16'b1100001111101110: index_bar=5'b01110;
16'b1100001011110101: index_bar=5'b01110;
16'b1100010011101001: index_bar=5'b01110;
16'b1100001011110110: index_bar=5'b01110;
16'b1100001011110100: index_bar=5'b01110;
16'b1100010011101010: index_bar=5'b01110;
16'b1100010011101000: index_bar=5'b01110;
16'b1101111101000000: index_bar=5'b01111;
16'b1101111101000001: index_bar=5'b01111;
16'b1101111100111111: index_bar=5'b01111;
16'b1101111001000110: index_bar=5'b01111;
16'b1110000000111010: index_bar=5'b01111;
16'b1101111001000111: index_bar=5'b01111;
16'b1101111001000101: index_bar=5'b01111;
16'b1110000000111011: index_bar=5'b01111;
16'b1110000000111001: index_bar=5'b01111;
16'b1011011000100010: index_bar=5'b10000;
16'b1011011000100011: index_bar=5'b10000;
16'b1011011000100001: index_bar=5'b10000;
16'b1011010100101000: index_bar=5'b10000;
16'b1011011100011100: index_bar=5'b10000;
16'b1011010100101001: index_bar=5'b10000;
16'b1011010100100111: index_bar=5'b10000;
16'b1011011100011101: index_bar=5'b10000;
16'b1011011100011011: index_bar=5'b10000;
16'b1101100000110101: index_bar=5'b10001;
16'b1101100000110110: index_bar=5'b10001;
16'b1101100000110100: index_bar=5'b10001;
16'b1101011100111011: index_bar=5'b10001;
16'b1101100100101111: index_bar=5'b10001;
16'b1101011100111100: index_bar=5'b10001;
16'b1101011100111010: index_bar=5'b10001;
16'b1101100100110000: index_bar=5'b10001;
16'b1101100100101110: index_bar=5'b10001;
16'b1100110100111100: index_bar=5'b10010;
16'b1100110100111101: index_bar=5'b10010;
16'b1100110100111011: index_bar=5'b10010;
16'b1100110001000010: index_bar=5'b10010;
16'b1100111000110110: index_bar=5'b10010;
16'b1100110001000011: index_bar=5'b10010;
16'b1100110001000001: index_bar=5'b10010;
16'b1100111000110111: index_bar=5'b10010;
16'b1100111000110101: index_bar=5'b10010;
16'b1011001111111100: index_bar=5'b10011;
16'b1011001111111101: index_bar=5'b10011;
16'b1011001111111011: index_bar=5'b10011;
16'b1011001100000010: index_bar=5'b10011;
16'b1011010011110110: index_bar=5'b10011;
16'b1011001100000011: index_bar=5'b10011;
16'b1011001100000001: index_bar=5'b10011;
16'b1011010011110111: index_bar=5'b10011;
16'b1011010011110101: index_bar=5'b10011;
16'b1010100100001110: index_bar=5'b10100;
16'b1010100100001111: index_bar=5'b10100;
16'b1010100100001101: index_bar=5'b10100;
16'b1010100000010100: index_bar=5'b10100;
16'b1010101000001000: index_bar=5'b10100;
16'b1010100000010101: index_bar=5'b10100;
16'b1010100000010011: index_bar=5'b10100;
16'b1010101000001001: index_bar=5'b10100;
16'b1010101000000111: index_bar=5'b10100;
16'b0111000001100011: index_bar=5'b10101;
16'b0111000001100100: index_bar=5'b10101;
16'b0111000001100010: index_bar=5'b10101;
16'b0110111101101001: index_bar=5'b10101;
16'b0111000101011101: index_bar=5'b10101;
16'b0110111101101010: index_bar=5'b10101;
16'b0110111101101000: index_bar=5'b10101;
16'b0111000101011110: index_bar=5'b10101;
16'b0111000101011100: index_bar=5'b10101;
16'b1000110011100100: index_bar=5'b10110;
16'b1000110011100101: index_bar=5'b10110;
16'b1000110011100011: index_bar=5'b10110;
16'b1000101111101010: index_bar=5'b10110;
16'b1000110111011110: index_bar=5'b10110;
16'b1000101111101011: index_bar=5'b10110;
16'b1000101111101001: index_bar=5'b10110;
16'b1000110111011111: index_bar=5'b10110;
16'b1000110111011101: index_bar=5'b10110;
16'b1001011011010100: index_bar=5'b10111;
16'b1001011011010101: index_bar=5'b10111;
16'b1001011011010011: index_bar=5'b10111;
16'b1001010111011010: index_bar=5'b10111;
16'b1001011111001110: index_bar=5'b10111;
16'b1001010111011011: index_bar=5'b10111;
16'b1001010111011001: index_bar=5'b10111;
16'b1001011111001111: index_bar=5'b10111;
16'b1001011111001101: index_bar=5'b10111;
default : index_bar=5'b00000;
endcase



end
endmodule

//module 3 clk divider; We have 50Mhz and we need to get 25 MHz
//In case if we plan to use PLL IP, then  consider removing this one!!! :/
/*module clk_divider(clk_in,clk_out);//tested: working
input wire clk_in;
output wire clk_out;
reg c_out=1'b0;

assign clk_out=c_out;
always@(posedge clk_in)
begin
	c_out<=~c_out;
end
endmodule */

//module 4--vga controller
//We need 25MHz fo this module !!!!!!!!
module vga_controller (clk,clr,hsync,vsync,k,vid_on);
input wire  clk,clr;
output wire hsync,vsync;
parameter [9:0] h_pixels=10'b1100100000;//800
parameter [9:0] v_lines=10'b1000001001;//521
parameter [9:0] hbp=10'b0010010000;//144
parameter [9:0] hfp=10'b1100010000;//784
parameter [9:0] vbp=10'b0000011111;//31
parameter [9:0] vfp=10'b0111111111;//511
reg vsenable=1'b0;

reg  [9:0]  hcs=10'b0000000000;
reg  [9:0]  vcs=10'b0000000000;
output reg vid_on;
output reg [15:0] k=16'b1111111111111111;//initialised kas the max value
//k=250*y+x and k increments only in  250x250 active region

assign hsync=(hcs<128)?1'b0:1'b1;//Refer the working of VGA
assign vsync=(vcs<2)?1'b0:1'b1;

always@(posedge clk)
begin

	if(hcs==10'b0000000000 && vcs==10'b0000000000)
	begin
				k=16'b1111111111111111;//initialse the k as maximum
				vid_on<=0;// make sure that default value of zero is printed(ie black color, if all 3 channels are given 0 input)
				
			end
	else if( (hcs>=hbp && hcs<=393)&& (vcs>=vbp &&vcs<=280) )
			begin	
				k<=k+1;//in the active region 250x250, we will increment k and set vid_on=1
				//k goes from 0 to 62499 
				vid_on<=1;
				end
	else
		vid_on<=0;// for region out side the active region k will remain the same value but vid_on=0, so zeros will be shown on display
		
end
//using clk to track  count horizontal index and vertical index
always@(posedge clk or posedge clr)
begin
	if(clr)
	
	begin
	hcs<=10'b0000000000;
	vsenable<=0;
	end
	
	else if (hcs==h_pixels-2)
	begin
	hcs<=hcs+10'b0000000001;
	vsenable<=1;
	end
	
	else if (hcs==h_pixels-1)
	begin
	hcs<=10'b0000000000;
	vsenable<=0;
	end
	
	else 
	begin
	hcs<=hcs+10'b0000000001;
	vsenable<=0;
	end
	end

always@(posedge clk or posedge clr)
begin
	if(clr)
	vcs<=10'b0000000000;
	else if (vsenable==1)
	begin
		if (vcs==v_lines-1) 
			vcs<=10'b0000000000;
		else
			vcs<=vcs+10'b0000000001;
		end
end
endmodule
