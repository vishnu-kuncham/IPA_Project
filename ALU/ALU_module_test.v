`include "ALU_module.v"
`timescale 1ns / 1ps
module ALU_test;
    reg signed [63:0]a;
    reg signed [63:0]b;
    wire signed [63:0]ans;
    wire overflow;
    reg [1:0]control;
    ALU call(control,a,b,ans,overflow);
    integer i,j,k;
    initial begin
        $dumpfile("ALU.vcd");
        $dumpvars(0,ALU_test);
        a=64'b0;
		b=64'b0;
        control = 2'b01;
    end
    initial begin
        $monitor("control = ",control," A = ",a," B = ",b," ans = ",ans," overflow = ",overflow);
        // for(i = 0;i<4;i=i+1)begin 
        //     for(j=1;j<4;j=j+1)begin 
        //         for(k=1;k<11;k=k+1)begin 
        //             control=i;a=j<<(j*k);b=k<<(j*k);
        //             #10;
        //         end
        //     end
        // end
        //edge cases
        #10
        // control = 2'b01;
        a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
        b = 64'b0111111111111111111111111111111111111111111111111111111111111111;

        #10
        // control = 2'b01;
        a = 64'b1000000000000000000000000000000000000000000000000000000000000000;
        b = 64'b1000000000000000000000000000000000000000000000000000000000000000;

        #10
        // control = 2'b01;
        a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
        b = 64'b1000000000000000000000000000000000000000000000000000000000000000;

        #10
        // control = 2'b01;
        a = 64'b1000000000000000000000000000000000000000000000000000000000000000;
        b = 64'b0111111111111111111111111111111111111111111111111111111111111111;
    end
endmodule