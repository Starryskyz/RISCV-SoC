`include "Parameters.v"

module ImmOperand (
    input [31:7] Instpart,
    input [2:0] ImmType,
    output reg [31:0] Out
);

  always @(*) begin
    case (ImmType)
      `ITYPE:  Out <= {{21{Instpart[31]}}, Instpart[30:20]};
      `STYPE:  Out <= {{21{Instpart[31]}}, Instpart[30:25], Instpart[11:7]};
      `BTYPE:  Out <= {{20{Instpart[31]}}, Instpart[7], Instpart[30:25], Instpart[11:8], 1'b0};
      `UTYPE:  Out <= {Instpart[31:12], {12{1'b0}}};
      `JTYPE:  Out <= {{12{Instpart[31]}}, Instpart[19:12], Instpart[20], Instpart[30:21], 1'b0};
      default: Out <= 32'h0;
    endcase
  end

endmodule
