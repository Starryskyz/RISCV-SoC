
//32个32位通用寄存器组,异步读，下降沿同步写入
module RegisterFile(
    input wire clk,
    input wire rst,
    input wire [4:0] Address1,//A1寄存器地址
    input wire [4:0] Address2,//A2寄存器地址
    input wire [4:0] Address3,//A3寄存器地址
    input wire RegWriteEN3,//A3寄存器写使能
    input wire [31:0] RegDataW3,//A3寄存器写数据
    output wire [31:0] RegDataR1,//A1寄存器读数据
    output wire [31:0] RegDataR2//A2寄存器读数据
    );
    reg [31:0] RegFile[31:1];
    integer i;
    always@(negedge clk or posedge rst) 
    begin 
        if(rst)
            for( i=1; i<32; i=i+1) 
            RegFile[i][31:0] <= 32'b0;
        else if( (RegWriteEN3 == 1'b1) && (Address3 != 5'b0) )
            RegFile[Address3] <= RegDataW3;
            else
            RegFile[Address3] <= RegFile[Address3];   
    end
 
    assign RegDataR1 = (Address1==5'b0) ? 32'b0 : RegFile[Address1];
    assign RegDataR2 = (Address2==5'b0) ? 32'b0 : RegFile[Address2];
    
endmodule

