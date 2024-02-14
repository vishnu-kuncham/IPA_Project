module pipeline_control(W_stat,m_stat,M_icode,M_bubble,e_Cnd,setcc,
        E_dstM,E_icode,E_bubble,d_srcA,d_srcB,D_icode,D_bubble,D_stall,F_stall);
        
        input [3:0] M_icode,E_dstM,E_icode,d_srcA,d_srcB,D_icode;
        input e_Cnd;
        input [0:3] W_stat,m_stat;

        output reg W_stall,M_bubble,setcc,E_bubble,D_bubble,D_stall,F_stall;
        always@(*)
        begin

                F_stall = 0;
                D_stall = 0;
                D_bubble = 0;
                E_bubble = 0;
                M_bubble = 0;
                setcc = 1;
                //source from textbook
                if( ((E_icode == 4'h5 | E_icode == 4'hB) & ((E_dstM == d_srcA | E_dstM == d_srcB) & !(E_dstM == 4'hF))) | (D_icode == 4'h9 | E_icode == 4'h9 | M_icode == 4'h9))
                begin
                        $display("F_stalled");
                        F_stall <=1;
                end
                if((E_icode == 4'h5 | E_icode == 4'hB) & ((E_dstM == d_srcA | E_dstM == d_srcB) & !(E_dstM == 4'hF)))
                begin
                        $display("D_stall");
                        D_stall <=1;
                end
                if((E_icode == 4'h7 & !e_Cnd ) | (!((E_icode == 4'h5 | E_icode == 4'hB)  & ((E_dstM == d_srcA | E_dstM == d_srcB) & !(E_dstM == 4'hF))) & (D_icode == 4'h9 | E_icode == 4'h9 | M_icode == 4'h9)))
                begin
                        $display("D_bubble");
                        D_bubble <= 1;
                end
                if((E_icode == 4'h7 & !e_Cnd ) | ((E_icode == 4'h5 | E_icode == 4'hB)  & ((E_dstM == d_srcA | E_dstM == d_srcB) & !(E_dstM == 4'hF))))
                begin 
                        $display("E_bubble");
                        E_bubble <=1;
                end
                if(E_icode == 4'h0 | m_stat!=4'b1000 | W_stat!=4'b1000)
                begin
                        setcc <= 0;
                end
        end
endmodule