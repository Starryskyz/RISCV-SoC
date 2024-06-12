//Generate new PC
module PCGenerator (
    input clk,
    input clear,
    input en,

    input [31:0] PC_IF,  //old PC
    input [31:0] JalTarget,
    input [31:0] JalrTarget,
    input [31:0] BranchTarget,
    input JalD,
    input BranchE,
    input JalrE,
    output reg [31:0] PC_Out
);

  always @(posedge clk) begin
    if (clear) PC_Out <= 32'd0;
    else if (en) begin
      if (BranchE) PC_Out <= BranchTarget;
      else if (JalrE) PC_Out <= JalrTarget;
      else if (JalD)  //EX eailier than ID
        PC_Out <= JalTarget;
      else PC_Out <= PC_IF + 32'd4;
    end else PC_Out <= PC_Out;
  end


endmodule
