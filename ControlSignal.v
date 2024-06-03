`include "Parameters.v"  
//ָ������
module ControlSignal(
    input wire [6:0] Opcode,//ָ��Ĳ����벿��
    input wire [2:0] Funct3,//ָ���funct3����
    input wire [6:0] Funct7,//ָ���funct7����
    output reg JalD,//Ϊ1��ʾ��ǰ����Ϊjalָ��
    output reg JalrD,//Ϊ1��ʾ��ǰ����Ϊjalrָ��
    output reg [2:0] RegWriteD,
    output reg MemToRegD,//��ʾָ����Ҫ��data memory��ȡ��ֵд��Ĵ���
    output reg [3:0] MemWriteD,//����data memory��32bit�ְ�byte����д��
    output reg LoadNpcD,//��ʾҪ��NextPC�����ResultM
    output reg [1:0] RegReadD,//����forward�Ĵ���
    output reg [2:0] BranchTypeD,//��֧����
    output reg [3:0] AluTypeD,//ALU��������
    output reg AluSrc1D,//Alu����ѡ��1
    output reg [1:0] AluSrc2D,//Alu����ѡ��2
    output reg [2:0] ImmType//ָ�����������ʽ
    );

 
    // LoadNpcD==1      


	always@(*) begin
		JalD         =  Opcode == `OP_JAL; //Jalָ���ID����׶�
		JalrD        =  Opcode == `OP_JALR; //Jalrָ���ID����׶�
		
		RegWriteD    =  Opcode == `OP_Load ? Funct3 + 3'b001 : (Opcode == `OP_Store || Opcode == `OP_Branch ? `NOREGWRITE : `LW);
		 //Load��ָ�Funct3ѡ��, Store��Branch��ָ��ΪNOREGWRITE������ΪLW
		MemToRegD    =  Opcode == `OP_Load; //Load��ָ���ID����׶�
		MemWriteD    =  Opcode == `OP_Store ? 4'b1111 >> (3'b100 - (3'b001 << Funct3)) : 4'b0000; 
		LoadNpcD     =  Opcode == `OP_JAL || Opcode == `OP_JALR; //ֻ��JAL��JALRָ��ʱ���1
		RegReadD[1]  =  Opcode != `OP_LUI && Opcode != `OP_AUIPC && Opcode != `OP_JAL; //����LUI/AUIPC/JAL��3��ָ��������õ��˼Ĵ���A1
		RegReadD[0]  =  Opcode == `OP_Store || Opcode == `OP_RegReg || Opcode == `OP_Branch; //Store��/RegReg��/Branch��ָ���õ��˼Ĵ���A2
		BranchTypeD  =  Opcode == `OP_Branch ? Funct3 - 3'b010 : `NOBRANCH; //Branch��ָ�Funct3ϸ��
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
		   //`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000); 
			`OP_RegReg: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0000001 ? 4'b1011 : (Funct7 == 7'b0100000 ? 4'b1000 : 4'b0000));//�����SUB��SRAָ���ж�
			`OP_RegImm: AluTypeD = {1'b0 ,Funct3} + (Funct7 == 7'b0100000 && Funct3 == 3'b101 ? 4'b1000 : 4'b0000);//�����SRAIָ���ж�
			`OP_LUI:    AluTypeD = `LUI;
			default:    AluTypeD = `ADD;
		endcase
	end
endmodule