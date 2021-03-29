module forwardblock(inp_1,inp_2,inp_3,inp_4,inpf_1,inpf_2,inpf_3,inpf_4, out_1,out_2,out_3,out_4);

  input[28:0] inp_1,inp_2,inp_3,inp_4; // up(1)[28],wij(4)[27:24], i(5)[23:19], j(5)[18:14], wi(7)[13:7], wj(7)[6:0] -- input mem word
  input[17:0] inpf_1,inpf_2,inpf_3,inpf_4; // up(1)[17], i(5)[16:12], j(5)[11:7], wj(7)[6:0]  ---  forwarded mem word
  output reg [28:0] out_1,out_2,out_3,out_4; //up(1),wij(4), i(5), j(5), wi(7), wj(7)
  
  reg [28:0] inp_array[0:3];
  reg [17:0] inpf_array[0:3];
  integer i,j;

  always@(*) begin
	 inp_array[0] = inp_1;
	 inp_array[1] = inp_2;
	 inp_array[2] = inp_3;
	 inp_array[3] = inp_4;
	   
     inpf_array[0] = inpf_1;
	 inpf_array[1] = inpf_2;
	 inpf_array[2] = inpf_3;
     inpf_array[3] = inpf_4;
	 
	 for (i=0; i<=3; i=i+1) begin  // forwarded word
		for(j=0;j<=3; j=j+1) begin // Input word 
		  if((inpf_array[i][17]&& inp_array[j][28]) && (inpf_array[i][11:7] == inp_array[j][18:14])) begin
		     inp_array[j][6:0] = inpf_array[i][6:0]; 
		  end
		  if(inpf_array[i][11:7] == inp_array[j][23:19]) begin
		     inp_array[j][13:7] = inpf_array[i][6:0]; 
		  end
		end
	 end
	out_1 = inp_array[0];
	out_2 = inp_array[1];
	out_3 = inp_array[2];
	out_4 = inp_array[3];	 
  end
endmodule