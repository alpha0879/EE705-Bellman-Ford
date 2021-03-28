
`timescale 1 ns / 100 ps
module tb_forwardblock();

  reg [28:0] inp_1,inp_2,inp_3,inp_4;      //up(1)[28], wij(4)[27:24],  --i(5)[23:19]-- , --j(5)[18:14]--, wi(7)[13:7], --wj(7)[6:0]--
  reg [17:0] inpf_1,inpf_2,inpf_3,inpf_4;   //up(1)[17], i(5)[16:12],  --j(5)[11:7]-- ,  --wj(7)[6:0]--
  wire [28:0] out_1,out_2,out_3,out_4;
  
  forwardblock dut(inp_1,inp_2,inp_3,inp_4,inpf_1,inpf_2,inpf_3,inpf_4,out_1,out_2,out_3,out_4);
  
  initial begin
  inpf_1 = 18'b1_00001_11001_1100101;
  inpf_2 = 18'b1_00001_10101_1111101;
  inpf_3 = 18'b0_00001_10101_1100111;
  inpf_4 = 18'b1_00001_11011_1111111;
  
  inp_1 = 29'b1_0000_10101_11001_0010101_1001001; // same destination, up=1 for both , different wj(inpf_1)
  inp_2 = 29'b1_0000_10101_11001_0011001_1100101; // same destination, up=1 for both , same wj(inpf_1)
  inp_3 = 29'b0_0000_11001_11001_0010001_1001001; // up=0,same destination, different wj(inpf_1)
  inp_4 = 29'b1_0000_11011_10001_0010001_1001001; // up=1, same destination, j(forwarded) = i(input), different wj(inpf_4) 
  #10
  $display("Cases when update=1 for both input and forwarded waves");
  $display("Address j of inp_f1=%b , Wj of inp_f1=%b,Wj of inp_1 =%b, Wj of out_1=%b",inpf_1[11:7],inpf_1[6:0],inp_1[6:0],out_1[6:0]);
  $display("Address j of inp_f1=%b , Wj of inp_f1=%b,Wj of inp_1 =%b, Wj of out_2=%b",inpf_1[11:7],inpf_1[6:0],inp_2[6:0],out_2[6:0]);
  
  $display("Case when update=0 for input");
  $display("Address j of inp_f1=%b , Wj of inp_f1=%b,Wj of inp_1 =%b, Wj of out_3=%b",inpf_1[11:7],inpf_1[6:0],inp_3[6:0],out_3[6:0]);
  
  $display("case where j of forwared wave  = i of input wave");
  //$display("Address j of inp_f1=%b , Wj of inp_f1=%b,Wj of inp_1 =%b, Wj of out_1=%b",inpf_4[11:7],inpf_4[6:0],inp_4[6:0],out_4[6:0]);
  $display("Address j of inp_f1=%b , Wj of inp_f1=%b, Wi of inp_1 =%b, Wi of out_4=%b",inpf_4[11:7],inpf_4[6:0],inp_4[13:7],out_4[13:7]);
  
  
  inpf_1 = 18'b1_00001_11111_1100101;
  inpf_2 = 18'b1_00001_10001_1111111;
  inpf_3 = 18'b0_00011_10101_0000000;
  inpf_4 = 18'b1_11001_00001_1111110;
  
  inp_1 = 29'b1_0000_10101_10001_0010001_1000001; //same destination, up=1 for both , different wj(inpf_2)
  inp_2 = 29'b1_0000_10101_11111_0010001_1100101; //same destination, up=1 for both , different wj(inpf_1)
  inp_3 = 29'b0_0000_10001_11111_0010001_1001001; //same destination, up=0 for input , different wj(inpf_1), i=j condition
  inp_4 = 29'b1_0000_11001_10101_0010001_1001001; //same destination, up=0 for forwarded , different wj(inpf_3)
 
  end

endmodule
