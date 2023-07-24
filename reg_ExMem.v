module reg_ExMem(
    input clk,
    input rst,
    input Flush,
    input[31:0] Ex_Jtarget,
    input Ex_Overflow,
    input[31:0] Ex_busB,
    input[31:0] Ex_ALUres,
    input[31:0] Ex_instr,
    input[31:0] Ex_pcadd4,
    input[4:0] Ex_Rw,
    
    input Ex_MemWr,
    input[1:0] Ex_MemtoReg,
    input Ex_RegWr,
    input[1:0] Ex_lbyte,
    input Ex_sbyte,
    input[2:0] Ex_jump,

    output reg[31:0] Mem_Jtarget,
    output reg Mem_Overflow,
    output reg[31:0] Mem_busB,//处理前面指令目的寄存器与sw源寄存器相关使用
    output reg[31:0] Mem_ALUres,
    output reg[31:0] Mem_instr,
    output reg[31:0] Mem_pcadd4,
    output reg[4:0] Mem_Rw,
    
    output reg Mem_MemWr,
    output reg[1:0] Mem_MemtoReg,
    output reg Mem_RegWr,
    output reg[1:0] Mem_lbyte,
    output reg Mem_sbyte,
    output reg[2:0] Mem_jump
);
always @(posedge clk or negedge rst) begin
    if(!rst|Flush)begin
        Mem_Jtarget<=32'h00000000;
        Mem_Overflow<=1'b0;
        Mem_busB<=32'h00000000;
        Mem_ALUres<=32'h00000000;
        Mem_instr<=32'h00000000;
        Mem_Rw<=5'h00;
        Mem_pcadd4<=32'h00003000;

        Mem_MemWr<=1'b0;
        Mem_MemtoReg<=2'h0;
        Mem_RegWr<=1'b0;
        Mem_lbyte<=2'h0;
        Mem_sbyte<=1'b0;
        Mem_jump<=3'h0;
    end
    else if(!Flush)begin
        Mem_Jtarget<=Ex_Jtarget;
        Mem_Overflow<=Ex_Overflow;
        Mem_busB<=Ex_busB;
        Mem_ALUres<=Ex_ALUres;
        Mem_instr<=Ex_instr;
        Mem_Rw<=Ex_Rw;
        Mem_pcadd4<=Ex_pcadd4;
        
        Mem_MemWr<=Ex_MemWr;
        Mem_MemtoReg<=Ex_MemtoReg;
        Mem_RegWr<=Ex_RegWr;
        Mem_lbyte<=Ex_lbyte;
        Mem_sbyte<=Ex_sbyte;
        Mem_jump<=Ex_jump;
    end
end
endmodule