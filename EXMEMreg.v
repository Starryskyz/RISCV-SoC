module EXMEMreg (
    input clk,
    input en,
    input clear,
    input [31:0] PC_EX,
    input [31:0] AluOutE,
    input [31:0] ForwardData2,
    input [31:0] VecRegOut1E,
    input [31:0] VecRegOut2E,
    input [4:0] RdE,
    input [2:0] RegWriteE,
    input MemToRegE,
    input [3:0] MemWriteE,
    input LoadNpcE,
    input VecSrcSelE,
    input VecRegWriteE,
    input MemWriteVecE,

    output reg [31:0] PC_MEM,
    output reg [31:0] AluOutM,
    output reg [31:0] StoreDataM,
    output reg [4:0] RdM,
    output reg [2:0] RegWriteM,
    output reg MemToRegM,
    output reg [3:0] MemWriteM,
    output reg [63:0] VecRegWriteData,
    output reg LoadNpcM,
    output reg VecSrcSelM,
    output reg VecRegWriteM,
    output reg MemWriteVecM
);

    always @(posedge clk) begin
        if (en) begin
            AluOutM <= clear ? 32'b0 : AluOutE;
            StoreDataM <= clear ? 32'b0 : ForwardData2;
            RdM <= clear ? 5'h0 : RdE;
            PC_MEM <= clear ? 32'b0 : PC_EX;
            RegWriteM <= clear ? 3'b0 : RegWriteE;
            MemToRegM <= clear ? 1'b0 : MemToRegE;
            MemWriteM <= clear ? 4'b0 : MemWriteE;
            LoadNpcM <= clear ? 1'b0 : LoadNpcE;
            VecRegWriteData <= clear ? 64'b0 : {VecRegOut2E, VecRegOut1E};
            VecSrcSelM <= clear ? 64'b0 : VecSrcSelE;
            VecRegWriteM <= clear ? 64'b0 : VecRegWriteE;
            MemWriteVecM <= clear ? 1'b0 : MemWriteVecE;
        end 
        else begin
            AluOutM <= AluOutM;
            StoreDataM <= StoreDataM;
            RdM <= RdM;
            PC_MEM <= PC_MEM;
            RegWriteM <= RegWriteM;
            MemToRegM <= MemToRegM;
            MemWriteM <= MemWriteM;
            LoadNpcM <= LoadNpcM;
            VecRegWriteData <= VecRegWriteData;
            VecSrcSelM <= VecSrcSelM;
            VecRegWriteM <= VecRegWriteM;
            MemWriteVecM <= MemWriteVecM;
        end
    end

endmodule