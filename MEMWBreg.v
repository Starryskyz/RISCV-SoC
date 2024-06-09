
module MEMWBreg(
    input clk,
    input en,
    input clear,
    input [31:0] AluOutM,
    input [31:0] RamDataM,
    input [31:0] ResultM,
    input [4:0] RdM,
    input [2:0] RegWriteM,
    input MemToRegM,    
    output reg [31:0] RamDataW,
    output reg [1:0] LoadedBytesSelect,
    output reg [31:0] ResultW, 
    output reg [4:0] RdW, 
    output reg [2:0] RegWriteW,
    output reg MemToRegW
);

    always@(posedge clk) begin
        if(en)  begin
            LoadedBytesSelect <= clear ? 2'b00 : AluOutM[1:0];
            RegWriteW <= clear ? 3'b0 : RegWriteM;
            MemToRegW <= clear ? 1'b0 : MemToRegM;
            ResultW <= clear ? 0 : ResultM;
            RdW <= clear ? 5'b0 : RdM;
            RamDataW <= clear ? 32'b0 : RamDataM;
        end
        else begin
            LoadedBytesSelect <= LoadedBytesSelect;
            RegWriteW <= RegWriteW;
            MemToRegW <= MemToRegW;
            ResultW <= ResultW;
            RdW <= RdW;
            RamDataW <= RamDataM;
        end
    end

endmodule

