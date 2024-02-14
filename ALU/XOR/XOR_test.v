`timescale 1ns / 1ps

module testbench_64_xor;
    reg signed [63:0]a;
    reg signed [63:0]b;

    wire signed [63:0]op;

    xor_64_bit new(a,b,op);
    initial begin
        $dumpfile("runfile.vcd");
        $dumpvars(0,testbench_64_xor);
        a = 64'b0000000000000000000000000000000000000000000000000000000000000000;
        b = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    end

    initial begin
        $monitor(" a = ",a," b = ",b," op = ",op);
        #5
        a = 64'b001010;
        b = 64'b001111;   
    end

endmodule