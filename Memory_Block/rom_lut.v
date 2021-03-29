/*
  ROM - LOOK UP TABLE
  OUT1 OUT2 OUT3 OUT4 REPRESENTS THE 4 OUTPUTS READ AT A TIME 
  OUT[13:10] DEPICTS W(I,J)
  OUT[9:5] DEPICTS I
  OUT [4:0] DEPICTS J
*/

module rom_lut ( pointer, out1, out2, out3, out4, mem_is_zero );
 
// input read_enable;
 input [4:0] pointer;

 output reg [13:0] out1, out2, out3, out4;
 output mem_is_zero;
 
 reg [13:0] rom_lut [0:31];
 
 initial 
  begin 
     out1 = 0;
	 out2 = 0;
	 out3 = 0;
	 out4 = 0;
  end
  
  initial begin 
    $readmemb ("rom_input.mif",rom_lut);
  end
  
  always @(*) begin 
   //if (read_enable ) begin 
      out1 = rom_lut[pointer];
	  out2 = rom_lut[pointer+1];
	  out3 = rom_lut[pointer+2];
	  out4 = rom_lut[pointer+3];
	//end
  end
  
  assign mem_is_zero = ( rom_lut[pointer+4] == 14'b0 ) ? 1 : 0;
  
endmodule
  