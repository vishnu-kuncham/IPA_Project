`timescale 1ns / 1ps
`include "adder_64_bit.v"
`include "complement_1s.v"
`include "complement_2s.v"
`include "adder_1_bit.v"
module complement_2_test;
reg signed [63:0]in;
wire signed [63:0]out;
complement_2s new_call(in,out);
initial begin
    $dumpfile("runfile.vcd");
    $dumpvars(0,complement_2_test);
    in = 64'b0000000000000000000000000000000000000000000000000000000000000000;
end
initial begin
    $monitor("in = ",in," out = ",out);
    in = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    #5
    in = 64'b1111111111111111111111111111111111111111111111111111111110011100;
    #5
    in = 64'b0000000000000000000000000000000000000000000000011110001001000000;
end
endmodule