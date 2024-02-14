module pc_update(clk,icode,cnd,valc,valM,valP,PC);
    input clk,cnd;
    input [3:0]icode;
    input [63:0]valc,valM,valP;
    output reg [63:0]PC;

    always@(*) begin
        if(icode == 4'h8)begin PC <= valc; end //call
        else if(icode == 4'h9)begin PC <= valM; end //ret
        else if(icode == 4'h7)begin PC <= (cnd)? valc:valP; end //jmp
        else begin PC <= valP; end
    end

endmodule