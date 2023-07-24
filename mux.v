module mux2_X_1(a,b,s,y);
input s;
input a,b;
output y;
assign y=(s==1)?b:a;
endmodule

module mux2_X_4(a,b,s,y);
input s;
input[3:0] a,b;
output[3:0] y;
assign y=(s==1)?b:a;
endmodule

module mux2_X_5(a,b,s,y);
input s;
input[4:0] a,b;
output[4:0] y;
assign y=(s==1)?b:a;
endmodule

module mux2_X_32(a,b,s,y);
input s;
input[31:0] a,b;
output[31:0] y;
assign y=(s==1)?b:a;
endmodule

module mux3_X_32(
    input[31:0] d0,
    input[31:0] d1,
    input[31:0] d2,
    input[1:0] ctrl,
    output reg[31:0] busW
);
always @(d0 or d1 or d2 or ctrl) begin
    case(ctrl)
        2'b00:busW<=d0;
        2'b01:busW<=d1;
        2'b10:busW<=d2;
    endcase
end
endmodule

module mux4_X_8(
    input[7:0] rb,
    input[7:0] limm,
    input[7:0] pc_add4,
    input[7:0] wb,
    input[1:0] MemtoReg,
    output reg[7:0] busW
);
always @(rb or limm or pc_add4 or wb or MemtoReg) begin
    case(MemtoReg)
        2'b00:busW<=rb;
        2'b01:busW<=limm;
        2'b10:busW<=pc_add4;
        2'b11:busW<=wb;
    endcase
end
endmodule

module mux4_X_32(
    input[31:0] rb,
    input[31:0] limm,
    input[31:0] pc_add4,
    input[31:0] wb,
    input[1:0] MemtoReg,
    output reg[31:0] busW
);
always @(rb or limm or pc_add4 or wb or MemtoReg) begin
    case(MemtoReg)
        2'b00:busW<=rb;
        2'b01:busW<=limm;
        2'b10:busW<=pc_add4;
        2'b11:busW<=wb;
    endcase
end
endmodule