`include "Parameters.v"   
//DataExt是用来处理非字对齐load的情形，同时根据load的不同模式对Data Mem中load的数进行符号或者无符号拓展
module DataProcess(
    input wire [31:0] din,
    input wire [1:0] LoadedBytesSelect,
    input wire [2:0] RegWriteW,
    output reg [31:0] dout
    );    
	always@(*) 
		case(RegWriteW)
			`NOREGWRITE: dout = 32'hxxxxxxxx;
			`LB: 
				case(LoadedBytesSelect)
					2'b00: dout = {{24{din[7]}}, din[7:0]};
					2'b01: dout = {{24{din[15]}}, din[15:8]};
					2'b10: dout = {{24{din[23]}}, din[23:16]};
					2'b11: dout = {{24{din[31]}}, din[31:24]};
					default: dout = 32'hxxxxxxxx;
				endcase
			`LH:
				case(LoadedBytesSelect)
					2'b00: dout = {{16{din[15]}}, din[15:0]};
					2'b10: dout = {{16{din[31]}}, din[31:16]};
					default: dout = 32'hxxxxxxxx;
				endcase
			`LW:
				dout = din;
			`LBU:
				case(LoadedBytesSelect)
					2'b00: dout = {{24{1'b0}}, din[7:0]};
					2'b01: dout = {{24{1'b0}}, din[15:8]};
					2'b10: dout = {{24{1'b0}}, din[23:16]};
					2'b11: dout = {{24{1'b0}}, din[31:24]};
					default: dout = 32'hxxxxxxxx;
				endcase
			`LHU:
				case(LoadedBytesSelect)
					2'b00: dout = {{16{1'b0}}, din[15:0]};
					2'b10: dout = {{16{1'b0}}, din[31:16]};
					default: dout = 32'hxxxxxxxx;
				endcase
			default: dout = 32'hxxxxxxxx;
		endcase
endmodule