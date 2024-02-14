`timescale 1ns / 1ps
`include "complement_1s.v"
module complement_1_bit_test;
reg in;
wire out;
complement_1_bit new_call(in,out);
initial begin
    $dumpfile("runfile.vcd");
    $dumpvars(0,complement_1_bit_test);
    in = 1'b0;
end
initial begin
    $monitor("in = ",in," out = ",out);
    #5
    in = 1'b1;
end
endmodule