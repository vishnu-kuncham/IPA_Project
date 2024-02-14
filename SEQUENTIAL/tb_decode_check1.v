`include "fetch.v"
`include "decode.v"
module decode_tb;
    //inputs
    reg clk;
    //outputs
     reg[3:0] icode,ifun,rA,rB;
    wire mem_error,invalid_instr;
    wire signed [63:0]valA,valB,valE;
    wire signed [63:0]valM;

    reg cnd = 1;
    wire signed[63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
decode decode_call(clk, icode, rA, rB,
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,
              valA,valB,cnd,valM,valE);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// always #10 begin clk = ~clk; end //updating clk for 10ns

initial begin
    $dumpfile("decode_tb.vcd");
    $dumpvars(0, decode_tb);
    clk = 0;

end
initial begin
    #10
   clk=1; icode=4'b0001 ;ifun=4'b0000 ;rA=4'bxxxx ;rB=4'bxxxx; 
    #10
    clk=1; icode=4'b0010 ;ifun=4'b0000 ;rA=4'b0000 ;rB=4'b0001; 
#10
    clk=1; icode=4'b0011 ;ifun=4'b0000 ;rA=4'b0000 ;rB=4'b0010; 
#10
    clk=1; icode=4'b0110 ;ifun=4'b0000 ;rA=4'b0010 ;rB=4'b0011; 
#10
    clk=1; icode=4'b0111 ;ifun=4'b0000 ;rA=4'b0010 ;rB=4'b0011; 
#10
    clk=1; icode=4'b1000 ;ifun=4'b0000 ;rA=4'b0010 ;rB=4'b0011;
#10
    clk=1; icode=4'b1001 ;ifun=4'b0000 ;rA=4'b0010 ;rB=4'b0011;
#10
    clk=1; icode=4'b1010 ;ifun=4'b0000 ;rA=4'b0011 ;rB=4'b0000;
#10
    clk=1; icode=4'b1011 ;ifun=4'b0000 ;rA=4'b0011 ;rB=4'b0000;
#10
    clk=1; icode=4'b1011 ;ifun=4'b0000 ;rA=4'b0011 ;rB=4'b0000;
end
initial begin
 $monitor("clk=%d  icode=%h ifun=%h rA=%d rB=%d,,valA = %d and valB = %d\n",clk,icode,ifun,rA,rB,valA,valB);end

    
endmodule