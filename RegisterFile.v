//negedge

module RegisterFile(
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

    
    always@(negedge clk or posedge rst) begin 
        if(rst) begin
            RegFile[0] <= 32'b0;
            RegFile[1] <= 32'b0;
            RegFile[2] <= 32'b0;
            RegFile[3] <= 32'b0;
            RegFile[4] <= 32'b0;
            RegFile[5] <= 32'b0;
            RegFile[6] <= 32'b0;
            RegFile[7] <= 32'b0;
            RegFile[8] <= 32'b0;
            RegFile[9] <= 32'b0;
            RegFile[10] <= 32'b0;
            RegFile[11] <= 32'b0;
            RegFile[12] <= 32'b0;
            RegFile[13] <= 32'b0;
            RegFile[14] <= 32'b0;
            RegFile[15] <= 32'b0;
            RegFile[16] <= 32'b0;
            RegFile[17] <= 32'b0;
            RegFile[18] <= 32'b0;
            RegFile[19] <= 32'b0;
            RegFile[20] <= 32'b0;
            RegFile[21] <= 32'b0;
            RegFile[22] <= 32'b0;
            RegFile[23] <= 32'b0;
            RegFile[24] <= 32'b0;
            RegFile[25] <= 32'b0;
            RegFile[26] <= 32'b0;
            RegFile[27] <= 32'b0;
            RegFile[28] <= 32'b0;
            RegFile[29] <= 32'b0;
            RegFile[30] <= 32'b0;
            RegFile[31] <= 32'b0;
        end
            
        else if( (RegWriteEN3 == 1'b1) && (Address3 != 5'b0) )
            RegFile[Address3] <= RegDataW3;
        else
            RegFile[Address3] <= RegFile[Address3];   
    end
 
    assign RegDataR1 = (Address1==5'b0) ? 32'b0 : RegFile[Address1];
    assign RegDataR2 = (Address2==5'b0) ? 32'b0 : RegFile[Address2];
    
endmodule

