
module HazardSolving (
    input rst,
    input start,
    input BranchE,
    input JalrE,
    input JalD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [4:0] RdE,
    input [4:0] RdM,
    input [4:0] RdW,
    input [1:0] RegReadE,
    input MemToRegE,
    input [2:0] RegWriteM,
    input [2:0] RegWriteW,
    output reg StallF,
    FlushF,
    StallD,
    FlushD,
    StallE,
    FlushE,
    StallM,
    FlushM,
    StallW,
    FlushW,
    output reg [1:0] Forward1E,
    output reg [1:0] Forward2E
);

  always @(*) begin
    FlushF <= rst;  //init 
    FlushD <= rst || (BranchE || JalrE || JalD);
    FlushE <= rst || (MemToRegE && (RdE == Rs1D || RdE == Rs2D)) || (BranchE || JalrE);
    FlushM <= rst;
    FlushW <= rst;
    StallF <= (~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D))) || (~rst && ~start);
    StallD <= (~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D))) || (~rst && ~start);
    StallE <= ~start;  //1'b0;
    StallM <= ~start;  //1'b0;
    StallW <= ~start;  //1'b0;
  end


  always @(*) begin

    Forward1E[0] <= RdW != 0 && |RegWriteW && RegReadE[1] && (RdW == Rs1E) && ~(|RegWriteM && RegReadE[1] && (RdM == Rs1E));
    Forward1E[1] <= RdM != 0 && |RegWriteM && RegReadE[1] && (RdM == Rs1E);

    Forward2E[0] <= RdW != 0 && |RegWriteW && RegReadE[0] && (RdW == Rs2E) && ~(|RegWriteM && RegReadE[0] && (RdM == Rs2E));
    Forward2E[1] <= RdM != 0 && |RegWriteM && RegReadE[0] && (RdM == Rs2E);
  end
endmodule
