`include "mux.v"
`include "extender.v"
`include "dm.v"
`include "im.v"
`include "RegFile.v"
`include "adder.v"
`include "pc.v"
`include "reg_IFID.v"
`include "reg_IDEx.v"
`include "reg_ExMem.v"
`include "reg_MemWr.v"
`include "ControlUnit.v"
`include "ALU.v"
`include "ForwardingDetect.v"
`include "LUdetect.v"
`include "BHT.v"
`include "BranchDetect.v"
`include "StoreDetect.v"
module mips(
  input clk,
  input rst
);
parameter beq=6'b000100;
parameter bne=6'b000101;
parameter bgtz=6'b000111;
parameter bgez=6'b000001;
parameter bgez_rt=5'b00001;
parameter bltz=6'b000001;
parameter bltz_rt=5'b00000;
parameter blez=6'b000110;

//IF 取指
wire[31:0] npc,npc_;
wire[31:0] instr,pc;//分支预测地址
PC proc(clk,rst,(~C),npc,pc);//若~C，流水线阻塞，pc的值保持不变
im_4k IM(pc[11:2],instr);//取指令
wire pre,IF_Branch;//IF_Branch仅判断是否为分支指令
BHT_4k BHT(pc[11:2],res,pre);//取预测位 1 预测跳转

wire[29:0] IF_imm30;
wire[31:0] IF_pcadd4,Pre_Btarget,IF_pcaddimm;
adder a3(pc,32'h00000004,IF_pcadd4);
extender16_30 e4(instr[15:0],1'b1,IF_imm30);
adder a4(pc,{IF_imm30,2'b00},IF_pcaddimm);
wire[5:0] op=instr[31:26];
wire[4:0] rt=instr[20:16];
assign IF_Branch=(op==beq)|(op==bne)|(op==bgtz)|(op==bgez&&rt==bgez_rt)|(op==bltz&&rt==bltz_rt)|(op==blez);
wire[31:0] next_pc;
mux2_X_32 m8(IF_pcadd4,IF_pcaddimm,IF_Branch&&pre,next_pc);
mux2_X_32 m9(Ex_pc,next_pc,res,npc_);//res=0 pc<=Ex_pc重新执行分支指令
mux2_X_32 m22(npc_,Wr_Jtarget,Wr_jump[0],npc);

wire[31:0] ID_Jtarget,ID_instr,ID_pc,ID_pcadd4;
wire[15:0] ID_imm16;
wire[5:0] ID_op,ID_func;
wire[4:0] ID_Rs,ID_Rt,ID_Rd,ID_shf;
wire ID_pre;
reg_IFID r1(clk,rst,(~C),(~res)|Wr_jump[0],pc,instr,IF_pcadd4,pre,ID_pc,ID_op,ID_Jtarget,ID_func,ID_imm16,ID_Rs,ID_Rt,ID_Rd,ID_shf,ID_instr,ID_pcadd4,ID_pre);

//ID 取数、译码
wire[31:0] ID_busA,ID_busB;
RegFile RF(clk,rst,Wr_RegWr&&(~Wr_Overflow),ID_Rs,ID_Rt,Wr_Rw_,Wr_busW,ID_busA,ID_busB);//写回的数据以及wEn在Wr阶段产生
wire ID_ExtOp,ID_ALUsrc,ID_RegDst,ID_Rtype,ID_MemWr,ID_RegWr,ID_sbyte,ID_limm;
wire[3:0] ID_ALUop,ID_Branch,ID_Shift,ID_ALUctr;
wire[2:0] ID_jump;
wire[1:0] ID_Set,ID_MemtoReg,ID_lbyte;
ControlUnit CU(ID_op,ID_Rt,ID_func,ID_Branch,ID_Shift,ID_Set,ID_RegDst,ID_ALUsrc,ID_ALUctr,ID_MemtoReg,ID_RegWr,ID_MemWr,ID_ExtOp,ID_lbyte,ID_sbyte,ID_jump,ID_limm);

//移位指令选择移位类型
wire[4:0] ID_shf_;
wire[31:0] ID_shf32,ID_busA_;
mux2_X_5 m11(ID_shf,ID_busA[4:0],ID_Shift[1],ID_shf_);
extender5_32 e5(ID_shf_,1'b0,ID_shf32);
mux2_X_32 m10(ID_busA,ID_shf32,ID_Shift[0],ID_busA_);

//load-use冒险检测
wire C;//C=1 发生load-use数据冒险
LUdetect LU(Ex_instr,ID_Rs,ID_Rt,Ex_Rw,C);

wire Ex_ExtOp,Ex_ALUsrc,Ex_RegDst,Ex_MemWr,Ex_RegWr,Ex_pre,Ex_sbyte,Ex_limm;
wire[3:0] Ex_ALUctr,Ex_Branch,Ex_Shift;
wire[31:0] Ex_pc,Ex_Jtarget,Ex_busA,Ex_busB,Ex_instr,Ex_pcadd4;
wire[15:0] Ex_imm16;
wire[4:0] Ex_Rs,Ex_Rt,Ex_Rd;
wire[1:0] Ex_Set,Ex_MemtoReg,Ex_lbyte;
wire[2:0] Ex_jump;
reg_IDEx r2(clk,rst,C|(~res)|Wr_jump[0],ID_pc,ID_Jtarget,ID_imm16,ID_busA_,ID_busB,ID_Rs,ID_Rt,ID_Rd,ID_instr,ID_pcadd4,ID_pre,
ID_ExtOp,ID_ALUsrc,ID_ALUctr,ID_RegDst,ID_MemWr,ID_Branch,ID_Shift,ID_Set,ID_RegWr,ID_MemtoReg,ID_lbyte,ID_sbyte,ID_jump,ID_limm,
Ex_pc,Ex_Jtarget,Ex_imm16,Ex_busA,Ex_busB,Ex_Rs,Ex_Rt,Ex_Rd,Ex_instr,Ex_pcadd4,Ex_pre,
Ex_ExtOp,Ex_ALUsrc,Ex_ALUctr,Ex_RegDst,Ex_MemWr,Ex_Branch,Ex_Shift,Ex_Set,Ex_RegWr,Ex_MemtoReg,Ex_lbyte,Ex_sbyte,Ex_jump,Ex_limm);

//Ex
wire[31:0] Ex_imm32,Asrc,Bsrc;
mux3_X_32 m7(Ex_busA,Mem_ALUres,Wr_busW,ALUSrcA,Asrc);//采用转发技术，将Mem阶段的ALU_res和Wr阶段的busW转发到ALU的A端口
extender16_32 e3(Ex_imm16,Ex_ExtOp,Ex_imm32);
mux4_X_32 m1(Ex_busB,Mem_ALUres,Wr_busW,Ex_imm32,ALUSrcB,Bsrc);//采用转发技术，将Mem阶段的ALU_res和Wr阶段的busW转发到ALU的B端口
wire[31:0] SbusB;//采用转发技术，将Mem阶段的ALU_res和Wr阶段的busW转发到Ex/Mem的busB端口
mux3_X_32 m17(Ex_busB,Mem_ALUres,Wr_busW,store,SbusB);

wire[31:0] Ex_Jtarget_;
mux2_X_32 m20(Ex_Jtarget,Asrc,Ex_jump[1]&&Ex_jump[0],Ex_Jtarget_);//jr or jalr指令更新跳转地址

wire meet;//1 满足分支跳转条件（即要进行分支跳转）
BranchDetect BD(Ex_Branch,Asrc,Zero,meet);//类似控制单元
wire res;//检测branch预测是否正确
assign res=(meet&&Ex_pre)|(!meet&&!Ex_pre);
//res=0 进行IF/ID、ID/Ex清零  Ex/Mem保持，npc设定为branch指令重新执行

wire Zero,Sign,Overflow,Carryflag;
wire[31:0] ALU_res;
ALU alu(Asrc,Bsrc,Ex_ALUctr,Zero,Sign,Overflow,Carryflag,ALU_res);
wire[4:0] Ex_Rw;
mux2_X_5 m3(Ex_Rt,Ex_Rd,Ex_RegDst,Ex_Rw);

//置数指令用ALU标志位比较大小
wire ctrl;
wire[31:0] set_num,Ex_ALUres,Ex_ALUres_;
mux2_X_1 m12(Sign,Carryflag,Ex_Set[1],ctrl);
mux2_X_32 m13(32'h00000000,32'h00000001,ctrl,set_num);
mux2_X_32 m14(ALU_res,set_num,Ex_Set[0],Ex_ALUres);
mux2_X_32 m23(Ex_ALUres,{Ex_imm16,16'h0000},Ex_limm,Ex_ALUres_);

wire Mem_Overflow,Mem_MemWr,Mem_Jump,Mem_RegWr,Mem_sbyte;
wire[31:0] Mem_Btarget,Mem_Jtarget,Mem_ALUres,Mem_busB,Mem_instr,Mem_pcadd4;
wire[4:0] Mem_Rw,Mem_Rt;
wire[1:0] Mem_Set,Mem_MemtoReg,Mem_lbyte;
wire[2:0] Mem_jump;
reg_ExMem r3(clk,rst,~res|Wr_jump[0],Ex_Jtarget_,Overflow,SbusB,Ex_ALUres_,Ex_instr,Ex_pcadd4,Ex_Rw,Ex_MemWr,Ex_MemtoReg,Ex_RegWr,Ex_lbyte,Ex_sbyte,Ex_jump,
Mem_Jtarget,Mem_Overflow,Mem_busB,Mem_ALUres,Mem_instr,Mem_pcadd4,Mem_Rw,Mem_MemWr,Mem_MemtoReg,Mem_RegWr,Mem_lbyte,Mem_sbyte,Mem_jump);

//Mem
//分支指令or跳转指令将地址返回
//sw,lw指令访存
//置数指令选0 or 1
wire[31:0] Mem_dout,ext_byte,Mem_dout_;
dm_4k DM(Mem_ALUres[11:2],Mem_din,clk,Mem_MemWr,Mem_dout);
wire[7:0] one_byte;
mux4_X_8 m15(Mem_dout[7:0],Mem_dout[15:8],Mem_dout[23:16],Mem_dout[31:24],Mem_ALUres[1:0],one_byte);
extender8_32 e6(one_byte,Mem_lbyte[1],ext_byte);
mux2_X_32 m16(Mem_dout,ext_byte,Mem_lbyte[0],Mem_dout_);

wire[31:0] Mem_dout_updated,Mem_din;
mux4_X_32 m18({Mem_dout[31:8],Mem_busB[7:0]},{Mem_dout[31:16],Mem_busB[7:0],Mem_dout[7:0]},{Mem_dout[31:24],Mem_busB[7:0],Mem_dout[15:0]},{Mem_busB[7:0],Mem_dout[23:0]},Mem_ALUres[1:0],Mem_dout_updated);
mux2_X_32 m19(Mem_busB,Mem_dout_updated,Mem_sbyte,Mem_din);

wire[31:0] Wr_ALUres,Wr_dout,Wr_instr,Wr_Jtarget,Wr_pcadd4;
wire[4:0] Wr_Rw;
wire[1:0] Wr_MemtoReg;
wire[2:0] Wr_jump;
wire Wr_Overflow,Wr_RegWr;
reg_MemWr r4(clk,rst,Wr_jump[0],Mem_Jtarget,Mem_ALUres,Mem_dout_,Mem_instr,Mem_pcadd4,Mem_Rw,Mem_Overflow,Mem_MemtoReg,Mem_RegWr,Mem_jump,
Wr_Jtarget,Wr_ALUres,Wr_dout,Wr_instr,Wr_pcadd4,Wr_Rw,Wr_Overflow,Wr_MemtoReg,Wr_RegWr,Wr_jump);

//Wr
wire[4:0] Wr_Rw_;
wire[31:0] Wr_busW;
mux2_X_5 m21(Wr_Rw,5'd31,Wr_jump[2]&&Wr_jump[0],Wr_Rw_);
mux3_X_32 m6(Wr_ALUres,Wr_pcadd4,Wr_dout,Wr_MemtoReg,Wr_busW);

//转发单元
wire[1:0] ALUSrcA,ALUSrcB;
ForwardingDetect FD(Ex_ALUsrc,Ex_Rs,Ex_Rt,Mem_Rw,Mem_RegWr,Wr_Rw,Wr_RegWr,ALUSrcA,ALUSrcB);

//sw指令存储数据冒险
wire[1:0] store;
StoreDetect SD(Ex_MemWr,Ex_Rt,Mem_Rw,Mem_RegWr,Wr_Rw,Wr_RegWr,store);
always @(Wr_instr) begin
  if(Wr_instr==32'hfc000000)begin
    $finish;
  end
end
endmodule