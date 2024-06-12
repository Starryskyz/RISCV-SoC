//negedge

module RegisterFile (
    input clk,
    input rst,
    input [4:0] Address1,
    input [4:0] Address2,
    input [4:0] Address3,
    input RegWriteEN3,
    input [31:0] RegDataW3,
    output wire [31:0] RegDataR1,
    output wire [31:0] RegDataR2
);
  reg [31:0] RegFile[31:0];
  integer i;
  //x0 is always 0


  always @(negedge clk or posedge rst) begin
    if (rst) for (i = 0; i < 32; i = i + 1) RegFile[i][31:0] <= 32'b0;
    else if ((RegWriteEN3 == 1'b1) && (Address3 != 5'b0)) RegFile[Address3] <= RegDataW3;
    else RegFile[Address3] <= RegFile[Address3];
  end

  assign RegDataR1 = (Address1 == 5'b0) ? 32'b0 : RegFile[Address1];
  assign RegDataR2 = (Address2 == 5'b0) ? 32'b0 : RegFile[Address2];

endmodule
