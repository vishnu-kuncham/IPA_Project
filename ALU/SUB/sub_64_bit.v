`timescale 1ns / 1ps

module sub_64_bit(a,b,dif,overflow);
    input signed [63:0] a;
    input signed [63:0] b;
    output signed [63:0] dif;
    output overflow;

    wire signed [63:0] c;
    complement_2s call1(b,c);

    wire temp;
    adder_64_bit call2(a,c,dif,temp);

    wire nota,notb,nots;
    wire temp1,temp2;
    not(nots,dif[63]);
    not(nota,a[63]);
    not(notb,b[63]);
    and(temp1,nots,a[63],notb);
    and(temp2,dif[63],nota,b[63]);
    or(overflow,temp1,temp2);
endmodule