`include "/home/vishnu/Documents/IPA/ALU/ADD/adder_1_bit.v"
`include "/home/vishnu/Documents/IPA/ALU/ADD/adder_64_bit.v"

`timescale 1ns / 1ps
module testbench_64_add;
reg signed [63:0]a;
reg signed [63:0]b;
wire signed [63:0]sum;
wire overflow;
adder_64_bit new(a,b,sum,overflow);
initial begin
    $dumpfile("runfile.vcd");
    $dumpvars(0,testbench_64_add);
    a = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    b = 64'b0000000000000000000000000000000000000000000000000000000000000000;

end
initial begin
    $monitor("in1 = ",a," b = ",b,"sum = ",sum," overflow = ",overflow);
    #5
    a = 64'b0000000000000000000000000000000000000000000000001100001101010000;
    b = 64'b0000000000000000000000000000000000000000000000001100001101010000;
    
end
endmodule
