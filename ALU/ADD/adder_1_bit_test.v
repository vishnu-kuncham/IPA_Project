`include "adder_1_bit.v"
`timescale 1ns / 1ps
module testbench_1_add;
reg a,b,cin;
wire cout,sum;
adder_1_bit add(a,b,cin,sum,cout);
initial begin
    $dumpfile("runfile.vcd");
    $dumpvars(0,testbench_1_add);
    a = 1'b0;
    b = 1'b0;
    cin = 1'b0;
end
initial begin
    $monitor("sum = ",sum," carry = ",cout);
    #5
    a = 1'b0;
    b = 1'b0;
    cin = 1'b1;
    #5
    a = 1'b0;
    b = 1'b1;
    cin = 1'b0;
    #5
    a = 1'b0;
    b = 1'b1;
    cin = 1'b1;
    #5
    a = 1'b1;
    b = 1'b0;
    cin = 1'b0;
    #5
    a = 1'b1;
    b = 1'b0;
    cin = 1'b1;
    #5
    a = 1'b1;
    b = 1'b1;
    cin = 1'b0;
    #5
    a = 1'b1;
    b = 1'b1;
    cin = 1'b1;
end
endmodule