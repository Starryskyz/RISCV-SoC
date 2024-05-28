module Crossover (
    input wire clk_in,
    output reg clk_out
);

parameter N=8'd1;

reg [7:0] count;

always @(posedge clk_in) begin
    if (count == N) begin
        clk_out <= ~clk_out;
        count<=0;  
    end
    else begin
        count <= count + 1;
    end
end

endmodule
