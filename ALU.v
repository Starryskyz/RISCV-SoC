`include "Parameters.v"   


module ALU(
    input [31:0] Operand1,
    input [31:0] Operand2,
    input [3:0] AluType,
    output reg [31:0] AluOut,
	output reg [31:0] AluToPC
);
    
    wire [63:0] Product;
    assign Product = Operand1 * Operand2;
    /*
    booth_multiplier u_booth_multiplier(
    .a(Operand1),
    .b(Operand2),
    .product(Product)
    );    
    */
    
	always@(*) begin
		case (AluType)
			`ADD: AluToPC = Operand1 + Operand2;
			`SUB: AluToPC = Operand1 - Operand2;
			`AND: AluToPC = Operand1 & Operand2;
			`OR : AluToPC = Operand1 | Operand2;
			`XOR: AluToPC = Operand1 ^ Operand2;
			`SLT: begin
					if(Operand1[31] == Operand2[31]) 
						AluToPC = (Operand1 < Operand2) ? 32'b1 : 32'b0;
					else 
						AluToPC = (Operand1[31] < Operand2[31]) ? 32'b0 : 32'b1;//different sign
                  end
			`SLTU: AluToPC = (Operand1 < Operand2) ? 32'b1 : 32'b0;
			`SLL: AluToPC = Operand1 << Operand2[4:0];
			`SRL: AluToPC = Operand1 >> Operand2[4:0];
			`SRA: AluToPC = $signed(Operand1) >>> Operand2[4:0];//arithmetic shift right
			`LUI: AluToPC = Operand2;
			//`MUL: AluOut = Product[31:0];
			//`MULH: AluOut = Product[63:32];
			//`MULHSU: AluOut = Product[63:32];
			//`MULHU: AluOut = Product[63:32];
			default: AluToPC = 32'h0;
		endcase
	end

	always@(*) begin
		case (AluType)
			`MUL: AluOut = Product[31:0];
			//`MULH: AluOut = Product[63:32];
			//`MULHSU: AluOut = Product[63:32];
			//`MULHU: AluOut = Product[63:32];
			default: AluOut = AluToPC;
		endcase
	end


endmodule


