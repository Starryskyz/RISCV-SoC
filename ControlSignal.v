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
    output reg [2:0] ImmType//Imm type
);



	always@(*) begin
		JalD         =  Opcode == `OP_JAL; //Jal in ID stage
		JalrD        =  Opcode == `OP_JALR; //Jalr in ID stage
		
		RegWriteD    =  Opcode == `OP_Load ? Funct3 + 3'b001 : (Opcode == `OP_Store || Opcode == `OP_Branch ? `NOREGWRITE : `LW);
		//load according to funct3, store and branch no write back, else LW
		MemToRegD    =  Opcode == `OP_Load; //Load instruction in ID stage
		MemWriteD    =  Opcode == `OP_Store ? 4'b1111 >> (3'b100 - (3'b001 << Funct3)) : 4'b0000; 
		LoadNpcD     =  Opcode == `OP_JAL || Opcode == `OP_JALR; //PC update to new PC
		RegReadD[1]  =  Opcode != `OP_LUI && Opcode != `OP_AUIPC && Opcode != `OP_JAL; //A1 is not used in LUI, AUIPC, JAL but used in all others
		RegReadD[0]  =  Opcode == `OP_Store || Opcode == `OP_RegReg || Opcode == `OP_Branch; //A2 is only used in store, reg-reg, branch
		BranchTypeD  =  Opcode == `OP_Branch ? Funct3 - 3'b010 : `NOBRANCH; //Branch type according to funct3
		AluSrc1D     =  Opcode == `OP_AUIPC; 
		AluSrc2D[1]  =  Opcode != `OP_RegReg && Opcode != `OP_Branch && ~(Opcode == `OP_RegImm && (Funct3 == 3'b001 || Funct3 == 3'b101)); 
		AluSrc2D[0]  =  Opcode == `OP_RegImm && (Funct3 == 3'b001 || Funct3 == 3'b101);
		case(Opcode)
			`OP_Load:   ImmType = `ITYPE;
			`OP_Store:  ImmType = `STYPE;
			`OP_RegImm: ImmType = `ITYPE;
			`OP_LUI:    ImmType = `UTYPE;
			`OP_AUIPC:  ImmType = `UTYPE;
			`OP_Branch: ImmType = `BTYPE;
			`OP_JAL:    ImmType = `JTYPE;
			`OP_JALR:   ImmType = `ITYPE;
			default:    ImmType = 3'b000;
		endcase
		case(Opcode) 
			`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0000001 ? 4'b1011 : (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000));
			`OP_RegImm: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 && Funct3 == 3'b101 ? 4'b1000 : 4'b0000);
			`OP_LUI:    AluTypeD = `LUI;
			default:    AluTypeD = `ADD;
		endcase
	end
endmodule