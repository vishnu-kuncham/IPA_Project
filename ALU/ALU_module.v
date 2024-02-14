`timescale 1ns / 1ps
`include "../ALU/ADD/adder_1_bit.v"
`include "../ALU/ADD/adder_64_bit.v"
`include "../ALU//AND/And.v"
`include "../ALU/SUB/complement_2s.v"
`include "../ALU/SUB/sub_64_bit.v"
`include "../ALU/XOR/XOR.v"
module ALU(control,a,b,ans,overflow);
input signed [63:0]a;
input signed [63:0]b;
output signed [63:0]ans;
output overflow;
input [1:0]control;

reg signed [63:0]ans;
reg overflow;

// we make call for every seperate case
wire signed [63:0]sum;
wire signed [63:0]dif;
wire signed [63:0]and_ans;
wire signed [63:0]xor_ans;
wire OF_sub;
wire OF_sum;

//calling modules
adder_64_bit call1(a,b,sum,OF_sum);
sub_64_bit call2(a,b,dif,OF_sub);
and_64_bit call3(a,b,and_ans);
xor_64_bit call4(a,b,xor_ans);


always @(*)begin
    case(control)
        2'b00:begin
            ans = sum;
            overflow = OF_sum;
        end
        2'b01:begin
            ans = dif;
            overflow = OF_sub;
        end
        2'b10:begin
            ans = and_ans;
            overflow = 1'b0;
        end
        2'b11:begin
            ans = xor_ans;
            overflow = 1'b0;
        end
    endcase
end
endmodule