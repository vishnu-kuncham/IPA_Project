`include "fetch.v"
`include "decode_and_write_back.v"
`include "execute.v"
`include "memory.v"
module memory_tb;
    reg [16:0]cycle;
    reg clk; //inputs as reg
    wire [3:0] M_icode,W_icode;
    wire signed[63:0] W_valM;
    reg [63:0]F_predPC;

    wire [3:0]W_dstE,W_dstM;
    wire signed[63:0] e_valE,m_valM,W_valE;

    wire [3:0] D_icode,D_ifun,D_rA,D_rB,D_stat; //wires as inputs
    wire signed[63:0] D_valc;
    wire [63:0] D_valP,f_predPC;

    wire [0:3]E_stat;
    wire [3:0]E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB;
    wire signed[63:0] E_valA,E_valB,E_valc;
    wire signed [63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;
    wire M_cnd;
    

    wire [3:0]d_srcA,d_srcB;

    //bubbles
    wire E_bubble,D_bubble;
    wire [63:0] d_valA,d_valB;
    wire [0:3]M_stat,m_stat;
    wire [3:0]M_dstE,M_dstM,e_dstE;
    wire signed[63:0] M_valE,M_valA;
    wire e_cnd,M_bubble;
    reg setcc;
    wire[3:0] W_stat;

    wire [2:0]cc;


    
    //calling fetch
    fetch call_fetch(clk,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,f_predPC,M_icode,M_cnd,M_valA,W_icode,W_valM,F_predPC,F_stall,D_stall,D_bubble);

    

    //decode and writeback call
    decode decode_call(clk,D_stat,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstM,
              W_valM,W_dstE,W_valE,W_icode, E_stat,E_icode,E_ifun,E_valc,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,
              d_srcA,d_srcB, E_bubble,//for pipeline control ie to check datade pendency
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,d_valA,d_valB);

    //execute 
    execute execute_call(clk,E_stat,E_icode,E_ifun,E_valc,E_valA,E_valB,E_dstE,E_dstM,//from execute block
               M_stat,M_icode,M_cnd,M_valE,M_valA,M_dstE,M_dstM,//to memory block
               e_cnd,e_valE,e_dstE,W_stat,m_stat,M_bubble,
               setcc,cc);
    //memory
    memory memory_call(clk,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_dstE,M_dstM,
                W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM,m_valM,m_stat);

    //update PC accordingly
    always @(posedge clk) F_predPC <= f_predPC;
    always #10 clk = ~clk;

    //halt condition
    always@(M_icode)begin
            // $display("call me D_icode = %d ,D_ifun = %d ,D_rA = %d",D_icode,D_ifun,D_rA); 
        if(M_icode == 0)begin 
            $display("halt encountered");
            $finish;
        end
    end

    always @(posedge clk)begin 
        // $display("",cycle);
        cycle = cycle + 1;
        $display("cycle = %d clk=%d F_predPC=%d f_predPC_in=%d \n d_srcA = %d d_srcB = %d\ne_cnd = %d e_valE = %d E_valA = %d E_valB = %d E_dstM = %d E_dstE = %d e_dstE = %d OF = %d SF = %d ZF = %d\nD_icode=%b D_ifun=%b D_rA=%b D_rB=%b,valC=%d\n W_valM = %d\nrsp = %d and m_valM = %d M_valA = %d M_valE = %d\nd_valA = %d d_valB = %d\n___________________________________________________________________________________________\n",
                cycle,clk,F_predPC,f_predPC, 
                d_srcA,d_srcB,
                e_cnd,e_valE,E_valA,E_valB,E_dstM,E_dstE,e_dstE, cc[2],cc[1],cc[0],D_icode,D_ifun,D_rA,D_rB,D_valc,W_valM,reg_f4,m_valM,M_valA,M_valE,d_valA,d_valB); //OF SF ZF
        // $display("",)
        end
    initial begin
        F_predPC = 64'd0;
        clk = 0;
        cycle = 0;
        setcc = 1;
    end


endmodule