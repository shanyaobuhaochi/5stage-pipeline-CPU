module reg_MemWr(
    input clk,
    input rst,
    input Flush,
    input[31:0] Mem_Jtarget,
    input[31:0] Mem_ALUres,
    input[31:0] Mem_dout,
    input[31:0] Mem_instr,
    input[31:0] Mem_pcadd4,
    input[4:0] Mem_Rw,

    input Mem_Overflow,
    input[1:0] Mem_MemtoReg,
    input Mem_RegWr,
    input[2:0] Mem_jump,
    
    output reg[31:0] Wr_Jtarget,
    output reg[31:0] Wr_ALUres,
    output reg[31:0] Wr_dout,
    output reg[31:0] Wr_instr,
    output reg[31:0] Wr_pcadd4,
    output reg[4:0] Wr_Rw,
    
    output reg Wr_Overflow,
    output reg[1:0] Wr_MemtoReg,
    output reg Wr_RegWr,
    output reg[2:0] Wr_jump
);
always @(posedge clk or negedge rst) begin
    if(!rst|Flush)begin
        Wr_Jtarget<=32'h00000000;
        Wr_ALUres<=32'h00000000;
        Wr_dout<=32'h00000000;
        Wr_instr<=32'h00000000;
        Wr_pcadd4<=32'h00003000;
        Wr_Rw<=5'h00;
        Wr_Overflow<=1'b0;
        Wr_MemtoReg<=2'h0;
        Wr_RegWr<=1'b0;
        Wr_jump<=3'h0;
    end
    else begin
        Wr_Jtarget<=Mem_Jtarget;
        Wr_ALUres<=Mem_ALUres;
        Wr_dout<=Mem_dout;
        Wr_instr<=Mem_instr;
        Wr_pcadd4<=Mem_pcadd4;
        Wr_Rw<=Mem_Rw;
        Wr_Overflow<=Mem_Overflow;
        Wr_MemtoReg<=Mem_MemtoReg;
        Wr_RegWr<=Mem_RegWr;
        Wr_jump<=Mem_jump;
    end
end
endmodule