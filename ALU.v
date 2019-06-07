
module ALU(
    input [31:0] Src_AE,
    input [31:0] Src_BE,
    input [2:0] ALUControlE,
    input CE,
    output [31:0] ALUResultE,
    output [3:0] ALUFlags
    );
    
    wire [32:0] S_wider ;
    wire [32:0] S_wider_BIC ;
    reg [32:0] Src_A_comp ;
    reg [32:0] Src_B_comp ;
    reg [31:0] ALUResult_i ;
    reg Comp;
    wire N, Z ;
    reg V ;
   reg [32:0] C_0;
    assign S_wider = Src_A_comp + Src_B_comp + C_0 + CE;
    assign S_wider_BIC[31:0] = Src_A_comp & Src_B_comp;
    
    always@(Src_AE, Src_BE, ALUControlE, S_wider) begin
        // default values; help avoid latches
        C_0 <= 0 ; 
        Src_A_comp <= {1'b0, Src_AE} ;
        Src_B_comp <= {1'b0, Src_BE} ;
        ALUResult_i <= Src_BE ;
        V <= 0 ;
    
        case(ALUControlE)
            3'b000:  
            begin
                ALUResult_i <= S_wider[31:0]  ;
                V <= ( Src_AE[31] ~^ Src_BE[31] )  & ( Src_BE[31] ^ S_wider[31] );          
            end
            
            3'b001:  
            begin
                C_0[0] <= 1 ;  
                Src_B_comp <= {1'b0, ~ Src_BE} ;
                ALUResult_i <= S_wider_BIC[31:0] ;
                V <= ( Src_AE[31] ^ Src_BE[31] )  & ( Src_BE[31] ~^ S_wider[31] );       
            end
            
            3'b010: ALUResult_i <= Src_AE & Src_BE ;
            3'b011: 
                    ALUResult_i <= Src_AE | Src_BE ;
            3'b100:
                    ALUResult_i <= Src_AE ^ Src_BE;
            3'b111:
                    ALUResult_i <= ~( Src_BE );
            3'b101:begin
                    Comp = ~(CE);
                    ALUResult_i <= Src_BE - Src_AE  + Comp ;
                    end
            3'b110:
                    ALUResult_i <= 0;
            default:
                    ALUResult_i <= 0;       
                                   
        endcase ;
    end
    
    assign N = ALUResult_i[31] ;
    assign Z = (ALUResult_i == 0) ? 1 : 0 ;
    //ssign C = S_wider[32] ;
    
    assign ALUResultE = ALUResult_i ;
    assign ALUFlags = {N, Z, CE, V} ;
        
endmodule


