
    
module CondLogic(
    input CLK,
    input PCSE,
    input B,
    input RegWE,
    input MemWE,
    input [1:0] FlagWE,
    input [3:0] CondE,
    input [3:0] ALUFlags,
    output PCSrcE,
    output RegWriteE,
    output MemWriteE,
    output reg CE
    );
    
    reg CondEx ;
    reg N = 0, Z = 0, C1 =0,V = 0 ;
    //<extra signals, if any>
    
    always@(CondE, N, Z, C1, V)
    begin
        case(CondE)
            4'b0000: CondEx <= Z ;                  // EQ  
            4'b0001: CondEx <= ~Z ;                 // NE 
            4'b0010: CondEx <= C1 ;                  // CS / HS 
            4'b0011: CondEx <= ~C1 ;                 // CC / LO  
            
            4'b0100: CondEx <= N ;                  // MI  
            4'b0101: CondEx <= ~N ;// PL
            4'b0110: CondEx <= V ;                  // VS  
            4'b0111: CondEx <= ~V ;                 // VC  
            
            4'b1000: CondEx <= (~Z) & C1 ;           // HI  
            4'b1001: CondEx <= Z | (~C1) ;           // LS  
            4'b1010: CondEx <= N ~^ V ;             // GE  
            4'b1011: CondEx <= N ^ V ;              // LT  
            
            4'b1100: CondEx <= (~Z) & (N ~^ V) ;    // GT  
            4'b1101: CondEx <= Z | (N ^ V) ;        // LE  
            4'b1110: CondEx <= 1'b1  ;              // AL 
            4'b1111: CondEx <= 1'bx ;               // unpredictable   
        endcase
  end
  always@(FlagWE)
  begin 
    if(FlagWE[1:0] == 01)
        begin
            CE = 1;
        end
    else 
            CE = 0;
  end
            assign PCSrcE = PCSE & CondEx;
            assign RegWriteE = RegWE & CondEx;
            assign MemWriteE = MemWE & CondEx;      
endmodule
