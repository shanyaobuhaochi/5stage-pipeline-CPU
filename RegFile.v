module RegFile (//通过先写后读的方式，使得在Wr阶段更新的寄存器值在前半个周期内写入，后半个周期读出即为更新后的数据
    input clk,
    input rst,
    input wEn,
    input[4:0] Ra,
    input[4:0] Rb,
    input[4:0] Rw,
    input[31:0] busW,
    output[31:0] busA,
    output[31:0] busB);

    reg[31:0] regs[31:0];//32*32bits registers
    assign busA=regs[Ra];
    assign busB=regs[Rb];
    //读写操作为时序逻辑
    //设置独立的读写端口
    integer i;
    always @(negedge clk or negedge rst) begin
        if(!rst)begin//rst为0进行复位
            for(i=0;i<32;i=i+1)regs[i]<=32'h00000000;
        end
        else begin
            if(wEn&&(Rw!=5'h00))begin//写使能为1并且写入地址不为0（$zero中存储值0）
                regs[Rw]<=busW;
            end
        end
    end
    initial begin
        for(i=0;i<32;i=i+1)regs[i]<=32'h00000000;
    end
endmodule