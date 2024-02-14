module fetch(clk,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,f_predPC,M_icode,M_cnd,M_valA,W_icode,W_valM,F_predPC,F_stall,D_stall,D_bubble);
//in fetch we can't have bubble but we can have a stall
//we need to check the status codes in fetch and pass it to decode


output reg [3:0]D_icode,D_ifun,D_rA,D_rB;
output reg [0:3]D_stat = 4'b1000; 
output reg signed[63:0] D_valc; //displacement or immediate value
output reg[63:0] D_valP, f_predPC; //predicted PC from fetch stage

input clk, M_cnd; //M_cnd used for jmp
input [3:0] M_icode , W_icode; //check whether we got jmp||ret in previous instruction
input [63:0] M_valA, W_valM; //used when jmp call and return are used
input [63:0] F_predPC; //predicted PC
input F_stall,D_stall,D_bubble;

reg [3:0] icode,ifun,rA,rB;
reg [63:0]valc,valP,PC;
reg mem_error = 0,invalid_instr = 0;
reg [0:3]stat_code;
reg [0:79] instr;
reg [7:0] instr_memory[0:255];//memory that contains all the instructions

initial begin
    // instr_memory[1] = 8'h20; //rrmovq
    // instr_memory[2]  = 8'h03; //ra = 0 and rb =1 and pc = pc + 2 = 3

    // instr_memory[3]  = 8'h30; //irmovq
    // instr_memory[4]  = 8'h02; //F and rb = 2
    // instr_memory[5]  = 8'hFF; //8bytes
    // instr_memory[6]  = 8'hFF;
    // instr_memory[7]  = 8'hFF;
    // instr_memory[8]  = 8'hFF;
    // instr_memory[9]  = 8'hFF;
    // instr_memory[10]  = 8'hFF;
    // instr_memory[11]  = 8'hFF;
    // instr_memory[12]  = 8'hFF; //pc = pc +10 = 13

    // instr_memory[13]  = 8'h60; //opq add
    // instr_memory[14]  = 8'h2A; //ra and rb pc = pc +2  = 15   

    // instr_memory[15]  = 8'h73; //je
    // instr_memory[16]  = 8'h00; //8bytes address
    // instr_memory[17]  = 8'h00;
    // instr_memory[18]  = 8'h00;
    // instr_memory[19]  = 8'h00;
    // instr_memory[20]  = 8'h00;
    // instr_memory[21]  = 8'h00;
    // instr_memory[22]  = 8'h00;
    // instr_memory[23]  = 8'd34; //pc = pc+9 = 24

    
    // instr_memory[33]  = 8'h00;//return and pc = pc+1 = 34; 
    

    // instr_memory[34]  = 8'h10; //popq
    // instr_memory[35]  = 8'h10; //ra and rb pc = pc+2 = 38

    // instr_memory[36] = 8'h10;
    // instr_memory[37] = 8'h10;

    // instr_memory[38]  = 8'h00; //halt

    //hazards checking

// return 
    // instr_memory[60] = 8'h80; //call
    // {instr_memory[61],instr_memory[62],instr_memory[63],instr_memory[64],instr_memory[65],instr_memory[66],instr_memory[67],instr_memory[68]} = 64'd70;

    // instr_memory[69] = 8'h00;

    // instr_memory[70] = 8'h10;
    // instr_memory[71] = 8'h10;


    // instr_memory[72] = 8'h90;

//load hazard
instr_memory[4] = 8'h40;//rmmovq
instr_memory[5] = 8'h54;
{instr_memory[6],instr_memory[7],instr_memory[8],instr_memory[9],instr_memory[10],instr_memory[11],instr_memory[12],instr_memory[13]} = 64'd1;

instr_memory[14] = 8'h50;//mrmovq
instr_memory[15] = 8'h24;
{instr_memory[16],instr_memory[17],instr_memory[18],instr_memory[19],instr_memory[20],instr_memory[21],instr_memory[22],instr_memory[23]} = 64'd1;

instr_memory[24] = 8'h60;
instr_memory[25] = 8'h23;

instr_memory[26] = 8'h10;
instr_memory[27] = 8'h10;
instr_memory[28] = 8'h00;

   //instr memory  
// instr_memory[1]  = 8'h10; //nop

// instr_memory[2] = 8'h20; //rrmovq
// instr_memory[3] = 8'h12;

// instr_memory[4] = 8'h30;//irmovq
// instr_memory[5] = 8'hF2;
// instr_memory[6] = 8'h00;
// instr_memory[7] = 8'h00;
// instr_memory[8] = 8'h00;
// instr_memory[9] = 8'h00;
// instr_memory[10] = 8'h00;
// instr_memory[11] = 8'h00;
// instr_memory[12] = 8'h00;
// instr_memory[13] = 8'b00000010;

// instr_memory[14] = 8'h40;//rmmovq
// instr_memory[15] = 8'h24;
// {instr_memory[16],instr_memory[17],instr_memory[18],instr_memory[19],instr_memory[20],instr_memory[21],instr_memory[22],instr_memory[23]} = 64'd1;

// instr_memory[24] = 8'h40;//rmmovq
// instr_memory[25] = 8'h53;
// {instr_memory[26],instr_memory[27],instr_memory[28],instr_memory[29],instr_memory[30],instr_memory[31],instr_memory[32],instr_memory[33]} = 64'd0;

// instr_memory[34] = 8'h50;//mrmovq
// instr_memory[35] = 8'h53;
// {instr_memory[36],instr_memory[37],instr_memory[38],instr_memory[39],instr_memory[40],instr_memory[41],instr_memory[42],instr_memory[43]} = 64'd0;

// instr_memory[44] = 8'h60; //opq add
// instr_memory[45] = 8'h9A;

// instr_memory[46] = 8'h73; //je
// {instr_memory[47],instr_memory[48],instr_memory[49],instr_memory[50],instr_memory[51],instr_memory[52],instr_memory[53],instr_memory[54]} = 64'd56;

// instr_memory[55] = 8'h00;//halt

// instr_memory[56] = 8'hA0; //pushq
// instr_memory[57] = 8'h9F;

// instr_memory[58] = 8'hB0; //popq
// instr_memory[59] = 8'h9F;

// instr_memory[60] = 8'h80; //call
// {instr_memory[61],instr_memory[62],instr_memory[63],instr_memory[64],instr_memory[65],instr_memory[66],instr_memory[67],instr_memory[68]} = 64'd80;
 
// instr_memory[69] = 8'h60; //opq add
// instr_memory[70] = 8'h56;

// // instr_memory[71] = 8'h00;
// instr_memory[71] = 8'h70; // jmp
// {instr_memory[72],instr_memory[73],instr_memory[74],instr_memory[75],instr_memory[76],instr_memory[77],instr_memory[78],instr_memory[79]} = 64'd46;

// // instr_memory[80] = 8'h63;
// // instr_memory[81] = 8'hDE;
// // instr_memory[80] = 8'h10;

// instr_memory[80] = 8'h30;//irmovq
// instr_memory[81] = 8'hF2;
// instr_memory[82] = 8'h00;
// instr_memory[83] = 8'h00;
// instr_memory[84] = 8'h00;
// instr_memory[85] = 8'h00;
// instr_memory[86] = 8'h00;
// instr_memory[87] = 8'h00;
// instr_memory[88] = 8'h00;
// instr_memory[89] = 8'b00000010;

// instr_memory[90] = 8'h60;//opq add
// instr_memory[91] = 8'h92;

// instr_memory[92] = 8'h10;//nop

// instr_memory[93] = 8'h90;//ret





end

always @(*) begin
    instr = {instr_memory[PC],instr_memory[PC+1],instr_memory[PC+2],
            instr_memory[PC+3],instr_memory[PC+4],instr_memory[PC+5],
            instr_memory[PC+6],instr_memory[PC+7],instr_memory[PC+8],
            instr_memory[PC+9]};  
end

always @(*)begin //for change in every input
    if(W_icode == 4'h9)begin //memory return statement
        PC = W_valM;
    end
    else if(M_icode == 4'h7 & !M_cnd)begin //jmp
        PC = M_valA;
    end
    else begin
        PC = F_predPC; //all cases
    end

end

//minimal changes are applied to fetch block in sequential
always @(*)begin 
    if(PC>255)//here 256 may vary based on our input registers used
    begin
        mem_error = 1;
    end

    {icode,ifun} = instr[0:7];//first register contains icode and ifun
    //now we can know the length of instruction by icode and ifun
    if(icode == 4'h0) //halt
    begin 
        valP = PC;
        f_predPC = valP;

    end
    else if(icode == 4'h1) //nop
    begin
        valP = PC + 1;
        f_predPC = valP;
    end
    else if(icode == 4'h2) // cmovq
    begin
        {rA,rB} = instr[8:15]; //1byte for rA and rB
        valP = PC+2;
        f_predPC = valP;
    end
    else if(icode == 4'h3)//irmovq
    begin
        {rA,rB,valc} = instr[8:79]; //1byte for rA and rB and 8bytes for valc
        valP = PC+10; //10byte instruction
        f_predPC = valP;
    end
    else if(icode == 4'h4) //rmmovq
    begin 
        {rA,rB,valc}=instr[8:79];
        valP = PC+10; //10byte instruction
        f_predPC = valP;
    end
    else if(icode == 4'h5) //mrmovq
    begin
        {rA,rB,valc} = instr[8:79];
        valP = PC+10;//10byte instruction
        f_predPC = valP;
    end
    else if(icode == 4'h6) //OPq
    begin 
        {rA,rB}=instr[8:15];
        valP=PC+2;
        f_predPC = valP;
    end
    else if(icode == 4'h7) //jxx
    begin 
        valc = instr[8:71]; // no ra and rb in jump instruction
        valP = PC+9;
        f_predPC = valc;
    end
    else if(icode == 4'h8) //call
    begin 

        valc = instr[8:71]; // stores the current PC address so that it can be called after the function is executed
        valP = PC+9;
        f_predPC = valc;
    end
    else if(icode == 4'h9) //return
    begin
        valP = PC +1;
    end
    else if(icode == 4'hA) //pushq
    begin 
        {rA,rB}=instr[8:15];
        valP=PC+2;
        f_predPC = valP;
    end
    else if(icode == 4'hB) //popq
    begin
        {rA,rB}=instr[8:15];
        valP=PC+2;
        f_predPC = valP;
    end
    else
    begin 
        invalid_instr = 1'b1;
    end
end

always @(posedge clk)begin

    if(F_stall)begin //used for stalling PC
    end
    if(D_stall == 0)begin
        if(D_bubble)begin
            //installing a nop into decode
            {D_icode,D_ifun,D_rA,D_rB} <= 16'h1000;
            {D_valc,D_valP} <= 128'd0;
            {D_stat} <= 4'b1000;
        end
        else begin
            D_icode <=icode;
            D_ifun <= ifun;
            D_rA <= rA;
            D_rB <= rB;
            D_valc <= valc;
            D_valP <= valP;
            D_stat <=stat_code;
    end
    end
end
//lets update the status codes
always@ (*)begin 
    stat_code = 4'd8;
    if(invalid_instr ==0)begin stat_code = 4'd1;end
    if(mem_error == 1)begin stat_code = 4'd2; end
    if(icode == 4'd0)begin stat_code = 4'h4; end
end

endmodule