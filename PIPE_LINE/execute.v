`include "../ALU/ALU_module.v"
module execute(clk,E_stat,E_icode,E_ifun,E_valc,E_valA,E_valB,E_dstE,E_dstM,//from execute block
               M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,//to memory block
               e_cnd,e_valE,e_dstE,W_stat,m_stat,M_bubble,
               setcc,cc);//this is used when our instruction is opq because cc gets updated in that case only
    //inputs
    input clk,M_bubble,setcc;
    input [0:3]E_stat;
    input [3:0] E_icode,E_ifun,E_dstE,E_dstM;
    input [63:0] E_valc,E_valA,E_valB;

    //outputs
    output reg M_cnd;
    output reg [0:3]M_stat;
    output reg[3:0] M_icode,M_dstE,M_dstM;
    output reg[63:0] M_valE,M_valA;
    output reg [2:0] cc = 3'b000;

    //current block operators
    output reg e_cnd = 0;
    output reg [63:0] e_valE;
    output reg[3:0] e_dstE;
    output reg [0:3] W_stat,m_stat;


reg [1:0]control;
wire [63:0] valE_cm,valE_op,valE_A,valE_id;
wire cout,OF,temp_OF;//used for sending to alu
//valE_cm => used for cmovxx 
//valE_op => used for op 
//valE_A ie valE_assign used for  irmovq.rmmovq,mrmovq
//valE_inc for incrementation in ret and popq annd decrementation in pushq and call
always @(*)begin
    control = (E_icode == 4'h6)? E_ifun[1:0]:(E_icode == 4'h8 || E_icode == 4'hA)? 2'b1:2'b0;
end
// ALU cm(valE_cm,cout,temp_OF,2'b0,valA,valB);
ALU op(control,E_valA,E_valB,valE_op,OF);//overflow flag is taken from  ALU
ALU cm(control,E_valA,E_valB,valE_cm,temp_OF); //we dont use OF here because OF is updated only in opq operations
ALU ass_ign(control,E_valc,E_valB,valE_A,temp_OF);
ALU inc_dec(control,E_valB,64'd1,valE_id,temp_OF);

//(out, Cout, OF, control, A, B);
//control,a,b,ans,overflow => mine

always @(*)
begin
    e_valE = 0;
    if(E_icode == 4'h3 || E_icode == 4'h4 || E_icode == 4'h5)begin
        e_valE = valE_A;
    end
    else if(E_icode == 4'h2)begin 
        e_valE = valE_cm;
    end
    else if(E_icode == 4'h8 || E_icode == 4'hA || E_icode == 4'h9 ||  E_icode == 4'hB)begin 
        e_valE = valE_id;
    end
    else if(E_icode == 4'h6)begin 
        e_valE = valE_op;
        if(setcc == 1)begin
        cc[2] <= OF;
        cc[1] <= e_valE[63];
        cc[0] <= (e_valE == 0)? 1'b1:1'b0;
        end
    end
    else if(E_icode == 4'h7)begin end
    else 
    begin
        cc = 3'd0;
    end
end

assign zf = cc[0];
assign sf = cc[1];
assign of = cc[2];

always @(*)
begin
    if(E_icode == 2 || E_icode == 7) //we raise cnd when we encounter cmovxx and jxx
    begin
        if(E_ifun == 4'h0)begin 
            e_cnd = 1; //unconditional
        end
        else if(E_ifun== 4'h1)begin 
            e_cnd = (of^sf)|zf; //le
        end
        else if(E_ifun == 4'h2)begin
            e_cnd = (of^sf); //l
        end
        else if(E_ifun == 4'h3)begin 
            e_cnd = zf; //e
        end
        else if(E_ifun == 4'h4)begin
            e_cnd = ~zf;  //ne
        end
        else if(E_ifun == 4'h5)begin
            e_cnd = ~(of^sf);  //ge
        end
        else if(E_ifun == 4'h6)begin
            e_cnd = ~(of^sf) & ~(zf); //g
        end
        else begin e_cnd = 0; end
        e_dstE = e_cnd? E_dstE:4'hF;
    end
    else
    begin 
        e_dstE = E_dstE;
    end
    
end
always@(posedge clk)begin
        if(M_bubble)begin 
            M_stat<= 4'b1000;
            M_icode <= 4'h1;
            M_cnd <= 1;
            {M_valE,M_valA} <= 128'd0;
            {M_dstE,M_dstM} <= 8'hFF;
        end
        else begin
            M_stat <= E_stat;
            M_icode <= E_icode;
            M_cnd <= e_cnd;
            M_valE <= e_valE;
            M_valA <= E_valA;
            M_dstE <= e_dstE;
            M_dstM <= E_dstM;
        end
    end
endmodule