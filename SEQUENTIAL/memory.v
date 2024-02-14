module memory(clk,icode,valA,valP,valE,valM,m_module_error); //not taking input as valB because we dont use it in memory module
    input clk;
    input [3:0]icode;
    input signed[63:0] valA,valP,valE;
    output reg[63:0]valM;
    output reg m_module_error = 0;
    // output [63:0]m_rsp;
    reg[63:0] memory[255:0]; //a memory module which has 64bit register files
    reg check_valE,check_valA;

    always @(*)begin
        if(icode==4'h4 | icode==4'h5 | icode==4'h8 | icode==4'hB)
            check_valE = 1;
        else
            check_valE = 0;

        if(icode==4'h9 | icode==4'hB)
            check_valA = 1;
        else
            check_valA = 0;
    end

    always @(*)
    begin
        if(icode==4'h4 | icode==4'h5 | icode==4'h8 | icode==4'hB)
            check_valE = 1;
        else
            check_valE = 0;

        if(icode==4'h9 | icode==4'hB)
            check_valA = 1;
        else
            check_valA = 0;
    end

    always @(*)begin
        if((valE>255 & check_valE) | (valA>1023 & check_valA))
         begin   m_module_error = 1; end

        if(icode == 4'h5)begin  //mrmovq
            valM = memory[valE];
        end
        else if(icode == 4'h9 || icode == 4'hB)begin  //ret and popq
            valM = memory[valA]; 
        end //as we assign register valM with value from memory;
    end

    always@ (posedge clk) begin
        if((valE>255 & check_valE))
        begin m_module_error = 1; end
        
        if(icode == 4'h8)begin // call
            memory[valE] <= valP;
        end

        if(icode == 4'hA || icode == 4'h4)begin //pushq   and rmmovq 
            memory[valE] <= valA;
        end
        
    end

endmodule