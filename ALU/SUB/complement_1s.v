`timescale 1ns / 1ps
module complement_1_bit(in,out);
input in;
output out;
reg out;
always @(in)begin
if(in == 1'b1)
begin
    out = 1'b0;
end
else 
begin
    out = 1'b1;
end
end
endmodule