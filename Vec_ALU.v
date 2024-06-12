module VecALU(
    input [31:0] Operand1,
    input [31:0] Operand2,
    input Vec_en,
    input [3:0] AluType,
    output [31:0] AluOut
);

    reg [31:0] a;
    reg [31:0] b;
    assign AluOut = a + b;

    always @(*) begin
        if(Vec_en) begin
            a = Operand1 * Operand1;
            b = Operand2 * Operand2;
        end
        else begin
            a = 32'b0;
            b = 32'b0;
        end
    end

endmodule