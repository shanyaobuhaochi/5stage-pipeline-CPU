module dm_4k(
    input[11:2] addr,
    input[31:0] din,
    input clk,
    input wEn,
    output[31:0] dout
);
reg[31:0] dm[1023:0];//容量1024条整型数据,addr只有后12位有效
assign dout={dm[addr]};
always @(negedge clk)begin
    if(wEn)begin//大端存储
        dm[addr]<=din;
    end
end

integer i;
initial begin
    for(i=0;i<1024;i=i+1)dm[i]=0;
end
endmodule
