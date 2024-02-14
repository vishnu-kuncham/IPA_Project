//decode and write_back
//i wrote both the modules at the same time bacause assigning a register directly with a value and passing it to decode is not happeing in decode so if we give registers
//as output and assign values to them in decode it self we will get the correct answer

module decode(clk, icode, rA, rB,
              reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14,
              valA,valB,cnd,valM,valE);

    input clk,cnd;
    input [3:0] icode,rA,rB;
    output reg signed[63:0] reg_f0,reg_f1,reg_f2,reg_f3,reg_f4,reg_f5,reg_f6,reg_f7,reg_f8,reg_f9,reg_f10,reg_f11,reg_f12,reg_f13,reg_f14; //we have 15 registers in y86-64 processor
    output reg signed[63:0] valA,valB; //value is updated by a 64 bit number from memory and reg data type is used because we will update the values of outputs conditionally
    reg signed[63:0] temp_memory[0:14];
    input signed[63:0] valE;
    input[63:0] valM;

    initial begin
        //we can directly access the registers using RA values so we assign them to a temp_memory where we can access values using indexes
        temp_memory[0] = 64'd12;        //rax
        temp_memory[1] = 64'd10;        //rcx
        temp_memory[2] = 64'd101;       //rdx
        temp_memory[3] = 64'd3;       //rbx
        temp_memory[4] = 64'd254;       //rsp
        temp_memory[5] = 64'd50;        //rbp
        temp_memory[6] = -64'd143;      //rsi
        temp_memory[7] = 64'd10000;     //rdi
        temp_memory[8] = 64'd990000;    //r8
        temp_memory[9] = -64'd12345;    //r9
        temp_memory[10] = 64'd12345;    //r10
        temp_memory[11] = 64'd10112;    //r11
        temp_memory[12] = 64'd0;        //r12
        temp_memory[13] = 64'd1567;     //r13
        temp_memory[14] = 64'd8643;     //r14
    end
    always @(*) //executes when any of the inputs is changed
    //in decode instruction we read the operands valA and valB from the register file
    begin 
        if(icode == 4'h2 | icode == 4'h3)begin
            valB = 64'd0; //irmovq and cmovxx condition is joined together
        end
        if(icode == 4'h2 | icode == 4'h4 | icode == 4'h6 | icode == 4'hA)begin //cmovxx,rmmovq,opq,pushq
            valA = temp_memory[rA];
        end
        if(icode == 4'h4 | icode == 4'h5 | icode == 4'h6)begin 
            valB = temp_memory[rB]; //rmmovq , mrmovq , opq
        end
        if(icode == 4'h8 | icode == 4'h9 | icode == 4'hA | icode == 4'hB)begin
            valB = temp_memory[4]; //call,return,pushq,popq
        end
        if(icode == 4'h9 | icode == 4'hB)begin//return popq

            valA = temp_memory[4]; //for push and popq the values are taken from %rsp register whose value is 4
        end      
    end

////////////////              //////////////////
///////////////  write back  //////////////////
//////////////              //////////////////

    always@(posedge clk)begin 

        if(icode==4'h3 | icode==4'h6)begin
            temp_memory[rB]=valE; //irmovq and opq
        end
        if(icode==4'h5 | icode==4'hB)begin 
            temp_memory[rA] = valM; //mrmovq and popq
        end
        if(icode==4'h8 | icode==4'h9 | icode==4'hA | icode==4'hB) begin
            temp_memory[4] = valE; //call,ret,pushq,popq
        end
        if(icode==4'h2)begin
            if(cnd)begin//cmovxx
                temp_memory[rB]=valE;
            end
        end
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