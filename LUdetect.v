module LUdetect(//检测是否发生load-use数据冒险,可以再lw之后的指令进入ID阶段开始检测
    input[31:0] Ex_instr,
    input[4:0] ID_Rs,
    input[4:0] ID_Rt,
    input[4:0] Ex_Rw,
    output C
);
parameter lw=6'b100011;
assign C=(Ex_instr[31:26]==lw)&&((Ex_Rw==ID_Rs)||(Ex_Rw==ID_Rt));
endmodule