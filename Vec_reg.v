`timescale 1ns / 1ps

module Vec_reg(
    input wire clk,
    input wire rst,
    input wire [1:0] AddressR,
    input wire [1:0] AddressW,
    input wire RegWriteEN,
    input wire [63:0] RegDataW,
    output wire [31:0] RegDataR1,
    output wire [31:0] RegDataR2
    );
    reg [31:0] RegFile[3:0];
    integer i;
    always@(negedge clk or posedge rst) 
    begin 
        if(rst)
            for(i=0; i<4; i=i+1) 
                RegFile[i] <= 32'b0;
        else if(RegWriteEN == 1'b1) begin
                RegFile[AddressW] <= RegDataW[31:0];
                RegFile[AddressW+1] <= RegDataW[63:32];
            end
            else
                RegFile[AddressW] <= RegFile[AddressW];   
    end
 
    assign RegDataR1 = RegFile[AddressR];
    assign RegDataR2 = RegFile[AddressR+1];
    
endmodule
