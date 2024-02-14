`include "execute.v"
module executesupertb ( ) ;

//  cnd , valE , icode , ifun , valA , valB , valC

wire signed [63:0] valE ;
wire reg cnd                ; 


reg [3:0]icode ;
reg [3:0]ifun  ;
reg signed [63:0]valA ;
reg signed [63:0]valB ;
reg signed [63:0]valc ;

// ALU related , internals 
wire signed [63:0] ALUa ;
wire signed [63:0] ALUb ;
wire [1:0] select_op ;
wire [2:0] cc ;         // 0 = OF  1 = SF  2 = ZF 
wire setCC ;

execute call( icode,ifun,valA,valB,valc,valE,cnd,cc ) ;

initial begin 

    icode = 4'h6 ;
    ifun = 4'h0 ; 
    valA = 64'd92 ; 
    valB = 64'd4  ; // valB less or == valA 
    

    #5 

    $display ( "cnd = %h  , valE = %h , icode = %h , ifun = %h , valA = %h , valB = %h , valC = %h" , cnd , valE , icode , ifun , valA , valB , valc )     ; 


    // cmovle
    icode = 4'h2 ;
    ifun = 4'h1 ;  
    valA = 64'h456 ;
    valB = 64'h0 ; 

    #5 
    $display ( "cnd = %h  , valE = %h , icode = %h , ifun = %h , valA = %h , valB = %h , valC = %h" , cnd , valE , icode , ifun , valA , valB , valc )     ; 


    // cmovg 
    icode = 4'h2 ; 
    ifun = 4'h6 ; 
    valA = 64'h666 ;
    valB = 64'h0 ; 
    #5
    $display ( "cnd = %h  , valE = %h , icode = %h , ifun = %h , valA = %h , valB = %h , valC = %h" , cnd , valE , icode , ifun , valA , valB , valc )     ; 




end

endmodule 