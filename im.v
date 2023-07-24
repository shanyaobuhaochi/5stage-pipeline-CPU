module im_4k(
    input[11:2] addr,//说明只取了pc的 11:2 bits
    output reg [31:0] dout
);//readonly
reg[31:0] im[1023:0];//容量存储1024条指令字, 即4k

integer i;
initial begin
    for(i=0;i<1024;i=i+1)begin
      im[i]=0;
    end
    $readmemh("code.txt",im);
end

always @(addr) begin
    dout<=im[addr];
end


endmodule