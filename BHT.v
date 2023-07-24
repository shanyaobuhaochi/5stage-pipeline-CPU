//branch在IF阶段,需要预测转移取or顺序取
//在Ex阶段便可以直到预测结果是否正确
//采用两位预测位
//流水线控制逻辑需要确保错误预测指令的执行结果不能生效，而且要能从正确的分支地址处重新启动流水线工作

//类似im结构（感觉可以直接写在im之中），预测正确信号作为输入，预测位作为输出
//以instr的地址作为索引，查找对应指令预测位，因此也不需要加入新项的操作

module BHT_4k(//branch history table 分支预测单元
    input[11:2] addr,//分支指令地址
    input res,//1 预测结果准确  0 预测结果不准确（还可以充当写信号）
    output pre//1 预测分支跳转  0 预测不跳转
);
reg[1:0] bht[1023:0];
assign pre=(bht[addr]==2'b11)|(bht[addr]==2'b10);
always @(addr) begin
    if(res)begin//预测正确
        case (bht[addr])
            0:bht[addr]<=2'b00;
            1:bht[addr]<=2'b00;
            2:bht[addr]<=2'b11;
            3:bht[addr]<=2'b11;
        endcase
    end
    else begin//预测错误
        case (bht[addr])
            0:bht[addr]<=2'b01;
            1:bht[addr]<=2'b11;
            2:bht[addr]<=2'b00;
            3:bht[addr]<=2'b10;
        endcase
    end
end

integer i;
initial begin
    for(i=0;i<1024;i=i+1)begin
        bht[i]<=2'b00;
    end
end
endmodule