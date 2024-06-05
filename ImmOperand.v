`include "Parameters.v"  
//对当前指令中立即数拼接，并实现位数扩展 
module ImmOperand(
    input wire [31:7] Instpart,//指令除操作码以外的部分
    input wire [2:0] ImmType,//立即数编码类型
    output reg [31:0] Out//结果
    );
	always@(*)
	begin
		case(ImmType)
			`ITYPE: Out <= { {21{Instpart[31]}}, Instpart[30:20] };
			`STYPE: Out <= { {21{Instpart[31]}}, Instpart[30:25], Instpart[11:7] };
			`BTYPE: Out <= { {20{Instpart[31]}}, Instpart[7], Instpart[30:25], Instpart[11:8], 1'b0 };
			`UTYPE: Out <= { Instpart[31:12], {12{1'b0}} };
			`JTYPE: Out <= { {12{Instpart[31]}}, Instpart[19:12], Instpart[20], Instpart[30:21], 1'b0 };
			default: Out <= 32'hx;
		endcase
	end
endmodule
