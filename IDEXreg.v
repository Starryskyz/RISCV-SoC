module IDEXreg (
    input clk,
    input en,
    input clear,
    input [31:0] PC_ID,
    input [31:0] JalNPC,
    input [31:0] ImmD,
    input [4:0] RdD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [31:0] RegOut1D,
    input [31:0] RegOut2D,
    input [31:0] VecRegOut1D,
    input [31:0] VecRegOut2D,
    input JalrD,
    input [2:0] RegWriteD,
    input MemToRegD,
    input [3:0] MemWriteD,
    input LoadNpcD,
    input [1:0] RegReadD,
    input [2:0] BranchTypeD,
    input [3:0] AluTypeD,
    input AluSrc1D,
    input [1:0] AluSrc2D,
    input VecSrcSelD,
    input VecRegWriteD,
    input MemWriteVecD,

    output reg [31:0] PC_EX,
    output reg [31:0] BrNPC,
    output reg [31:0] ImmE,
    output reg [4:0] RdE,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [31:0] RegOut1E,
    output reg [31:0] RegOut2E,
    output reg [31:0] VecRegOut1E,
    output reg [31:0] VecRegOut2E,
    output reg JalrE,
    output reg [2:0] RegWriteE,
    output reg MemToRegE,
    output reg [3:0] MemWriteE,
    output reg LoadNpcE,
    output reg [1:0] RegReadE,
    output reg [2:0] BranchTypeE,
    output reg [3:0] AluTypeE,
    output reg AluSrc1E,
    output reg [1:0] AluSrc2E,
    output reg VecSrcSelE,
    output reg VecRegWriteE,
    output reg MemWriteVecE
);


    always @(posedge clk) begin
        if (en)
            if (clear) begin
                PC_EX <= 32'b0;
                BrNPC <= 32'b0;
                ImmE <= 32'b0;
                RdE <= 32'b0;
                Rs1E <= 5'b0;
                Rs2E <= 5'b0;
                RegOut1E <= 32'b0;
                RegOut2E <= 32'b0;
                VecRegOut1E <= 32'b0;
                VecRegOut2E <= 32'b0;
                JalrE <= 1'b0;
                RegWriteE <= 1'b0;
                MemToRegE <= 1'b0;
                MemWriteE <= 1'b0;
                LoadNpcE <= 1'b0;
                RegReadE <= 2'b00;
                BranchTypeE <= 3'b0;
                AluTypeE <= 5'b0;
                AluSrc1E <= 1'b0;
                AluSrc2E <= 2'b0;
                VecSrcSelE <= 1'b0;
                VecRegWriteE <= 1'b0;
                MemWriteVecE <= 1'b0;
            end
            else begin
                PC_EX <= PC_ID;
                BrNPC <= JalNPC;
                ImmE <= ImmD;
                RdE <= RdD;
                Rs1E <= Rs1D;
                Rs2E <= Rs2D;
                RegOut1E <= RegOut1D;
                RegOut2E <= RegOut2D;
                VecRegOut1E <= VecRegOut1D;
                VecRegOut2E <= VecRegOut2D;
                JalrE <= JalrD;
                RegWriteE <= RegWriteD;
                MemToRegE <= MemToRegD;
                MemWriteE <= MemWriteD;
                LoadNpcE <= LoadNpcD;
                RegReadE <= RegReadD;
                BranchTypeE <= BranchTypeD;
                AluTypeE <= AluTypeD;
                AluSrc1E <= AluSrc1D;
                AluSrc2E <= AluSrc2D;
                VecSrcSelE <= VecSrcSelD;
                VecRegWriteE <= VecRegWriteD;
                MemWriteVecE <= MemWriteVecD;
            end
        else begin
            PC_EX <= PC_EX;
            BrNPC <= BrNPC;
            ImmE <= ImmE;
            RdE <= RdE;
            Rs1E <= Rs1E;
            Rs2E <= Rs2E;
            RegOut1E <= RegOut1E;
            RegOut2E <= RegOut2E;
            VecRegOut1E <= VecRegOut1D;
            VecRegOut2E <= VecRegOut2E;
            JalrE <= JalrE;
            RegWriteE <= RegWriteE;
            MemToRegE <= MemToRegE;
            MemWriteE <= MemWriteE;
            LoadNpcE <= LoadNpcE;
            RegReadE <= RegReadE;
            BranchTypeE <= BranchTypeE;
            AluTypeE <= AluTypeE;
            AluSrc1E <= AluSrc1E;
            AluSrc2E <= AluSrc2E;
            VecSrcSelE <= VecSrcSelE;
            VecRegWriteE <= VecRegWriteE;
            MemWriteVecE <= MemWriteVecE;
        end
    end

endmodule