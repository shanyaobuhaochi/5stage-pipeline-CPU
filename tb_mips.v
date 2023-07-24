`timescale 1ps/1ps
`include "mips.v"

module test();
reg clk,rst;
mips cpu(clk,rst);
always #5 clk=~clk;
initial begin
    $dumpfile("tb_mips_wave.vcd");
    $dumpvars;
    clk=0;
    rst=1;
    #4 rst=0;
    #6 rst=1;
end

endmodule