module extender5_32(x,ExtOp,y);//5位立即数扩展为32位
input[4:0] x;
input ExtOp;
output[31:0] y;
assign y=(ExtOp==1)?{{27{x[4]}},x}:{{27'b0},x};
endmodule

module extender8_32(x,ExtOp,y);//8位立即数扩展为32位
input[7:0] x;
input ExtOp;
output[31:0] y;
assign y=(ExtOp==1)?{{24{x[7]}},x}:{{24'b0},x};
endmodule

module extender16_30(x,ExtOp,y);//16位立即数扩展为30位
input[15:0] x;
input ExtOp;
output[29:0] y;
assign y=(ExtOp==1)?{{14{x[15]}},x}:{{14'b0},x};
endmodule

module extender16_32(x,ExtOp,y);//16位立即数扩展为32位
input[15:0] x;
input ExtOp;
output[31:0] y;
assign y=(ExtOp==1)?{{16{x[15]}},x}:{{16'b0},x};
endmodule