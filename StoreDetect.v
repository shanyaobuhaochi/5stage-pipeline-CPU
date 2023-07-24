//sw存储的数据与前两条指令的目的寄存器相关
module StoreDetect(
    input Ex_MemWr,//sw or sb
    input[4:0] Ex_Rt,
    input[4:0] Mem_Rw,
    input Mem_RegWr,
    input[4:0] Wr_Rw,
    input Wr_RegWr,
    output reg[1:0] store//00 Ex_busB  01 Mem_ALUres  00 Wr_busB
);
wire c1,c2;
assign c1=Ex_MemWr&&Mem_RegWr&&(Mem_Rw!=5'h00)&&(Mem_Rw==Ex_Rt);
assign c2=Ex_MemWr&&Wr_RegWr&&(Wr_Rw!=5'h00)&&(Mem_Rw!=Ex_Rt)&&(Wr_Rw==Ex_Rt);
always @(c1 or c2) begin
    case({c2,c1})
    0:store<=2'h0;
    1:store<=2'h1;
    2:store<=2'h2;
    endcase
end
endmodule