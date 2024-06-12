
module IFIDreg (
    input clk,
    input en,
    input clear,
    input [31:0] PC_IF,  //IF_PC
    input [31:0] DataInstF,  //IF_Instruction from imem
    output reg [31:0] DataInstD,
    output reg [31:0] PC_ID
);

  always @(posedge clk) begin
    if (en) begin
      PC_ID <= clear ? 32'b0 : PC_IF;
      DataInstD <= clear ? 32'b0 : DataInstF;
    end else begin
      PC_ID <= PC_ID;
      DataInstD <= DataInstD;
    end
  end

endmodule
