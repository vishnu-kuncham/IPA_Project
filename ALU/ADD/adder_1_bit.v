`timescale 1ns / 1ps
module adder_1_bit(a,b,cin,sum,cout);
    input a,b,cin;
    output sum,cout;
    wire sum1,c1,c2;
    xor(sum1,a,b);
    xor(sum,sum1,cin);
    and(c1,a,b);
    and(c2,sum1,cin);
    or(cout,c1,c2);

endmodule