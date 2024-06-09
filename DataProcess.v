`include "Parameters.v"   

module DataProcess(
    input [31:0] din,
    input [1:0] LoadedBytesSelect,
    input [2:0] RegWriteW,
    output reg [31:0] dout
);    

	always@(*) begin
		case(RegWriteW)
			`NOREGWRITE: dout = 32'h00000000;
			`LB: 
				case(LoadedBytesSelect)
					2'b00: dout = {{24{din[7]}}, din[7:0]};
					2'b01: dout = {{24{din[15]}}, din[15:8]};
					2'b10: dout = {{24{din[23]}}, din[23:16]};
					2'b11: dout = {{24{din[31]}}, din[31:24]};
					default: dout = 32'h00000000;
				endcase
			`LH:
				case(LoadedBytesSelect)
					2'b00: dout = {{16{din[15]}}, din[15:0]};
					2'b10: dout = {{16{din[31]}}, din[31:16]};
					default: dout = 32'h00000000;
				endcase
			`LW:
				dout = din;
			`LBU:
				case(LoadedBytesSelect)
					2'b00: dout = {{24{1'b0}}, din[7:0]};
					2'b01: dout = {{24{1'b0}}, din[15:8]};
					2'b10: dout = {{24{1'b0}}, din[23:16]};
					2'b11: dout = {{24{1'b0}}, din[31:24]};
					default: dout = 32'h00000000;
				endcase
			`LHU:
				case(LoadedBytesSelect)
					2'b00: dout = {{16{1'b0}}, din[15:0]};
					2'b10: dout = {{16{1'b0}}, din[31:16]};
					default: dout = 32'h00000000;
				endcase
			default: dout = 32'h00000000;
		endcase
	end


endmodule