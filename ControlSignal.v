`include "Parameters.v"  
//指令译码
module ControlSignal(
    input wire [6:0] Opcode,//指令的操作码部分
    input wire [2:0] Funct3,//指令的funct3部分
    input wire [6:0] Funct7,//指令的funct7部分
    output reg JalD,//为1表示当前译码为jal指令
    output reg JalrD,//为1表示当前译码为jalr指令
    output reg [2:0] RegWriteD,
    output reg MemToRegD,//表示指令需要将data memory读取的值写入寄存器
    output reg [3:0] MemWriteD,//对于data memory的32bit字按byte进行写入
    output reg LoadNpcD,//表示要将NextPC输出到ResultM
    output reg [1:0] RegReadD,//用于forward的处理
    output reg [2:0] BranchTypeD,//分支类型
    output reg [3:0] AluTypeD,//ALU运算类型
    output reg AluSrc1D,//Alu输入选择1
    output reg [1:0] AluSrc2D,//Alu输入选择2
    output reg [2:0] ImmType//指令的立即数格式
    );

 
    // LoadNpcD==1      


	always@(*) begin
		JalD         =  Opcode == `OP_JAL; //Jal指令到达ID译码阶段
		JalrD        =  Opcode == `OP_JALR; //Jalr指令到达ID译码阶段
		
		RegWriteD    =  Opcode == `OP_Load ? Funct3 + 3'b001 : (Opcode == `OP_Store || Opcode == `OP_Branch ? `NOREGWRITE : `LW);
		 //Load类指令按Funct3选择, Store和Branch类指令为NOREGWRITE，其余为LW
		MemToRegD    =  Opcode == `OP_Load; //Load类指令到达ID译码阶段
		MemWriteD    =  Opcode == `OP_Store ? 4'b1111 >> (3'b100 - (3'b001 << Funct3)) : 4'b0000; 
		LoadNpcD     =  Opcode == `OP_JAL || Opcode == `OP_JALR; //只有JAL或JALR指令时输出1
		RegReadD[1]  =  Opcode != `OP_LUI && Opcode != `OP_AUIPC && Opcode != `OP_JAL; //除了LUI/AUIPC/JAL这3条指令，其他都用到了寄存器A1
		RegReadD[0]  =  Opcode == `OP_Store || Opcode == `OP_RegReg || Opcode == `OP_Branch; //Store类/RegReg类/Branch类指令用到了寄存器A2
		BranchTypeD  =  Opcode == `OP_Branch ? Funct3 - 3'b010 : `NOBRANCH; //Branch类指令按Funct3细分
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
			`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000);//后面对SUB和SRA指令判断
			`OP_RegImm: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 && Funct3 == 3'b101 ? 4'b1000 : 4'b0000);//后面对SRAI指令判断
			`OP_LUI:    AluTypeD = `LUI;
			default:    AluTypeD = `ADD;
		endcase
	end
endmodule