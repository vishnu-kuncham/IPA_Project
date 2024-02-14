`timescale 1ns / 1ps
module testbench_64_and;
reg signed [63:0]a;
reg signed [63:0]b;
wire signed [63:0]ans;
and_64_bit call(a,b,ans);
initial begin
    $dumpfile("runfile.vcd");
    $dumpvars(0,testbench_64_and);
    a = 64'b0;
    b = 64'b0;

end
initial begin
    $monitor("a = ",a," b = ",b," ans = ",ans);
    #5
    a = 64'b1100001101010000;
    b = 64'b1100001101010000;
    #5
    a = 64'b1100001101010000;
    b = 64'b1100001100010000;
    #5
    a = 64'b0110;
    b = 64'b0001;
    
end
endmodule