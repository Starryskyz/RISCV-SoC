`include "Parameters.v"   
//根据分支类型以及决定是否跳转
module BranchDecision(
    input wire [2:0] BranchType,//分支类型
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,//两个操作数
    output reg BranchJump//是否跳转
    );
	always@(*)
		case (BranchType)
			`NOBRANCH: BranchJump = 1'b0;//NOBRANCH
			`BEQ: BranchJump = Operand1 == Operand2 ? 1'b1 : 1'b0; 
			`BNE: BranchJump = Operand1 != Operand2 ? 1'b1 : 1'b0;
			`BLT: BranchJump = $signed(Operand1) < $signed(Operand2) ? 1'b1 : 1'b0;
			`BGE: BranchJump = $signed(Operand1) >= $signed(Operand2) ? 1'b1 : 1'b0;
			`BLTU: BranchJump = Operand1 < Operand2 ? 1'b1 : 1'b0; 
			`BGEU: BranchJump = Operand1 >= Operand2 ? 1'b1 : 1'b0; 
			default: BranchJump = 1'b0;
		endcase
endmodule