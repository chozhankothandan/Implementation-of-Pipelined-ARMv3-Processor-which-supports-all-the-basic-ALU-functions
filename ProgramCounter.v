

module ProgramCounter(
    input CLK,
    input RESET,
    input WE_PC,    // write enable
    input [31:0] PC_IN,
    output reg [31:0] PC = 0  
    );
    always@(posedge CLK)
    begin
        if(RESET)
            PC <= 0 ;
        else if(WE_PC)
            PC <= PC_IN;  
    end
endmodule