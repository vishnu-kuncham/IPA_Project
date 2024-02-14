`timescale 1ns / 1ps
module adder_64_bit(a,b,sum,overflow);
    input signed [63:0]a;
    input signed [63:0]b;
    output signed[63:0]sum;
    output overflow;
    wire [64:0]carry;
   
    assign carry[0]=1'b0;
    generate
     	genvar i;
        for (i =0;i<64;i= i+1)begin
            adder_1_bit new_call(a[i],b[i],carry[i],sum[i],carry[i+1]);
        end
    endgenerate
    wire temp1,temp2,nota,notb,nots;
    not(nota,a[63]);
    not(notb,b[63]);
    not(nots,sum[63]);
    and(temp1,nots,a[63],b[63]);
    and(temp2,sum[63],nota,notb);
    or(overflow,temp1,temp2);
    
endmodule
