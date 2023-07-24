module reg_IDEx(
    input clk,
    input rst,
    input Flush,//发生load-use数据冒险时，对ID/Ex寄存器清零，阻塞下一条指令写入
                //发生分支预测错误时，清零寄存器，删除指令的执行结果
    input[31:0] ID_pc,
    input[31:0] ID_Jtarget,
    input[15:0] ID_imm16,
    input[31:0] ID_busA,
    input[31:0] ID_busB,
    input[4:0] ID_Rs,//在转发过程中需要比较Ex_Rs与Mem_Rw/Wr_Rw
    input[4:0] ID_Rt,
    input[4:0] ID_Rd,
    input[31:0] ID_instr,
    input[31:0] ID_pcadd4,
    input ID_pre,

    input ID_ExtOp,
    input ID_ALUsrc,
    input[3:0] ID_ALUctr,
    input ID_RegDst,
    input ID_MemWr,
    input[3:0] ID_Branch,
    input[3:0] ID_Shift,
    input[1:0] ID_Set,
    input ID_RegWr,
    input[1:0] ID_MemtoReg,
    input[1:0] ID_lbyte,
    input ID_sbyte,
    input[2:0] ID_jump,
    input ID_limm,

    output reg[31:0] Ex_pc,
    output reg[31:0] Ex_Jtarget,
    output reg[15:0] Ex_imm16,
    output reg[31:0] Ex_busA,
    output reg[31:0] Ex_busB,
    output reg[4:0] Ex_Rs,
    output reg[4:0] Ex_Rt,
    output reg[4:0] Ex_Rd,
    output reg[31:0] Ex_instr,
    output reg[31:0] Ex_pcadd4,
    output reg Ex_pre,

    output reg Ex_ExtOp,
    output reg Ex_ALUsrc,
    output reg[3:0] Ex_ALUctr,
    output reg Ex_RegDst,
    output reg Ex_MemWr,
    output reg[3:0] Ex_Branch,
    output reg[3:0] Ex_Shift,
    output reg[1:0] Ex_Set,
    output reg Ex_RegWr,
    output reg[1:0] Ex_MemtoReg,
    output reg[1:0] Ex_lbyte,
    output reg Ex_sbyte,
    output reg[2:0] Ex_jump,
    output reg Ex_limm
);
always @(posedge clk or negedge rst) begin
    if(!rst|Flush)begin
        Ex_pc<=32'h00003000;
        Ex_Jtarget<=32'h00003000;
        Ex_busA<=32'h00000000;
        Ex_busB<=32'h00000000;
        Ex_imm16<=16'h0000;
        Ex_Rs<=5'h00;
        Ex_Rt<=5'h00;
        Ex_Rd<=5'h00;
        Ex_instr<=32'h00000000;
        Ex_pcadd4<=32'h00003000;
        Ex_pre<=1'b0;

        Ex_ExtOp<=1'b0;
        Ex_ALUsrc<=1'b0;
        Ex_ALUctr<=1'b0;
        Ex_RegDst<=1'b0;
        Ex_MemWr<=1'b0;
        Ex_Branch<=4'h0;
        Ex_Shift<=4'h0;
        Ex_Set<=2'h0;
        Ex_RegWr<=1'b0;
        Ex_MemtoReg<=2'h0;
        Ex_lbyte<=2'h0;
        Ex_sbyte<=1'b0;
        Ex_jump<=3'h0;
        Ex_limm<=1'b0;
    end
    else begin
        Ex_pc<=ID_pc;
        Ex_Jtarget<=ID_Jtarget;
        Ex_busA<=ID_busA;
        Ex_busB<=ID_busB;
        Ex_imm16<=ID_imm16;
        Ex_Rs<=ID_Rs;
        Ex_Rt<=ID_Rt;
        Ex_Rd<=ID_Rd;
        Ex_instr<=ID_instr;
        Ex_pcadd4<=ID_pcadd4;
        Ex_pre<=ID_pre;

        Ex_ExtOp<=ID_ExtOp;
        Ex_ALUsrc<=ID_ALUsrc;
        Ex_ALUctr<=ID_ALUctr;
        Ex_RegDst<=ID_RegDst;
        Ex_MemWr<=ID_MemWr;
        Ex_Branch<=ID_Branch;
        Ex_Shift<=ID_Shift;
        Ex_Set<=ID_Set;
        Ex_RegWr<=ID_RegWr;
        Ex_MemtoReg<=ID_MemtoReg;
        Ex_lbyte<=ID_lbyte;
        Ex_sbyte<=ID_sbyte;
        Ex_jump<=ID_jump;
        Ex_limm<=ID_limm;
    end
end
endmodule