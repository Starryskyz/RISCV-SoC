`include "Parameters.v"

module BranchDecision (
    input wire [2:0] BranchType,
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    output reg BranchJump
);
  always @(*)
    case (BranchType)
      `NOBRANCH: BranchJump = 1'b0;  //NOBRANCH
      `BEQ: BranchJump = Operand1 == Operand2 ? 1'b1 : 1'b0;
      `BNE: BranchJump = Operand1 != Operand2 ? 1'b1 : 1'b0;
      `BLT: BranchJump = $signed(Operand1) < $signed(Operand2) ? 1'b1 : 1'b0;
      `BGE: BranchJump = $signed(Operand1) >= $signed(Operand2) ? 1'b1 : 1'b0;
      `BLTU: BranchJump = Operand1 < Operand2 ? 1'b1 : 1'b0;
      `BGEU: BranchJump = Operand1 >= Operand2 ? 1'b1 : 1'b0;
      default: BranchJump = 1'b0;
    endcase
endmodule
