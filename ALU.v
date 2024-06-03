`include "Parameters.v"   

//ALU��������������������AluType�Ĳ�ͬ�����в�ͬ�ļ��߼����������AluOutΪ����ļ�����
module ALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [3:0] AluType,
    output reg [31:0] AluOut
);
    
    wire [63:0] Product;
    assign Product = Operand1 * Operand2;
    /*
    booth_multiplier u_booth_multiplier(
    .a(Operand1),
    .b(Operand2),
    .product(Product)
    );    
    */
    
	always@(*)
		case (AluType)
			`ADD: AluOut = Operand1 + Operand2;
			`SUB: AluOut = Operand1 - Operand2;
			`AND: AluOut = Operand1 & Operand2;
			`OR : AluOut = Operand1 | Operand2;
			`XOR: AluOut = Operand1 ^ Operand2;
			`SLT: begin
					if(Operand1[31] == Operand2[31]) 
					AluOut = (Operand1 < Operand2) ? 32'b1 : 32'b0;
					else 
					AluOut = (Operand1[31] < Operand2[31]) ? 32'b0 : 32'b1;//��������ֱ�ӱȽϷ���
                  end
			`SLTU: AluOut = (Operand1 < Operand2) ? 32'b1 : 32'b0;
			`SLL: AluOut = Operand1 << Operand2[4:0];
			`SRL: AluOut = Operand1 >> Operand2[4:0];
			`SRA: AluOut = $signed(Operand1) >>> Operand2[4:0];
			//ʹ��>>>Ϊ�������ƣ���λ�����ţ��޷�����Ҳ�����߼�����
			`LUI: AluOut = Operand2;
			`MUL: AluOut = Product[31:0];
			`MULH: AluOut = Product[63:32];
			`MULHSU: AluOut = Product[63:32];
			`MULHU: AluOut = Product[63:32];
			default: AluOut = 32'h0;
		endcase
endmodule


