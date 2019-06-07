
//output PCS should be coded 
 
module Decoder(
    input [3:0] Rd,
    
    input [1:0] Op,
    input [5:0] Funct,
    input Start,
    input [4:0]count,
    output reg PCSD,
    output reg RegWD,
    output reg MemWD,
    output reg MemtoRegD,
    output reg ALUSrcD,
    output reg [1:0] ImmSrcD,
    output reg [1:0] RegSrcD,
    output reg B,
    output reg [2:0] ALUControlD,
    output reg [1:0] FlagWD,
    output reg [1:0] MCycleOp,
    output reg done = 0
    );
    reg ALUOp ;
    reg [9:0] controls ;
    //<extra signals, if any>
always@(*)
   begin 
     RegWD = Op[0] + ( (~(Funct[5]) ) & ( ~( Funct[0] ) ) );    
     MemWD = ( (Op == 2'b01) & (Funct[5] == 0) ) ? 1'b1 : 1'b0;
     MemtoRegD = ( ( (Op == 01) || (Op == 00) ) & ( ( Funct[4:0] == 5'b11010) || Funct[4:0] == 5'b11001 ) ) ? 1'b1 : 1'b0;
     ALUSrcD = ( (Op == 00) & (Funct[5] == 1'b0) ) ? 1'b0 : 1'b1;
     ALUOp = (Op == 2'b00) ? 1'b1 : 1'b0;
     PCSD = (Op == 10 & Op == 00) ? 1'b1 : 1'b0;
if(Start == 1)
    begin
        if( count <=3 )
            begin
                MCycleOp[1:0] = 2'b00;
                done = 1'b1;
            end
        else if( (count == 4 ) )
            begin
                  MCycleOp[1:0] = 1 + MCycleOp[1:0];
                  done = 1'b1;
            end     
        else
            begin
               done = 1'b0;
             end    
    end     
if((Op == 00) & (Funct[5] == 1))
        begin 
             ImmSrcD = 00;
        end
else if (Op == 01)
        begin 
             ImmSrcD = 01;
        end
else
        begin
             ImmSrcD = 10;
        end
end
 always@(Op,Funct,ALUOp)
    begin   
        if(Op == 2'b00)
            begin
                RegSrcD = 2'b00;
            end    
        else if ( (Op == 2'b01) & ( Funct[0] == 0 ) )
            begin
                RegSrcD = 2'b10;
            end
        else if ( (Op == 2'b01) & ( Funct[0] == 1 ) )
            begin
                RegSrcD = 2'b00;
            end
        else if ( (Op == 00) & Funct[0] == 0)
            begin
                RegSrcD = 2'b01; 
                B = 1'b1;
            end
        else 
                RegSrcD = 2'b00;
   
        case(Funct[4:1])
            4'b0100 : 
                if(Funct[0] == 0)
                    begin
                        ALUControlD = 3'b000;
                        FlagWD = 2'b00;
                    
                    end
                else
                    begin   
                        ALUControlD = 3'b000;
                        FlagWD = 2'b11;
                    end
            4'b0010 :
                if(Funct[0] == 0)
                    begin
                         ALUControlD = 3'b001;
                         FlagWD = 2'b00;
                       
                    end
                else
                    begin   
                         ALUControlD = 3'b001;
                         FlagWD = 2'b11;
                         
                    end
            4'b0000 : 
                if(Funct[0] == 0)
                    begin
                         ALUControlD = 3'b010;
                         FlagWD = 2'b00;
                       
                    end
                 else
                    begin
                         ALUControlD = 3'b010;
                         FlagWD = 2'b10;
                         
                    end                      
            4'b1100 :
                 if(Funct[0] == 0)
                     begin
                         ALUControlD = 3'b011;
                         FlagWD = 2'b00;
                         
                     end
                 else
                     begin
                         ALUControlD = 3'b000;
                         FlagWD = 2'b10;
                         
                     end
            4'b0101 :
                     begin
                         ALUControlD = 3'b000;
                         FlagWD = 2'b01;
                         
                      end
            4'b1110 :
                   begin
                         ALUControlD = 3'b001;
                         FlagWD = 2'b00;                                        
                    end
            4'b0001:
                   begin
                        ALUControlD = 3'b100;
                   end   
            4'b1111:
                    begin 
                            ALUControlD = 3'b111;
                    end
            4'b0011:
                    begin
                        ALUControlD = 3'b101;
                        FlagWD[1:0] = 2'b01;
                    end
            4'b0111:
                    begin
                        ALUControlD = 3'b101;
                        FlagWD[1:0] = 2'b00;
                    end
             4'b0110:
                    begin
                        ALUControlD = 3'b110;
                    end
             4'b1000:
                    begin
                        ALUControlD[2:0] = 3'b110;
                    end
            default:
                    begin
                        ALUControlD[2:0] = 3'b000;
                    end
            endcase
            end

endmodule





