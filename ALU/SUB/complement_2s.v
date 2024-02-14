`timescale 1ns / 1ps
module complement_2s(in,out);
input [63:0]in;
output [63:0]out;
wire [63:0]temp;
wire [63:0]out1;
assign temp = 64'b1;
genvar i;
for(i = 0;i<64;i= i+1)
begin
    not(out1[i],in[i]);
end
wire overflow;
adder_64_bit call(temp,out1,out,overflow);
endmodule
