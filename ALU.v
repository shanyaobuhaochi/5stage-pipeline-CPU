module ALU(
    input [31:0] x,
    input [31:0] y,
    input[3:0] ALUctr,
    output Zero,
    output Sign,//结果的符号（无符号运算无意义）
    output reg Overflow,//带符号整数运算时结果发生溢出  
    output reg Carryflag,//无符号数加/减运算时的进/借位  CF=Sub^Cout
    output reg[31:0] z
);
//ALU 实现add,sub,or,addu,subu  因此ALUctr由3位实现

reg[31:0] temp;
reg Co;
always @(x or y or ALUctr) begin
    case (ALUctr)
        4'b0000:begin//add
            z=x+y;
            Overflow=(x[31]&y[31]&(~z[31]))|((~x[31])&(~y[31])&z[31]);
        end
        4'b0001:begin//sub
            temp=(~y)+32'h00000001;
            z=x+temp;
            Overflow=(x[31]&temp[31]&(~z[31]))|((~x[31])&(~temp[31])&z[31]);
        end
        4'b0010:begin//addu
            {Co,z}=x+y;
            Carryflag=Co;
        end
        4'b0011:begin//subu
            temp=(~y)+32'h00000001;
            {Co,z}=x+temp;
            Carryflag=~Co;
            if(y==0)Carryflag=~Carryflag;
        end
        4'b0100:begin//shift left logical
            z=y<<x;
        end
        4'b0101:begin//shift right logical
            z=y>>x;
        end
        4'b0110:begin//shift right arithmetic
            z=($signed(y))>>>x;
        end
        4'b0111:begin//or
            z=x|y;
        end
        4'b1000:begin//nor
            z=~(x|y);
        end
        4'b1001:begin//xor
            z=x^y;
        end
        4'b1010:begin//and
            z=x&y;
        end
    endcase
end
initial begin
    Overflow=1'b0;
    Carryflag=1'b0;
end
assign Zero=(z==0)?1:0;
assign Sign=(z[31]==1'b0)?0:1;
endmodule