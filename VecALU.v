`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 16:03:35
// Design Name: 
// Module Name: VecALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VecALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire Vec_en,
    input wire [3:0] AluType,
    output [31:0] AluOut
    );
    
    reg [31:0] a;
    reg [31:0] b;
    assign AluOut = a + b;
    
    always @(*) begin
        if(Vec_en)
        begin
            a = Operand1 * Operand1;
            b = Operand2 * Operand2;
        end
        else begin
            a = 32'b0;
            b = 32'b0;
        end
            
    end
    
endmodule
