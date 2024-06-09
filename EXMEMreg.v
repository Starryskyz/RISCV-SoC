module EXMEMreg(
    input clk,
    input en,
    input clear,
    input [31:0] PC_EX,
    input [31:0] AluOutE,     
    input [31:0] ForwardData2,     
    input [4:0] RdE,    
    input [2:0] RegWriteE,    
    input MemToRegE,    
    input [3:0] MemWriteE,    
    input LoadNpcE,
    
    output reg [31:0] PC_MEM,    
    output reg [31:0] AluOutM,
    output reg [31:0] StoreDataM,
    output reg [4:0] RdM,
    output reg [2:0] RegWriteM,
    output reg MemToRegM,
    output reg [3:0] MemWriteM,
    output reg LoadNpcM
);
    
    always@(posedge clk) begin
        if(en) begin
            AluOutM <= clear ? 32'b0 : AluOutE;
            StoreDataM <= clear ? 32'b0 : ForwardData2;
            RdM <= clear ?  5'b0 : RdE;
            PC_MEM <= clear ? 32'b0 : PC_EX;
            RegWriteM <= clear ? 3'b0 : RegWriteE;
            MemToRegM <= clear ? 1'b0 : MemToRegE;
            MemWriteM <= clear ? 4'b0 : MemWriteE;
            LoadNpcM <= clear ? 1'b0 : LoadNpcE;
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
        end
    end
    
endmodule