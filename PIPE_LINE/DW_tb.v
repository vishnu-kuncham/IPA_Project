`include "fetch.v"
`include "decode_and_write_back.v"
module DW_tb;
    reg cycle;
    reg clk; //inputs as reg
    reg [3:0] M_icode,W_icode;
    reg signed[63:0] M_valA,W_valM;
    reg [63:0]F_predPC;

    reg [3:0]e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
    reg [63:0] e_valE,M_valE,m_valM,W_valE;

    wire [3:0] D_icode,D_ifun,D_rA,D_rB,D_stat; //wires as inputs
    wire signed[63:0] D_valc;
    wire [63:0] D_valP,f_predPC;

    wire [0:3]E_stat;
    wire [3:0]E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB;
    wire signed[63:0] E_valA,E_valB,E_valc;
    wire signed [63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;

    wire [3:0]d_srcA,d_srcB;
    wire [63:0]d_valA,d_valB;
    
    //calling fetch
    fetch call_fetch(clk,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,f_predPC,M_icode,M_cnd,M_valA,W_icode,W_valM,F_predPC,F_stall,D_stall,D_bubble);

    

    //decode and writeback call
    decode decode_call(clk,D_stat,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstM,
              W_valM,W_dstE,W_valE,W_icode, E_stat,E_icode,E_ifun,E_valc,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,
              d_srcA,d_srcB, E_bubble,//for pipeline control ie to check datade pendency
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,d_valA,d_valB);

    //update PC accordingly
    always @(posedge clk) if(!F_stall) F_predPC <= f_predPC;
    always #10 clk = ~clk;

    //halt condition
    always@(E_icode)begin
            // $display("call me D_icode = %d ,D_ifun = %d ,D_rA = %d",D_icode,D_ifun,D_rA); 
        if(D_icode == 0)begin 
            $finish;
        end
    end

    always @(posedge clk)begin 
        // $display("",cycle);
        $display("cycle = %d clk=%d F_predPC=%d f_predPC_in=%d D_icode=%b D_ifun=%b D_rA=%b D_rB=%b,valC=%d\nE_valA = %d E_valB = %d d_srcA = %d d_srcB = %d\n____________________________________\n",
                cycle,clk,F_predPC,f_predPC, D_icode,D_ifun,D_rA,D_rB,D_valc,E_valA,E_valB,d_srcA,d_srcB); 
        // $display("",)
        end
    initial begin
        F_predPC = 64'd1;
        clk = 0;
    end
    initial begin 
        $dumpfile("Decode_and_Write_tb.vcd");
        $dumpvars(0, DW_tb);
    end

endmodule