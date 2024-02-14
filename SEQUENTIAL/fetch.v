module fetch(clk,icode,ifun,rA,rB,valc,valP,PC,invalid_instr,mem_error,halt,instr);
    input clk;    
    input [63:0] PC; //this points to the address of instruction;
    input [0:79]instr; // the maximum length of any instruction is 10bytes = 80bits
    output reg [3:0] icode,ifun;
    output reg [63:0] valc; //this is where the displacement or destination value in jump is stores;
    output reg [3:0] rA,rB; //registers which stores  the parameters
    output reg [63:0] valP; //updated PC value
    output reg invalid_instr = 0, mem_error = 0; //flages to check memory and second flag is to check valid instruction
    output reg halt=0;
    always @(*) // here * represents all the inputs and any changes in input is sensed
    begin
        if(PC>255)//here 256 may vary based on our input registers used
        begin
            mem_error = 1;
        end
        {icode,ifun} = instr[0:7];//first register contains icode and ifun
        //now we can know the length of instruction by icode and ifun
        if(icode == 4'h0) //halt
        begin 
            halt =1;
            valP = PC+1;
        end
        else if(icode == 4'h1) //nop
        begin
            valP = PC + 1;
        end
        else if(icode == 4'h2) // cmovq
        begin
            {rA,rB} = instr[8:15]; //1byte for rA and rB
            valP = PC+2;
        end
        else if(icode == 4'h3)//irmovq
        begin
            {rA,rB,valc} = instr[8:79]; //1byte for rA and rB and 8bytes for valc
            valP = PC+10; //10byte instruction
        end
        else if(icode == 4'h4) //rmmovq
        begin 
            {rA,rB,valc}=instr[8:79];
            valP = PC+10; //10byte instruction
        end
        else if(icode == 4'h5) //mrmovq
        begin
            {rA,rB,valc} = instr[8:79];
            valP = PC+10;//10byte instruction
        end
        else if(icode == 4'h6) //OPq
        begin 
            {rA,rB}=instr[8:15];
            valP=PC+2;
        end
        else if(icode == 4'h7) //jxx
        begin 
            valc = instr[8:71]; // no ra and rb in jump instruction
            valP = PC+9;
        end
        else if(icode == 4'h8) //call
        begin 

            valc = instr[8:71]; // stores the current PC address so that it can be called after the function is executed
            valP = PC+9;
        end
        else if(icode == 4'h9) //return
        begin
            valP = PC +1;
        end
        else if(icode == 4'hA) //pushq
        begin 
            {rA,rB}=instr[8:15];
            valP=PC+2;
        end
        else if(icode == 4'hB) //popq
        begin
            {rA,rB}=instr[8:15];
            valP=PC+2;
        end
        else
        begin 
            invalid_instr = 1'b1;
        end
    end
endmodule 