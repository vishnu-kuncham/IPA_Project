`include "fetch.v"
module fetch_tb;
    //inputs
    reg clk;
    reg [63:0]PC;
    //outputs
    wire [3:0] icode,ifun,rA,rB;
    wire signed[63:0] valc;
    wire  [63:0]valP;
    wire mem_error,invalid_instr;
    reg [7:0] instr_memory[0:255];//memory that contains all the instructions
    reg [0:79] instr; //instruction with 10bytes


fetch fetch_call(clk,icode,ifun,rA,rB,valc,valP,PC,invalid_instr,mem_error,halt,instr);

always @(PC) begin
    instr = {instr_memory[PC],instr_memory[PC+1],instr_memory[PC+2],
            instr_memory[PC+3],instr_memory[PC+4],instr_memory[PC+5],
            instr_memory[PC+6],instr_memory[PC+7],instr_memory[PC+8],
            instr_memory[PC+9]};  
end

always@(icode) begin 
    if(halt == 1)begin
        $finish; //stops the program if halt is encountered
    end
end

always@(mem_error) begin 
    if(mem_error == 1)begin 
        $display("memory full...so halting the program\n");
        $finish;
    end
end

always@(invalid_instr) begin 
    if(invalid_instr == 1)begin
        $display("warning you have given an invald instruction so we will move to the next instruction now automatically pc is updated\nnow PC = %d",PC+1,"\n");
        PC = PC +1;
    end
end


always #10 begin clk = ~clk; end //updating clk for 10ns
always @(posedge clk) begin PC<=valP; end // updating PC so that new pc value is updated


initial begin
    $dumpfile("fetch_tb.vcd");
    $dumpvars(0, fetch_tb);
    clk = 0;
    PC = 64'd0;
end

always @(posedge clk)begin $display("clk=%d PC=%d icode=4'b%b ifun=4'b%b rA=4'b%b rB=4'b%b,valc=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valc,valP); end

initial begin

    instr_memory[0]  = 8'h10; //nop pc = 1

    instr_memory[1] = 8'h60;//opq
    instr_memory[2] = 8'h9A;

    instr_memory[3] = 8'h70; //jxx
    {instr_memory[4],instr_memory[5],instr_memory[6],instr_memory[7],instr_memory[8],instr_memory[9],instr_memory[10],
    instr_memory[11]} = 64'd13;

    instr_memory[12]  = 8'h00; //halt
    
    instr_memory[13] = 8'h10; //nop

    instr_memory[14] = 8'h00; //halt
    
end
    
endmodule