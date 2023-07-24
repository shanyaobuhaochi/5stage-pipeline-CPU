module BranchDetect(//是否满足分支条件（即是否分支跳转）
    input[3:0] Branch,
    input[31:0] busA,
    input Zero,
    output reg meet//1 满足分支条件
);
always @(*) begin
    case (Branch)
        4'b0001:meet=Zero&&(~Branch[3])&&(~Branch[2])&&(~Branch[1])&&Branch[0];
        4'b0011:meet=(~Zero)&&(~Branch[3])&&(~Branch[2])&&Branch[1]&&Branch[0];
        4'b0101:meet=(busA!=0&&!busA[31])&&(~Branch[3])&&Branch[2]&&(~Branch[1])&&Branch[0];
        4'b0111:meet=(busA==0|!busA[31])&&(~Branch[3])&&Branch[2]&&Branch[1]&&Branch[0];
        4'b1001:meet=(busA!=0&&busA[31])&&Branch[3]&&(~Branch[2])&&(~Branch[1])&&Branch[0];
        4'b1011:meet=(busA==0|busA[31])&&Branch[3]&&(~Branch[2])&&Branch[1]&&Branch[0];
        default:meet=1'b0;
    endcase
end
initial begin
    meet=0;
end
endmodule