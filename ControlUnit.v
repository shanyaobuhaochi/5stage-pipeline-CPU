module ControlUnit(
    input[5:0] op,
    input[4:0] rt,
    input[5:0] func,
    output[3:0] Branch,//Branch[0]=1 分支指令; 0001 beq; 0011 bne; 0101 bgtz; 0111 bgez; 1001 bltz; 1011 blez
    output[3:0] Shift,//Shift[0]=1 移位指令;Shift[1]=1 变量型移位; 0001 sll; 0011 sllv; 0101 srl; 0111 srlv; 1001 sra; 1011 srav
    output[1:0] Set,//Set[0]=1 set置数类指令; Set[1]=0 slt slti; Set[1]=1 sltu sltiu
    output RegDst,//0 RW==Rt; 1 Rw==Rd
    output ALUsrc,//0 reg[rt] 1 imm
    output[3:0] ALUctr,
    output[1:0] MemtoReg,
    output RegWr,//
    output MemWr,//
    output ExtOp,//0 0扩展;  1 符号扩展
    output[1:0] lbyte,//lbyte[0]=1 lb/lbu; lbyte[1]=0 lbu; lbyte[1]=1 lb
    output sbyte,
    output[2:0] jump,//jump[0]=1 j/jr/jal/jalr; j 001  jr 011  jal 101  jalr 111
    output limm 
);
parameter addi=6'b001000;
parameter addiu=6'b001001;
parameter halt=6'b111111;
parameter ori=6'b001101;
parameter beq=6'b000100;
parameter bne=6'b000101;
parameter bgtz=6'b000111;
parameter bgez=6'b000001;
parameter bgez_rt=5'b00001;
parameter bltz=6'b000001;
parameter bltz_rt=5'b00000;
parameter blez=6'b000110;
parameter lw=6'b100011;
parameter sw=6'b101011;
parameter j=6'b000010;
parameter jal=6'b000011;
parameter Rtype=6'b000000;
parameter andi=6'b001100;
parameter xori=6'b001110;
parameter slti=6'b001010;
parameter sltiu=6'b001011;
parameter sb=6'b101000;
parameter lb=6'b100000;
parameter lbu=6'b100100;
parameter lui=6'b001111;
parameter add_func=6'b100000;
parameter addu_func=6'b100001;
parameter sub_func=6'b100010;
parameter subu_func=6'b100011;
parameter sll_func=6'b000000;
parameter sllv_func=6'b000100;
parameter srl_func=6'b000010;
parameter srlv_func=6'b000110;
parameter sra_func=6'b000011;
parameter srav_func=6'b000111;
parameter nor_func=6'b100111;
parameter or_func=6'b100101;
parameter xor_func=6'b100110;
parameter and_func=6'b100100;
parameter slt_func=6'b101010;
parameter sltu_func=6'b101011;
parameter jr_func=6'b001000;
parameter jalr_func=6'b001001;

assign limm=(op==lui);

assign Branch[0]=(op==beq)|(op==bne)|(op==bgtz)|(op==bgez&&rt==bgez_rt)|(op==bltz&&rt==bltz_rt)|(op==blez);
assign Branch[1]=(op==bne)|(op==bgez&&rt==bgez_rt)|(op==blez);
assign Branch[2]=(op==bgtz)|(op==bgez&&rt==bgez_rt);
assign Branch[3]=(op==bltz&&rt==bltz_rt)|(op==blez);

assign Shift[0]=(op==Rtype&&func==sll_func)|(op==Rtype&&func==sllv_func)|(op==Rtype&&func==srl_func)|(op==Rtype&&func==srlv_func)|(op==Rtype&&func==sra_func)|(op==Rtype&&func==srav_func);
assign Shift[1]=(op==Rtype&&func==sllv_func)|(op==Rtype&&func==srlv_func)|(op==Rtype&&func==srav_func);
assign Shift[2]=(op==Rtype&&func==srl_func)|(op==Rtype&&func==srlv_func);
assign Shift[3]=(op==Rtype&&func==sra_func)|(op==Rtype&&func==srav_func);

assign Set[0]=(op==Rtype&&func==slt_func)|(op==Rtype&&func==sltu_func)|(op==slti)|(op==sltiu);
assign Set[1]=(op==Rtype&&func==sltu_func)|(op==sltiu);

assign MemtoReg[0]=(op==jal)|(op==Rtype&&func==jalr_func);
assign MemtoReg[1]=(op==lw)|(op==lb)|(op==lbu);

assign RegDst=(op==Rtype);
assign ExtOp=(op==lw)|(op==sw)|(op==addi)|(op==slti)|(op==sltiu)|(op==sb)|(op==lb)|(op==lbu);
assign RegWr=(op==Rtype&&func!=jr_func)|(op==lw)|(op==ori)|(op==addi)|(op==addiu)|(op==andi)|(op==xori)|(op==slti)|(op==sltiu)|(op==lb)|(op==lbu)|(op==lui)|(op==jal);
assign MemWr=(op==sw)|(op==sb);
assign ALUsrc=(op==ori)|(op==lw)|(op==sw)|(op==addi)|(op==addiu)|(op==andi)|(op==xori)|(op==slti)|(op==sltiu)|(op==sb)|(op==lb)|(op==lbu);

assign lbyte[0]=(op==lb)|(op==lbu);
assign lbyte[1]=(op==lb);

assign sbyte=(op==sb);

assign jump[0]=(op==j)|(op==Rtype&&func==jr_func)|(op==jal)|(op==Rtype&&func==jalr_func);
assign jump[1]=(op==Rtype&&func==jr_func)|(op==Rtype&&func==jalr_func);
assign jump[2]=(op==jal)|(op==Rtype&&func==jalr_func);

wire ALU_add=(op==Rtype&&func==add_func)|(op==addi);
wire ALU_sub=(op==Rtype&&func==sub_func)|(op==Rtype&&func==slt_func)|(op==slti);
wire ALU_or=(op==ori)|(op==Rtype&&func==or_func);
wire ALU_addu=(op==lw)|(op==sw)|(op==Rtype&&func==addu_func)|(op==addiu)|(op==sb)|(op==lb)|(op==lbu);
wire ALU_subu=(op==beq)|(op==bne)|(op==Rtype&&func==sltu_func)|(op==sltiu)|(op==Rtype&&func==subu_func);
wire ALU_sll=(op==Rtype&&func==sll_func)|(op==Rtype&&func==sllv_func);
wire ALU_srl=(op==Rtype&&func==srl_func)|(op==Rtype&&func==srlv_func);
wire ALU_sra=(op==Rtype&&func==sra_func)|(op==Rtype&&func==srav_func);
wire ALU_nor=(op==Rtype&&func==nor_func);
wire ALU_xor=(op==Rtype&&func==xor_func)|(op==xori);
wire ALU_and=(op==Rtype&&func==and_func)|(op==andi);

assign ALUctr[0]=ALU_sub|ALU_subu|ALU_srl|ALU_or|ALU_xor;
assign ALUctr[1]=ALU_or|ALU_addu|ALU_subu|ALU_sra|ALU_and;
assign ALUctr[2]=ALU_or|ALU_sll|ALU_srl|ALU_sra;
assign ALUctr[3]=ALU_nor|ALU_xor|ALU_and;

endmodule