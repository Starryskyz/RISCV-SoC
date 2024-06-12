`include "Parameters.v"  

module ControlSignal(
    input [6:0] Opcode,
    input [2:0] Funct3,
    input [6:0] Funct7,
    output reg JalD,//jal
    output reg JalrD,//jalr
    output reg [2:0] RegWriteD,
    output reg MemToRegD,//read dmem, write to regfile
    output reg [3:0] MemWriteD,//32bit,write by byte
    output reg LoadNpcD,//Result = ResultM
    output reg [1:0] RegReadD,//used in forward
    output reg [2:0] BranchTypeD,//Branch type
    output reg [3:0] AluTypeD,//ALU operation type
    output reg AluSrc1D,//Alu input select 1
    output reg [1:0] AluSrc2D,//Alu input select 2
    output reg [2:0] ImmType,//Imm type
    output reg VecRegWriteD,
    //output reg VecRegRead,
    output reg VecSrcSel,
		output reg MemWriteVecD
    );

 
    // LoadNpcD==1      


	always@(*) begin
		JalD         =  Opcode == `OP_JAL;
		JalrD        =  Opcode == `OP_JALR;
		
		RegWriteD    =  Opcode == `OP_Vec ? (Funct3 == 3'b001 ? `LW : `NOREGWRITE) : (Opcode == `OP_Load ? Funct3 + 3'b001 : (Opcode == `OP_Store || Opcode == `OP_Branch ? `NOREGWRITE : `LW));
		//load according to funct3, store and branch no write back, else LW
    VecRegWriteD =  (Opcode == `OP_Vec && Funct3 == 3'b010) ? 1'b1 : 1'b0;
		MemWriteVecD =  Opcode == `OP_Vec && Funct3 == 3'b100;
		MemToRegD    =  Opcode == `OP_Load;
		MemWriteD    =  Opcode == `OP_Store ? 4'b1111 >> (3'b100 - (3'b001 << Funct3)) : 4'b0000; 
		LoadNpcD     =  Opcode == `OP_JAL || Opcode == `OP_JALR;
		RegReadD[1]  =  Opcode != `OP_LUI && Opcode != `OP_AUIPC && Opcode != `OP_JAL;
		RegReadD[0]  =  Opcode == `OP_Store || Opcode == `OP_RegReg || Opcode == `OP_Branch;
		//VecRegRead   =  (Opcode == `OP_Vec && Funct3 != 010) ? 1'b1 : 1'b0;
    BranchTypeD  =  Opcode == `OP_Branch ? Funct3 - 3'b010 : `NOBRANCH;
		AluSrc1D     =  Opcode == `OP_AUIPC;
		AluSrc2D[1]  =  Opcode != `OP_RegReg && Opcode != `OP_Branch && ~(Opcode == `OP_RegImm && (Funct3 == 3'b001 || Funct3 == 3'b101)); 
		AluSrc2D[0]  =  Opcode == `OP_RegImm && (Funct3 == 3'b001 || Funct3 == 3'b101);
    VecSrcSel    =  Opcode == `OP_Vec && Funct3 == 3'b001;
		case(Opcode)
			`OP_Load:   ImmType = `ITYPE;
			`OP_Store:  ImmType = `STYPE;
			`OP_RegImm: ImmType = `ITYPE;
			`OP_LUI:    ImmType = `UTYPE;
			`OP_AUIPC:  ImmType = `UTYPE;
			`OP_Branch: ImmType = `BTYPE;
			`OP_JAL:    ImmType = `JTYPE;
			`OP_JALR:   ImmType = `ITYPE;
            `OP_Vec:    ImmType = Funct3 == 3'b010 ? `ITYPE : `STYPE;
			default:    ImmType = 3'b000;
		endcase
		case(Opcode) 
		   //`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000); 
			`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0000001 ? 4'b1011 : (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000));//�����SUB��SRAָ���ж�
			`OP_RegImm: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 && Funct3 == 3'b101 ? 4'b1000 : 4'b0000);//�����SRAIָ���ж�
			`OP_LUI:    AluTypeD = `LUI;
      `OP_Vec:    AluTypeD = Funct3 == 3'b001 ? `VM : `ADD;
			default:    AluTypeD = `ADD;
		endcase
	end
endmodule
