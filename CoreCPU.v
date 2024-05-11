module riscv_kernel#(
    parameter AddressWidth_imem = 32'd30,//32'd6,
    parameter AddressWidth_dmem = 32'd30,//32'd5,
    parameter DataWidth = 32'd32
)
(
    input clk,
    input rst,
    //input ap_start,
    //input ap_done,
    //input ap_idle,
    //input ap_ready,
    output [AddressWidth_imem-1:0] imem_address0,
    output imem_ce0,
    input [DataWidth-1:0] imem_q0,
    output [AddressWidth_dmem-1:0] dmem_address0,
    output dmem_ce0,
    output dmem_we0,
    output [DataWidth-1:0] dmem_d0,
    input [DataWidth-1:0] dmem_q0

    );

    wire StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW;
    wire [31:0] PC_In;
    wire [31:0] PC_IF;
    wire [31:0] Inst; 
    wire [31:0] PC_ID;
    wire JalD, JalrD, LoadNpcD, MemToRegD, AluSrc1D;
    wire [2:0] RegWriteD;
    wire [3:0] MemWriteD;
    wire [1:0] RegReadD;
    wire [2:0] BranchTypeD;
    wire [3:0] AluTypeD;
    wire [1:0] AluSrc2D;
    wire [2:0] RegWriteW;
    wire [4:0] RdW;
    wire [31:0] RegWriteData;
    wire [31:0] RamDataW_Ext;
    wire [2:0] ImmType;
    wire [31:0] ImmD;
    wire [31:0] JalNPC;
    wire [31:0] BrNPC; 
    wire [31:0] ImmE;
    wire [6:0] OpcodeD, Funct7D;
    wire [2:0] Funct3D;
    wire [4:0] Rs1D, Rs2D, RdD;
    wire [4:0] Rs1E, Rs2E, RdE;
    wire [31:0] RegOut1D;
    wire [31:0] RegOut1E;
    wire [31:0] RegOut2D;
    wire [31:0] RegOut2E;
    wire JalrE;
    wire [2:0] RegWriteE;
    wire MemToRegE;
    wire [3:0] MemWriteE;
    wire LoadNpcE;
    wire [1:0] RegReadE;
    wire [2:0] BranchTypeE;
    wire [3:0] AluTypeE;
    wire AluSrc1E;
    wire [1:0] AluSrc2E;
    wire [31:0] Operand1;
    wire [31:0] Operand2;
    wire BranchE;
    wire [31:0] AluOutE;
    wire [31:0] AluOutM; 
    wire [31:0] ForwardData1;
    wire [31:0] ForwardData2;
    wire [31:0] PC_EX;
    wire [31:0] StoreDataM; 
    wire [4:0] RdM;
    wire [31:0] PC_MEM;
    wire [2:0] RegWriteM;
    wire MemToRegM;
    wire [3:0] MemWriteM;
    wire LoadNpcM;
    wire [31:0] RamDataW;
    wire [31:0] ResultM;
    wire [31:0] ResultW;
    wire MemToRegW;
    wire [1:0] Forward1E;
    wire [1:0] Forward2E;
    wire [1:0] LoadedBytesSelect;
    wire [7:0] chicken_bcd;
    wire [7:0] rabbit_bcd;






//-------------------IF��-----------------------//
    PC_Generator PC_Generator(
        .clk(clk),
        .rst(FlushF),
        .en(~StallF),
        //.PC_IF(PC_IF),
        .PC_IF(PC_In),
        .JalrTarget(AluOutE),  
        .JalTarget(JalNPC),
        .BranchTarget(BrNPC),
        .BranchE(BranchE),
        .JalD(JalD),
        .JalrE(JalrE),
        .PC_Out(PC_In)
    );
    /*
    IF_reg IF_reg(
        .clk(clk),
        .en(~StallF),
        .clear(FlushF), 
        .PC_In(PC_In),
        .PC_IF(PC_IF)
    );
    */
    wire [31:0] DataInstF;
    /*
    InstructionROM InstructionROM(
         .clk(clk),    
         .addr(PC_IF),      
         .dout(DataInstF)
     );*/
    //assign imem_address0 = PC_IF[7:2];
    assign imem_address0 = PC_In[(AddressWidth_imem+1):2];
    assign imem_ce0 = 1'b1;
    assign DataInstF = imem_q0;
    
//-------------------ID��-----------------------//        
    ID_reg ID_reg(
        .clk(clk),
        .en(~StallD),
        .clear(FlushD),
        .DataInstF(DataInstF),
        .DataInstD(Inst),
        //.PC_IF(PC_IF),
        .PC_IF(PC_In),
        .PC_ID(PC_ID) 
    );
    
    assign {Funct7D, Rs2D, Rs1D, Funct3D, RdD, OpcodeD} = Inst;
    assign JalNPC=ImmD+PC_ID;
            
    ControlSignal ControlSignal(
        .Opcode(OpcodeD),
        .Funct3(Funct3D),
        .Funct7(Funct7D),
        .JalD(JalD),
        .JalrD(JalrD),
        .RegWriteD(RegWriteD),
        .MemToRegD(MemToRegD),
        .MemWriteD(MemWriteD),
        .LoadNpcD(LoadNpcD),
        .RegReadD(RegReadD),
        .BranchTypeD(BranchTypeD),
        .AluTypeD(AluTypeD),
        .AluSrc1D(AluSrc1D),
        .AluSrc2D(AluSrc2D),
        .ImmType(ImmType)
    );
    ImmOperand ImmOperand(
        .Instpart(Inst[31:7]),
        .ImmType(ImmType),
        .Out(ImmD)
    );
    RegisterFile RegisterFile(
        .clk(clk),
        .rst(rst),
        .Address1(Rs1D),
        .Address2(Rs2D),
        .Address3(RdW),
        .RegWriteEN3(|RegWriteW),
        .RegDataW3(RegWriteData),
        .RegDataR1(RegOut1D),
        .RegDataR2(RegOut2D)
    );
    
//-------------------EX��-----------------------//      
    
    EX_reg EX_reg(
        .clk(clk),
        .en(~StallE),
        .clear(FlushE),
        .PC_ID(PC_ID),
        .PC_EX(PC_EX), 
        .JalNPC(JalNPC),
        .BrNPC(BrNPC), 
        .ImmD(ImmD),
        .ImmE(ImmE),
        .RdD(RdD),
        .RdE(RdE),
        .Rs1D(Rs1D),
        .Rs1E(Rs1E),
        .Rs2D(Rs2D),
        .Rs2E(Rs2E),
        .RegOut1D(RegOut1D),
        .RegOut1E(RegOut1E),
        .RegOut2D(RegOut2D),
        .RegOut2E(RegOut2E),
        .JalrD(JalrD),
        .JalrE(JalrE),
        .RegWriteD(RegWriteD),
        .RegWriteE(RegWriteE),
        .MemToRegD(MemToRegD),
        .MemToRegE(MemToRegE),
        .MemWriteD(MemWriteD),
        .MemWriteE(MemWriteE),
        .LoadNpcD(LoadNpcD),
        .LoadNpcE(LoadNpcE),
        .RegReadD(RegReadD),
        .RegReadE(RegReadE),
        .BranchTypeD(BranchTypeD),
        .BranchTypeE(BranchTypeE),
        .AluTypeD(AluTypeD),
        .AluTypeE(AluTypeE),
        .AluSrc1D(AluSrc1D),
        .AluSrc1E(AluSrc1E),
        .AluSrc2D(AluSrc2D),
        .AluSrc2E(AluSrc2E)
    	); 

    assign ForwardData1 = Forward1E[1] ? (AluOutM) : ( Forward1E[0] ? RegWriteData : RegOut1E );
    assign Operand1 = AluSrc1E ? PC_EX : ForwardData1;
    assign ForwardData2 = Forward2E[1] ? (AluOutM) : ( Forward2E[0] ? RegWriteData : RegOut2E );
    assign Operand2 = AluSrc2E[1] ? (ImmE) : ( AluSrc2E[0] ? Rs2E : ForwardData2 );

    ALU ALU(
        .Operand1(Operand1),
        .Operand2(Operand2),
        .AluType(AluTypeE),
        .AluOut(AluOutE)
    	);
    BranchDecision BranchDecision(
        .BranchType(BranchTypeE),
        .Operand1(Operand1),
        .Operand2(Operand2),
        .BranchJump(BranchE)
        );
        
//-------------------MEM��-----------------------//          
    MEM_reg MEM_reg(
        .clk(clk),
        .en(~StallM),
        .clear(FlushM),
        .AluOutE(AluOutE),
        .AluOutM(AluOutM), 
        .ForwardData2(ForwardData2),
        .StoreDataM(StoreDataM), 
        .RdE(RdE),
        .RdM(RdM),
        .PC_EX(PC_EX),
        .PC_MEM(PC_MEM),
        .RegWriteE(RegWriteE),
        .RegWriteM(RegWriteM),
        .MemToRegE(MemToRegE),
        .MemToRegM(MemToRegM),
        .MemWriteE(MemWriteE),
        .MemWriteM(MemWriteM),
        .LoadNpcE(LoadNpcE),
        .LoadNpcM(LoadNpcM)
    );
    assign ResultM = LoadNpcM ? (PC_MEM+4) : AluOutM;
    wire [31:0] RamData_raw;
    wire [31:0] din;
    wire [3:0] WriteEN;
    assign din = StoreDataM << ({3'b000, AluOutM[1:0]} << 3'd3);
    assign WriteEN = MemWriteM << AluOutM[1:0];
    /*
    DataRAM DataRAM(
        .clk(clk),                      
        .rst(rst),
        .WriteEN(WriteEN),                      
        .addr(AluOutM),                      
        .din(din),                      
        .dout(RamData_raw),

    );*/ 
    wire [31:0] d0;
    assign d0[31:24] = WriteEN[3] ? din[31:24] : 8'b0;
    assign d0[23:16] = WriteEN[2] ? din[23:16] : 8'b0;
    assign d0[15:8] = WriteEN[1] ? din[15:8] : 8'b0;
    assign d0[7:0] = WriteEN[0] ? din[7:0] : 8'b0;
    assign dmem_address0 = AluOutM[(AddressWidth_dmem+1):2];
    assign dmem_ce0 = 1'b1;
    assign dmem_we0 = |WriteEN;
    assign dmem_d0 = d0;
    assign RamData_raw = dmem_q0;
    
//-------------------WB��-----------------------//      
     
    WB_reg WB_reg(
        .clk(clk),
        .en(~StallW),
        .clear(FlushW),
        .AluOutM(AluOutM),
        .RamDataM(RamData_raw),
        .RamDataW(RamDataW),
        .LoadedBytesSelect(LoadedBytesSelect),
        .ResultM(ResultM),
        .ResultW(ResultW), 
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .MemToRegM(MemToRegM),
        .MemToRegW(MemToRegW)
    );
    
    DataProcess DataProcess(
        .din(RamDataW),
        .LoadedBytesSelect(LoadedBytesSelect),
        .RegWriteW(RegWriteW),
        .dout(RamDataW_Ext)
    );
    assign RegWriteData = ~MemToRegW?ResultW:RamDataW_Ext;
    
    
//-------------------ð�մ���-----------------------//    
    HazardSolving HazardSolving(
        .rst(rst),
        .BranchE(BranchE),
        .JalrE(JalrE),
        .JalD(JalD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RegReadE(RegReadE),
        .MemToRegE(MemToRegE),
        .RdE(RdE),
        .RdM(RdM),
        .RegWriteM(RegWriteM),
        .RdW(RdW),
        .RegWriteW(RegWriteW),
        .StallF(StallF),
        .FlushF(FlushF),
        .StallD(StallD),
        .FlushD(FlushD),
        .StallE(StallE),
        .FlushE(FlushE),
        .StallM(StallM),
        .FlushM(FlushM),
        .StallW(StallW),
        .FlushW(FlushW),
        .Forward1E(Forward1E),
        .Forward2E(Forward2E)
    	);    
endmodule