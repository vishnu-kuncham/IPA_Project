module decode(clk,D_stat,D_icode,D_ifun,D_rA,D_rB,D_valc,D_valP,e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstM,
              W_valM,W_dstE,W_valE,W_icode, E_stat,E_icode,E_ifun,E_valc,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,
              d_srcA,d_srcB, E_bubble,//for pipeline control ie to check datade pendency
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,d_valA,d_valB);
    //input declarations
    input clk,E_bubble;
    input [3:0] D_icode,D_ifun,D_rA,D_rB,W_icode,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM;
    input [0:3]D_stat; //receives from fetch block whether to check if instruction went normal or not
    input [63:0] e_valE,M_valE,m_valM,W_valM,W_valE,D_valc,D_valP;
    //output declarations
    output reg [0:3]E_stat;
    output reg [3:0] E_icode,E_ifun,E_dstE,E_dstM,E_srcA,E_srcB,d_srcA,d_srcB;
    output reg[63:0] E_valc,E_valA,E_valB;
    output reg[63:0]reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14;
    

    //locally used variables declarations as reg's
    reg[63:0] d_rvalA,d_rvalB;//input to the forwarding logic block
    output reg[63:0] d_valA,d_valB;//output from forward logic block
    reg signed[63:0] temp_memory[0:14]; //declaration of an array for our 15 registers
    reg[3:0] d_dstE,d_dstM ;
    initial begin
         

        //we can directly access the registers using RA values so we assign them to a temp_memory where we can access values using indexes
        temp_memory[0] = 64'd12;        //rax
        temp_memory[1] = 64'd10;        //rcx
        temp_memory[2] = -64'd10;       //rdx
        temp_memory[3] = 64'd3;       //rbx
        temp_memory[4] = 64'd254;       //rsp
        temp_memory[5] = 64'd50;        //rbp
        temp_memory[6] = -64'd143;      //rsi
        temp_memory[7] = 64'd10000;     //rdi
        temp_memory[8] = 64'd990000;    //r8
        temp_memory[9] = -64'd12345;    //r9
        temp_memory[10] = 64'd12345;    //r10
        temp_memory[11] = 64'd10112;    //r11
        temp_memory[12] = 64'd10;        //r12
        temp_memory[13] = 64'd1567;     //r13
        temp_memory[14] = 64'd8643;     //r14
    end

    always @(*)
    begin 
        d_dstE = 4'hF;
        d_dstM = 4'hF;
        d_srcA = 4'hF;
        d_srcB = 4'hF;
        // $display("hello D_icode= %d D_ifun = %d, D_rA = %d ",D_icode,D_ifun,D_rA);
        //src address contains the data.
        //destination address helps us to update the computed operation in specified destination adderess
        // $display("entered");
        if(D_icode == 4'h2 || D_icode == 4'h4 || D_icode == 4'h6 || D_icode == 4'hA)begin 
            // $display("hi1");
            d_srcA = D_rA;
        end
        if(D_icode == 4'h4 || D_icode == 4'h5 || D_icode == 4'h6)begin
            // $display("hi2");
            d_srcB = D_rB;
        end
        if(D_icode == 4'h2 || D_icode == 4'h3 || D_icode == 4'h6)begin 
            // $display("hi3");
            d_dstE = D_rB;
        end
        if(D_icode == 4'h5 || D_icode == 4'hB)begin
            // $display("hi4");
            d_dstM = D_rA;
        end
        if(D_icode == 4'h9 || D_icode == 4'hB)begin
            // $display("hi5");
            d_srcA = 4'h4;
        end
        if(D_icode == 4'h8 || D_icode == 4'h9 || D_icode == 4'hA || D_icode == 4'hB)begin
            // $display("hi6");
            d_srcB = 4'h4;
        end
        if(D_icode == 4'h8 || D_icode == 4'h9 || D_icode == 4'hA || D_icode == 4'hB)begin
            // $display("hi7");
            d_dstE = 4'h4;
        end

        
    end

always @(*)begin
        //now we need to assign d_rvalA and d_rvalB which are inputs for forwarding block

        if(D_icode == 4'h2 || D_icode == 4'h3)begin
            // $display("hi9");
            d_rvalB = 64'd0; //irmovq and cmovxx condition is joined together
        end
        if(D_icode == 4'h2 || D_icode == 4'h4 || D_icode == 4'h6 || D_icode == 4'hA)begin //cmovxx,rmmovq,opq,pushq
            d_rvalA = temp_memory[D_rA];
        end
        if(D_icode == 4'h4 || D_icode == 4'h5 || D_icode == 4'h6)begin 
            d_rvalB = temp_memory[D_rB]; //rmmovq , mrmovq , opq
        end
        if(D_icode == 4'h8 || D_icode == 4'h9 || D_icode == 4'hA || D_icode == 4'hB)begin
            d_rvalB = temp_memory[4'h4]; //call,return,pushq,popq
        end
        if(D_icode == 4'h9 || D_icode == 4'hB)begin//return popq

            d_rvalA = temp_memory[4'h4]; //for push and popq the values are taken from %rsp register whose value is 4
        end  
end

always @(*)begin
        //the above logic is used in sequential but now we need to extend our concept to forwarding
        //lets write the cases of forwarding
        //forwarding cases for A. most often when output of previous operation is input to current operation we can use forrwarrding
        if(D_icode == 4'h7 || D_icode == 4'h8)begin
            // $display("hi1");
            d_valA = D_valP; //we assume that the condition is true;
            //decode merges the valP signal into the valA signal for later stages and
            //in order to reduce the amount of state in the pipeline register
        end
        else if(d_srcA == e_dstE & e_dstE!=4'hF)begin
            // $display("hi2");
            d_valA = e_valE;
        end
        else if(d_srcA == M_dstM && M_dstM!=4'hF)begin
            // $display("hi3"); 
            d_valA = m_valM;
        end
        else if(d_srcA == W_dstM && W_dstM != 4'hF)begin
            // $display("hi4");
            d_valA = W_valM;
        end
        else if(d_srcA == M_dstE && M_dstE != 4'hF)begin
            // $display("hi5");
            d_valA = M_valE;
        end
        else if(d_srcA == W_dstE && W_dstE!= 4'hF)begin
            // $display("hi6");
            d_valA = W_valE;
        end
        else begin 
            // $display("hi7");
            d_valA = d_rvalA;
        end
end

        //^^^^^^^^^^^^^^^^^^^^^
        //referred from textbook 
always @(*)begin
        //forwarding logic for d_valB
        if(d_srcB == e_dstE && e_dstE!= 4'hF)begin
            d_valB = e_valE;
        end
        else if(d_srcB == M_dstM && M_dstM!=4'hF)begin 
            d_valB = m_valM;
        end
        else if(d_srcB == W_dstM && W_dstM != 4'hF)begin
            d_valB = W_valM;
        end
        else if(d_srcB == M_dstE && M_dstE != 4'hF)begin
            d_valB = M_valE;
        end
        else if(d_srcB == W_dstE && W_dstE!= 4'hF)begin
            d_valB = W_valE;
        end
        else begin 
            d_valB = d_rvalB;
        end
end
    //now we need to update values that should be given to execute
    always@(posedge clk)begin 

        //we dont have any operation which includes stall in execute so its waste of use to implement stall in execute so we dont take E_stall here

        if(E_bubble)begin
            E_stat<= 4'b1000;
            {E_icode,E_ifun} = 8'h10;
            {E_valc,E_valA,E_valB} = 192'd0;
            {E_dstE,E_dstM,E_srcA,E_srcB}= 16'hFFFF;
        end
        else begin
            // $display("hello");
            E_stat <= D_stat;
            E_icode <= D_icode;
            E_ifun <= D_ifun;
            E_valc <= D_valc;
            E_valA <= d_valA;
            E_valB <= d_valB;
            E_srcA <= d_srcA;
            E_srcB <= d_srcB;
            E_dstE <= d_dstE;
            E_dstM <= d_dstM;
        end

    end
//end of decode block

//writeback block
always@(posedge clk)begin
    //the values that need to be updated in destination is either valE or valM which are computational values. so in write back we will update them to their respective destinations
    //example: lets take mrmovq where we need to take value from memory.
    //we need value from memory which is valM so we wait until memory stage and data froward the value and store that in destination register
    if(W_icode == 4'h2 || W_icode == 4'h3 || W_icode == 4'h6 || W_icode == 4'h8 || W_icode == 4'h9 || W_icode == 4'hA || W_icode == 4'hB)
    begin temp_memory[W_dstE] = W_valE; end
    if(W_icode == 4'h5 || W_icode == 4'hB)
    begin temp_memory[W_dstM] = W_valM; end

    reg_f0 <= temp_memory[0];
    reg_f1 <= temp_memory[1];
    reg_f2 <= temp_memory[2];
    reg_f3 <= temp_memory[3];
    reg_f4 <= temp_memory[4];
    reg_f5 <= temp_memory[5];
    reg_f6 <= temp_memory[6];
    reg_f7 <= temp_memory[7];
    reg_f8 <= temp_memory[8];
    reg_f9 <= temp_memory[9];
    reg_f10 <= temp_memory[10];
    reg_f11 <= temp_memory[11];
    reg_f12 <= temp_memory[12];
    reg_f13 <= temp_memory[13];
    reg_f14 <= temp_memory[14];

end
endmodule