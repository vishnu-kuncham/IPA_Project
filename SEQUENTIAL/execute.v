`include "../ALU/ALU_module.v"
module execute(clk,icode,ifun,valA,valB,valc,valE,cnd,cc_out,cc_in);
//ccin is the input codition codes and used when we execute jump instructions
//ccout is the register which stores output flags the order is ZF, SF and OF
//valE stores the final value after operation is done
//cnd gives whether the condition is satisifed or not
input [3:0] ifun,icode;
input clk;
input [2:0]cc_in;
input signed[63:0] valA,valB,valc;
// input [2:0] ccin;
output reg cnd;
output reg [63:0] valE;
output reg [2:0] cc_out;

// reg [1:0]control;

wire signed[63:0] valE_AB,valE_CB,valE_OP,valE_inc,valE_dec;
wire OF,temp_OF;//used for sending to alu


// ALU cm(valE_cm,cout,temp_OF,2'b0,valA,valB);
ALU AB(2'b0,valA,valB,valE_AB,temp_OF);
ALU op(ifun[1:0],valA,valB,valE_OP,OF);//overflow flag is taken from  ALU
ALU cb(2'b0,valc,valB,valE_CB,temp_OF); //we dont use OF here because OF is updated only in opq operations
ALU inc(2'b0,valB,64'd1,valE_inc,temp_OF);
ALU dec(2'b1,valB,64'd1,valE_dec,temp_OF);
//(out, Cout, OF, control, A, B);
//control,a,b,ans,overflow => mine

always @(*)
begin
    valE = 0;
    if(icode == 4'h2)begin
        valE = valE_AB; //cmovxx
    end
    else if(icode == 4'h3)begin 
        valE = valE_CB; //irmovq
    end
    else if(icode == 4'h4)begin 
        valE = valE_CB;//rmmovq
    end
    else if(icode == 4'h5)begin 
        valE = valE_CB;//mrmovq
    end
    else if(icode == 4'h6)begin                  // opq
            valE=valE_OP;
            cc_out[2] <= OF;
            cc_out[1] <= valE[63];
            cc_out[0] <= valE ? 0:1;
    end
    else if(icode == 4'h8)begin valE=valE_dec;end  // call
    else if(icode == 4'h9) begin valE=valE_inc; end       // ret
    else if(icode == 4'hA)begin valE=valE_dec; end       // pushq
    else if(icode == 4'hB)begin valE=valE_inc;  end      // popq
    // if(icode == 4'h3 || icode == 4'h4 || icode == 4'h5)begin
    //     valE = valE_A;
    // end
    // else if(icode == 4'h2)begin 
    //     valE = valE_cm;
    // end
    // else if(icode == 4'h8 || icode == 4'hA || icode == 4'h9 ||  icode == 4'hB)begin 
    //     valE = valE_id;
    // end
    // else if(icode == 4'h6)begin 
    //     valE = valE_op;
    //     cc_out[2] <= OF;
    //     cc_out[1] <= valE[63];
    //     cc_out[0] <= (valE == 0)? 1'b1:1'b0;
    // end
    // else if(icode == 4'h7)begin end

end
wire zf,sf,of;
assign zf = cc_in[0];
assign sf = cc_in[1];
assign of = cc_in[2];

always @(posedge clk)
begin
    if(icode == 2 | icode == 7) //we raise cnd when we encounter cmovxx and jxx
    begin
        if(ifun == 4'h0)begin 
            cnd = 1; //unconditional
        end
        else if(ifun== 4'h1)begin 
            cnd = (of^sf)|zf; //le
        end
        else if(ifun == 4'h2)begin
            cnd = (of^sf); //l
        end
        else if(ifun == 4'h3)begin 
            cnd = zf; //e
        end
        else if(ifun == 4'h4)begin
            cnd = ~zf;  //ne
        end
        else if(ifun == 4'h5)begin
            cnd = ~(of^sf);  //ge
        end
        else if(ifun == 4'h6)begin
            cnd = ~(of^sf) & ~(zf); //g
        end
        else begin
            cnd=0; 
            end
    end
end
endmodule

