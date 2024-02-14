`include "fetch.v"
`include "decode_writeback.v"
`include "execute.v"
`include "PC_update.v"
`include "memory.v"
module processor;
    //inputs
    reg clk;
    reg [63:0]PC;
    //outputs
    wire [3:0] icode,ifun,rA,rB;
    wire signed[63:0] valc;
    wire  [63:0]valP,PC_new;
    wire mem_error,invalid_instr;
    reg [7:0] instr_memory[0:255];//memory that contains all the instructions
    reg [0:79] instr; //instruction with 10bytes
    wire signed [63:0]valA,valB,valE;
    wire signed[63:0]valM;
    wire[2:0]cc_out;
    wire cnd;
    reg [2:0]cc_in;
    wire signed[63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;
    reg [0:3]stat_con = 4'b1000;

    wire m_module_error;

    
    //module 1//
/////////////////////////////////////////////////////////////////////////////////////////
fetch fetch_call(clk,icode,ifun,rA,rB,valc,valP,PC,invalid_instr,mem_error,halt,instr);
/////////////////////////////////////////////////////////////////////////////////////////

    //module 2//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
decode decode_call(clk, icode, rA, rB,
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,
              valA,valB,cnd,valM,valE);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    //module 3//
//////////////////////////////////////////////////////////////
execute execute_call(clk,icode,ifun,valA,valB,valc,valE,cnd,cc_out,cc_in);
/////////////////////////////////////////////////////////////


always @(posedge clk)begin 
    if(icode == 4'h6)begin cc_in <= cc_out;end
    
end

    //module 4//
//////////////////////////////////////////////////////////////////
memory memory_call(clk,icode,valA,valP,valE,valM,m_module_error);
/////////////////////////////////////////////////////////////////

    //module 5//
///////////////////////////////////////////////////////////////
pc_update pc_update_call(clk,icode,cnd,valc,valM,valP,PC_new);
//////////////////////////////////////////////////////////////


always @(PC) begin
    instr = {instr_memory[PC],instr_memory[PC+1],instr_memory[PC+2],
            instr_memory[PC+3],instr_memory[PC+4],instr_memory[PC+5],
            instr_memory[PC+6],instr_memory[PC+7],instr_memory[PC+8],
            instr_memory[PC+9]};  
end

always @(halt,mem_error,invalid_instr,m_module_error)begin
    if(halt == 1)begin 
        stat_con = 4'b0100;
        $display("halt instruction");
        $finish;
    end
    if(m_module_error == 1)begin 
        stat_con = 4'b0010;
        $display("memory error in memory module");
        // $display("rsp = %d,PC = %d clk=%d \n\nicode=%h ifun=%h rA=%d rB=%d,valc=%d,valP=%d,\n\nvalA = %d and valB = %d\nvalE = %d valM = %d\nccodes OF,SF,ZF cc_in = %b || cc_out=%b and cnd = %b\n",reg_f4,PC,clk,icode,ifun,rA,rB,valc,valP,valA,valB,valE,valM,cc_in,cc_out,cnd);
        $finish; 
    end
    if(mem_error == 1)begin 
        stat_con = 4'b0010;
        $display("memory error in fetch module");
        $finish; 
    end
    if(invalid_instr == 1)begin 
        stat_con = 4'b0001;
        $display("invalid instruction encountered");
        $finish; 
    end
end
always #10 begin clk = ~clk; end //updating clk for 10ns
always @(*) begin PC<=PC_new; end // updating PC so that new pc value is updated

initial begin//first initialisations
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);
    clk = 0;
    PC = 64'd0;
end

always @(posedge clk)begin $display("1)rsp = %d,PC = %d clk=%d \n\n2)icode=%h ifun=%h rA=%d rB=%d,valc=%d,valP=%d,\n\n3)valA = %d and valB = %d\nvalE = %d valM = %d\nccodes OF,SF,ZF cc_in = %b || cc_out=%b and cnd = %b\n",reg_f4,PC,clk,icode,ifun,rA,rB,valc,valP,valA,valB,valE,valM,cc_in,cc_out,cnd); end
// always @(posedge clk)begin $display( "ccodes ZF,SF,OF cc_in = %b || cc_out=%b and cnd = %b\n",cc_in,cc_out,cnd );end
initial begin
    instr_memory[1]  = 8'h10; //nop

    instr_memory[2] = 8'h20; //rrmovq
    instr_memory[3] = 8'h12;

    instr_memory[4] = 8'h30;//irmovq
    instr_memory[5] = 8'hF2;
    instr_memory[6] = 8'h00;
    instr_memory[7] = 8'h00;
    instr_memory[8] = 8'h00;
    instr_memory[9] = 8'h00;
    instr_memory[10] = 8'h00;
    instr_memory[11] = 8'h00;
    instr_memory[12] = 8'h00;
    instr_memory[13] = 8'b00000010;

    instr_memory[14] = 8'h40;//rmmovq
    instr_memory[15] = 8'h24;
    {instr_memory[16],instr_memory[17],instr_memory[18],instr_memory[19],instr_memory[20],instr_memory[21],instr_memory[22],instr_memory[23]} = 64'd1;

    instr_memory[24] = 8'h40;//rmmovq
    instr_memory[25] = 8'h53;
    {instr_memory[26],instr_memory[27],instr_memory[28],instr_memory[29],instr_memory[30],instr_memory[31],instr_memory[32],instr_memory[33]} = 64'd0;

    instr_memory[34] = 8'h50;//mrmovq
    instr_memory[35] = 8'h53;
    {instr_memory[36],instr_memory[37],instr_memory[38],instr_memory[39],instr_memory[40],instr_memory[41],instr_memory[42],instr_memory[43]} = 64'd0;

    instr_memory[44] = 8'h60;
    instr_memory[45] = 8'h9A;

    instr_memory[46] = 8'h73;
    {instr_memory[47],instr_memory[48],instr_memory[49],instr_memory[50],instr_memory[51],instr_memory[52],instr_memory[53],instr_memory[54]} = 64'd56;

    instr_memory[55] = 8'h00;

    instr_memory[56] = 8'hA0;
    instr_memory[57] = 8'h9F;

    instr_memory[58] = 8'hB0;
    instr_memory[59] = 8'h9F;

    instr_memory[60] = 8'h80;
    {instr_memory[61],instr_memory[62],instr_memory[63],instr_memory[64],instr_memory[65],instr_memory[66],instr_memory[67],instr_memory[68]} = 64'd80;

    instr_memory[69] = 8'h60;
    instr_memory[70] = 8'h56;

    instr_memory[71] = 8'h75;
    {instr_memory[72],instr_memory[73],instr_memory[74],instr_memory[75],instr_memory[76],instr_memory[77],instr_memory[78],instr_memory[79]} = 64'd46;

    instr_memory[80] = 8'h63;
    instr_memory[81] = 8'hDE;
    // instr_memory[82] = 8'h10;
    instr_memory[82] = 8'h90;
// instr_memory[0]  = 8'h10; //nop pc = 1

//     instr_memory[1] = 8'h60;//opq
//     instr_memory[2] = 8'h9A;

//     instr_memory[3] = 8'h72; //jxx
//     {instr_memory[4],instr_memory[5],instr_memory[6],instr_memory[7],instr_memory[8],instr_memory[9],instr_memory[10],
//     instr_memory[11]} = 64'd13;

//     instr_memory[12]  = 8'h00; //halt
    
//     instr_memory[13] = 8'h10; //nop

//     instr_memory[14] = 8'h00; //halt
    
end
    
endmodule   