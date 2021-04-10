//module 4--vga controller
//clk-->25MHz 
module vga_controller (clk,clr,hsync,vsync,k);
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
	wire vid_on;
	output reg [15:0] k=16'h0000;
	assign hsync=(hcs<128)?1'b0:1'b1;
	assign vsync=(vcs<2)?1'b0:1'b1;
	assign vid_on=((hcs>=hbp-1 && hcs<hfp-1)&& (vcs>=vbp &&vcs<vfp-1))?1'b1:1'b0;//-1 specifically for this

	always@(posedge clk)
	begin
		if(hcs==10'b0000000000 && vcs==10'b0000000000)
					k<=16'h0000;
		
				
		else if(hcs[1:0]==2'b00 && vcs[1:0]==2'b11 && vid_on==1'b1)
					k<=k+16'h0001;
			
		
	end

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