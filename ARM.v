module ARM(
    input CLK,
    input RESET,
    //input Interrupt,  // for optional future use
    input [31:0] Instr,
    input [31:0] ReadData,
    output MemWrite,
    output [31:0] PC,
    output reg [31:0] ALUResultM,
    output [31:0] WriteData
    );
    reg [31:0]InstrD;
    // RegFile signals
    //wire CLK ;
    wire WE3 ;
    wire [3:0] A1D ;
    wire [3:0] A2D ;
    wire [3:0] WA3D ;
    wire [31:0] WD3 ;
    wire [31:0] R15 ;
    wire [31:0] RD1D ;
    wire [31:0] RD2D ;
    wire [3:0] A3D;
    // Extend Module signals
    wire [1:0] ImmSrcD ;
    reg [23:0] InstrImm ;
    wire [31:0] ExtImmD ;
    
    // Decoder signals
    wire [3:0] Rd ;
    wire [1:0] Op ;
    wire [5:0] Funct ;
    //wire PCS ;
    //wire RegW ;
    //wire MemW ;
    wire RegWD ;
    wire MemtoRegD ;
    reg MemtoRegE;
    reg MemtoRegM;
    reg MemtoRegW;
    wire ALUSrcD ;
    reg ALUSrcE;
    wire [1:0] RegSrcD ;
    reg RegWE;
    //wire [1:0] ALUControl ;
    //wire [1:0] FlagW ;
    
    // CondLogic signals
    //wire CLK ;
    wire PCSD ;
    wire RegW; 
    wire MemWD ;
    reg MemWE;
    wire [1:0] FlagWD ;
    reg [1:0] FlagWE;
    wire [3:0] CondD ;
    reg [3:0] CondE;
    //wire [3:0] ALUFlags,
    wire PCSrc ;
    wire PCSrcE;
    reg PCSrcM;
    reg PCSrcW;
    reg RegWriteW;
    wire RegWriteE ;
    reg RegWriteM; 
    wire MemWriteE;
    reg MemWriteM;   
    // Shifter signals
    reg [1:0] Sh ;
    reg [4:0] Shamt5 ;
    wire [31:0] ShIn ;
    wire [31:0] ShOut ;
    
    // ALU signals
    
    reg [31:0]Src_AE;
    wire [31:0] Src_BE ;
    wire [2:0] ALUControlD ;
    reg [2:0] ALUControlE;
    wire [31:0] ALUResultE ;
    wire [3:0] ALUFlags ;
    wire CE;
    wire done;
   
    // ProgramCounter signals
    //wire CLK ;
    //wire RESET ;
    wire WE_PC ;    
    reg [31:0]PCF;
            
     //wire [31:0] PC ; 
    // Other internal signals here
    wire [31:0] PCPlus4 ;
    wire [31:0] PCPlus8 ;
    wire [31:0]PC_IN;
 //   reg [31:0]PCPlus4D;
    //MCyle wire
             wire [1:0]MCycleOp;
             reg Start1;
             wire [3:0]Operand1;
             wire [3:0]Operand2;
             wire busy;
             wire Start ;
             wire [4:0]count;
             wire [7:0]Result1;
     //Pipelining path
        reg [31:0] ShOutE;
        reg [31:0] ExtImmE;
        reg [3:0]WA3E;
        reg [3:0] WA3M;
        reg [3:0]WA3W;
        reg [31:0] ALUResultW;
        reg [31:0] ReadDataW;
        reg PCSE;
        wire [31:0]InstrF;
       //datapath connections here
   initial 
   begin
    Start1 = 0;
   InstrD[31:0] = 0;
   end
    always@(posedge CLK)
    begin
        if (RESET)
        InstrD[31:0] = 0;
        else
        InstrD[31:0] <= InstrF[31:0];
     end
    always@(posedge CLK)
    begin
        Src_AE[31:0] <= RD1D[31:0];
        ShOutE[31:0] <= ShOut[31:0];
        ExtImmE[31:0] <= ExtImmD[31:0];
        WA3E[3:0] <= WA3D[3:0];
        PCSrcW <= PCSD;
        RegWE <= RegWD;
        FlagWE[1:0] <= FlagWD[1:0];
        ALUControlE[2:0] <= ALUControlD[2:0];
        MemtoRegE <= MemtoRegD;
        ALUSrcE <= ALUSrcD;
        MemWE <= MemWD;
       
        CondE[3:0] <= CondD[3:0];
    end
    always@(posedge CLK)
    begin
        ALUResultM[31:0] <= ALUResultE[31:0];
        WA3M[3:0] <= WA3E[3:0];
        
        //PCSrcM <= PCSrcE;
        RegWriteM <= RegWriteE;
        MemWriteM <= MemWriteE;
        MemtoRegM <= MemtoRegE;
    end
    always@(posedge CLK)
        begin
            ALUResultW[31:0] <= ALUResultM[31:0];
            WA3W[3:0] <= WA3M[3:0];
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
        end
        //assign WE_PC = ( ( (InstrD[27:20] == 0) || (InstrD[21:20] == 2'b10) ) & ( InstrD[7:4] == 4'b1001 ) & busy) ? 1'b0 : 1'b1; // Will need to control it for multi-cycle operations (Multiplication, Division) and/or Pipelining with hazard hardware.
       assign InstrF[31:0] = Instr[31:0];
        assign WE_PC = 1;
        assign CondD[3:0] = InstrD[31:28];
        assign Op[1:0] = InstrD[27:26];
        assign Rd[3:0] = InstrD[15:12];       
        assign Funct[5:0] = InstrD[25:20];
        assign A1D[3:0] = RegSrcD[0]? 4'd15 : Start1 ? InstrD[11:8]:InstrD[19:16];
        assign A3D[3:0] = WA3M[3:0];
        assign WA3D[3:0] = InstrD[15:12];
        assign A2D[3:0] = RegSrcD[1] ? Rd[3:0] : InstrD[3:0];
        assign Operand1[3:0] = Start1 ? Src_AE[31:0] : 3'b000;
        assign WD3 = MemtoRegM ? ReadData[31:0]:ALUResultW[31:0];
        assign WriteData[31:0] = Start ? Result1[7:0] : WD3[31:0];
        assign WE3 = 1;
        assign PCPlus4[31:0] = PC[31:0] + 4;
       // assign PCPlus8[31:0] = PCPlus4[31:0] + 4;
        assign PC_IN = PCSrcW ? WD3 : PCPlus4;
        assign R15[31:0] = PCPlus4[31:0];
       // assign R15E = R15D; 
        assign Src_BE[31:0] = ALUSrcE?  ExtImmE[31:0] : Start1 ? RD2D[31:0] :ShOutE[31:0] ; 
		assign Operand2[3:0] = Start1 ? Src_BE[31:0] : 3'b000;
        assign ShIn[31:0] = RD2D[31:0];
        assign Start = Start1;
        always @(InstrD) 
		begin
          if ( ( InstrD[27:20] == 0 || (InstrD[21:20] == 2'b10)) & ( WE_PC == 0 ) )
                begin
                    Start1 = 1'b1;
                   
                end
          else
                begin
                    //if (InstrD[25] == 0) 
                      //  begin
                            InstrImm[23:0] = InstrD[23:0];
		                    Shamt5[4:0] = InstrD[11:7];
			                Sh[1:0] = InstrD[6:5];
			                Start1 = 1'b0;
			           // end
		        end
		end

        // Instantiate RegFile
    RegFile RegFile1( CLK,WE3,A1D,A2D,A3D,WD3,R15,RD1D,RD2D);
                
    // Instantiate Extend Module
    Extend Extend1(ImmSrcD,InstrImm,ExtImmD);
                
    // Instantiate Decoder
    Decoder Decoder1( Rd,Op,Funct,Start,count,PCSD,RegWD,MemWD,MemtoRegD,ALUSrcD,ImmSrcD,RegSrcD,B,ALUControlD,FlagWD,MCycleOp,done);
                                
    // Instantiate CondLogic
    CondLogic CondLogic1(CLK,PCSE,B,RegWE,MemWE,FlagWE,CondE,ALUFlags,PCSrcE,RegWriteE,MemWriteE,CE);
    
    // Instantiate Shifter        
    Shifter Shifter1(Sh,Shamt5,ShIn,ShOut);
                
    // Instantiate ALU        
    ALU ALU1(Src_AE,Src_BE,ALUControlE,CE,ALUResultE,ALUFlags);                
    
    // Instantiate ProgramCounter    
    ProgramCounter ProgramCounter1(CLK,RESET,WE_PC,PC_IN,PC);  
    //Instantiate MCycle 
    MCycle MCycle1(CLK,done,MCycleOp,Operand1,Operand2,Result1,busy,count);
endmodule
