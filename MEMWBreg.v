
module MEMWBreg (
    input wire clk,
    input wire en,
    input wire clear,
    input wire [31:0] AluOutM,
    input wire [31:0] RamDataM,
    input wire [63:0] VecDataM,
    output reg [63:0] VecDataW,
    output reg [31:0] RamDataW,
    output reg [1:0] LoadedBytesSelect,

    input  wire [31:0] ResultM,
    output reg  [31:0] ResultW,
    input  wire [ 4:0] RdM,
    output reg  [ 4:0] RdW,

    input wire [2:0] RegWriteM,
    output reg [2:0] RegWriteW,
    input wire MemToRegM,
    output reg MemToRegW,
    input wire VecRegWriteM,
    output reg VecRegWriteW
);

  always @(posedge clk)
    if (en) begin
      LoadedBytesSelect <= clear ? 2'b00 : AluOutM[1:0];
      RegWriteW <= clear ? 3'b0 : RegWriteM;
      MemToRegW <= clear ? 1'b0 : MemToRegM;
      ResultW <= clear ? 0 : ResultM;
      RdW <= clear ? 5'b0 : RdM;
      RamDataW <= clear ? 32'b0 : RamDataM;
      VecDataW <= VecDataM;
      VecRegWriteW <= VecRegWriteM;
    end else begin
      LoadedBytesSelect <= LoadedBytesSelect;
      RegWriteW <= RegWriteW;
      MemToRegW <= MemToRegW;
      ResultW <= ResultW;
      RdW <= RdW;
      RamDataW <= RamDataM;
      VecDataW <= VecDataW;
      VecRegWriteW <= VecRegWriteW;
    end

endmodule
