`include "fetch.v"

module fetch_tb;
    reg clk; //inputs as reg
    reg [3:0] M_icode,W_icode;
    reg signed[63:0] M_valA,W_valM;
    reg [63:0]F_predPC;
    reg F_stall;
    wire [3:0] D_icode,D_ifun,D_rA,D_rB,D_stat; //wires as inputs
    wire signed[63:0] D_valc;
    wire [63:0] D_valP,f_predPC;
    reg D_bubble;
    reg D_stall;
    

    fetch call_fetch(clk,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,f_predPC,M_icode,M_cnd,M_valA,W_icode,W_valM,F_predPC,F_stall,D_stall,D_bubble);

    always @(posedge clk) if(!F_stall) F_predPC <= f_predPC;
    always #10 clk = ~clk;

    always@(D_icode)begin 
        if(D_icode == 0)begin 
            $finish;
        end
    end

    always @(posedge clk)begin $display("F_stall = %d D_bubble = %d clk=%d F_predPC=%d f_predPC_in=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d\n",F_stall,D_bubble,clk,F_predPC,f_predPC, D_icode,D_ifun,D_rA,D_rB,D_valc); end
    initial begin
        F_predPC = 64'd1;
        clk = 0;
        #10
        F_stall = 1;
        D_bubble = 1;
        D_stall = 0;
        #10
        F_stall = 0;
        D_bubble = 0;
    end
    initial begin 
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0, fetch_tb);
    end

endmodule