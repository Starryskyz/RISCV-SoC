`include "Parameters.v"   

module BranchDecision(
    input [2:0] BranchType,
    input [31:0] Operand1,
    input [31:0] Operand2,
    output reg BranchJump
);

	always@(*) begin
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
	end
	
endmodule