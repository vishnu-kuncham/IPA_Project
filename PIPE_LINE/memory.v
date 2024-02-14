module memory(clk,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_dstE,M_dstM,
                W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM,m_valM,m_stat);
    
    input clk;
    input [3:0] M_icode;
    input signed[63:0] M_valA,M_valE;
    input M_Cnd;
    input [0:3] M_stat;
    input [3:0] M_dstE,M_dstM;

    output reg[63:0] W_valM,W_valE,m_valM;
    output reg [3:0] W_icode,W_dstE,W_dstM;
    output reg [0:3] W_stat,m_stat;
    
    
    reg m_module_error = 0;
    reg[63:0] memory[255:0]; //a memory module which has 64bit register files



    always @(*)begin
        
        m_module_error = 0;

        if(M_icode == 4'h5)begin  //mrmovq
            if(M_valE>255)begin m_module_error = 1; end
            m_valM = memory[M_valE];
        end

        else if(M_icode == 4'h9 || M_icode == 4'hB)begin  //ret and popq
            if(M_valA>255)begin m_module_error = 1; end
            m_valM = memory[M_valA]; 
        end //as we assign register valM with value from memory;
        else 
        begin
            m_module_error = 0;
        end


        if(m_module_error) begin
            m_stat = 4'b0010;
        end
        else begin
            m_stat = M_stat;
        end
    
    end

    always@ (posedge clk) begin
        
        m_module_error = 0;
        if(M_valE>256)begin
             m_module_error = 1; 
        end

        if(M_icode == 4'h8)begin // call
            memory[M_valE] <= M_valA; // the block labeled “Sel+Fwd A” in decode stage serves two roles.
                                      //It merges the valP signal into the valA signal for later stages
                                      //in order to reduce the amount of state in the pipeline register
        end

        if(M_icode == 4'hA || M_icode == 4'h4)begin //pushq   and rmmovq 
            memory[M_valE] <= M_valA;
        end        
    end


    always@ (posedge clk) begin
        //we dont use stall and bubble specially in memory part
        W_stat <= m_stat;
        W_icode <= M_icode;
        W_valE <= M_valE;
        W_valM <= m_valM;
        W_dstE <= M_dstE;
        W_dstM <= M_dstM;
    end

endmodule