module ForwardingDetect(//写后读冒险
    input Ex_ALUsrc,
    input[4:0] Ex_Rs,
    input[4:0] Ex_Rt,
    input[4:0] Mem_Rw,
    input Mem_RegWr,
    input[4:0] Wr_Rw,
    input Wr_RegWr,
    
    output reg[1:0] ALUSrcA,//00 busA  01 Mem_ALUres  10 Wr_ALUres
    output reg[1:0] ALUSrcB//00 busB  01 Mem_ALUres  10Wr_ALU_res  11 imm32
);
//转发条件需排除的约束情况
//（1）运算结果不写入寄存器
//（2）目的寄存器为$0
//（3）多条指令关于同一个寄存器数据相关（需要排除c1X与c2X均为1的情况）
wire c1A,c1B,c2A,c2B;
assign c1A=Mem_RegWr&&(Mem_Rw!=5'h00)&&(Mem_Rw==Ex_Rs);
assign c1B=Mem_RegWr&&(Mem_Rw!=5'h00)&&(Mem_Rw==Ex_Rt)&&(!Ex_ALUsrc);
assign c2A=Wr_RegWr&&(Wr_Rw!=5'h00)&&(Wr_Rw==Ex_Rs)&&(Mem_RegWr?(Mem_Rw!=Ex_Rs):1);
assign c2B=Wr_RegWr&&(Wr_Rw!=5'h00)&&(Wr_Rw==Ex_Rt)&&(Mem_RegWr?(Mem_Rw!=Ex_Rt):1)&&(!Ex_ALUsrc);
                                                                                                                 

always @(Ex_ALUsrc or c1A or c2A or c1B or c2B) begin
    if(!c1A&&!c2A)ALUSrcA=2'b00;
    else if(c1A&&!c2A)ALUSrcA=2'b01;
    else if(!c1A&&c2A)ALUSrcA=2'b10;

    if((!c1B&&!c2B))begin
        if(!Ex_ALUsrc)ALUSrcB=2'b00;
        else ALUSrcB=2'b11;
    end
    else begin
        if(c1B&&!c2B)ALUSrcB=2'b01;
        else if(!c1B&&c2B)ALUSrcB=2'b10;
    end
end
endmodule