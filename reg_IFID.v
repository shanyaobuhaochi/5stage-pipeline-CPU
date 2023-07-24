module reg_IFID(
    input clk,
    input rst,
    input wEn,//发生load-use数据冒险时，阻塞下一条指令写入If/ID寄存器，保存其中的内容
    input Flush,//发生分支预测错误时，清零寄存器，删除指令的执行结果
    input[31:0] IF_pc,//本条指令pc，发生预测错误时重新执行分支指令
    input[31:0] IF_instr,
    input[31:0] IF_pcadd4,
    input pre,
    
    output reg[31:0] ID_pc,
    output reg[31:26] ID_op,
    output reg[31:0] ID_Jtarget,
    output reg[5:0] ID_func,
    output reg[15:0] ID_imm16,
    output reg[4:0] ID_Rs,
    output reg[4:0] ID_Rt,
    output reg[4:0] ID_Rd,
    output reg[4:0] ID_shf,
    output reg[31:0] ID_instr,
    output reg[31:0] ID_pcadd4,
    output reg ID_pre
);
always @(posedge clk or negedge rst) begin//寄存器访问冲突，前半周期读，后半周期写
    if(!rst|Flush)begin//rst为零时清零
        ID_pc<=32'h00003000;
        ID_op<=32'h00;
        ID_Jtarget<=32'h00003000;
        ID_func<=6'h00;
        ID_imm16<=16'h0000;
        ID_Rs<=5'h00;
        ID_Rt<=5'h00;
        ID_Rd<=5'h00;
        ID_shf<=5'h00;
        ID_instr<=32'h00000000;
        ID_pcadd4<=32'h00030000;
        ID_pre<=1'b0;
    end
    else if(wEn)begin
        ID_pc<=IF_pc;
        ID_op<=IF_instr[31:26];
        ID_Jtarget<={IF_pc[31:28],IF_instr[25:0],2'b00};
        ID_func<=IF_instr[5:0];
        ID_imm16<=IF_instr[15:0];
        ID_Rs<=IF_instr[25:21];
        ID_Rt<=IF_instr[20:16];
        ID_Rd<=IF_instr[15:11];
        ID_shf<=IF_instr[10:6];
        ID_instr<=IF_instr;
        ID_pcadd4<=IF_pcadd4;
        ID_pre<=pre;
    end
end
endmodule