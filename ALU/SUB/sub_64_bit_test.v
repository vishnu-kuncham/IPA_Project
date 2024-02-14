`timescale 1ns / 1ps

module testbench_64_sub;
    reg signed [63:0]a;
    reg signed [63:0]b;

    wire signed [63:0]dif;
    wire overflow;

    sub_64_bit new(a,b,dif,overflow);
    initial begin
        $dumpfile("runfile.vcd");
        $dumpvars(0,testbench_64_sub);
        a = 64'b0000000000000000000000000000000000000000000000000000000000000000;
        b = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    end

    initial begin
        $monitor(" a = ",a," b = ",b," dif = ",dif," overflow = ",overflow);
        #5
        a = 64'b0000000000000000000000000000000000000000000000001100001101010000;
        b = 64'b1000000000000000000000000000000000000000000000001000001101010000;       
    end

endmodule