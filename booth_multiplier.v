`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 13:12:08
// Design Name: 
// Module Name: booth_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module booth_multiplier (
    input wire [31:0]  a         ,//输入数据，二进制补码
    input wire [31:0]  b         ,//输入数据，二进制补码
    output wire [63:0] product    //输出乘积a * b，二进制补码
);

// 16个booth两位乘，得到16个32位部分积，并将32个部分积扩展到64位
wire [15:0] cout_t;
wire [63:0] xout_t[15:0];
booth_decoder_16 u_booth_decoder_16(
    .xin  (a        ),
    .yin  (b        ),
    .cout (cout_t   ),//[15:0]  cout
    .xout0(xout_t[0]),
    .xout1(xout_t[1]),
    .xout2(xout_t[2]),
    .xout3(xout_t[3]),
    .xout4(xout_t[4]),
    .xout5(xout_t[5]),
    .xout6(xout_t[6]),
    .xout7(xout_t[7]),
    .xout8(xout_t[8]),
    .xout9(xout_t[9]),
    .xout10(xout_t[10]),
    .xout11(xout_t[11]),
    .xout12(xout_t[12]),
    .xout13(xout_t[13]),
    .xout14(xout_t[14]),
    .xout15(xout_t[15])
    
);

// 64位的wallace树，将16个部分积的和压缩成2个数的和
wire [63:0] C_t;
wire [63:0] S_t;
wire [15:0] wallace_cout_t;
wallace_64_16 u_wallace_64_16(
    .xin0 (xout_t[0])       ,
    .xin1 (xout_t[1])       ,
    .xin2 (xout_t[2])       ,
    .xin3 (xout_t[3])       ,
    .xin4 (xout_t[4])       ,
    .xin5 (xout_t[5])       ,
    .xin6 (xout_t[6])       ,
    .xin7 (xout_t[7])       ,
    .xin8 (xout_t[8])       ,
    .xin9 (xout_t[9])       ,
    .xin10 (xout_t[10])       ,
    .xin11 (xout_t[11])       ,
    .xin12 (xout_t[12])       ,
    .xin13 (xout_t[13])       ,
    .xin14 (xout_t[14])       ,
    .xin15 (xout_t[15])       ,
    .cin  (cout_t[15:0]  )   ,
    .C    (C_t    )         ,
    .S    (S_t    )         ,
    .cout (wallace_cout_t )  
);

// 使用32位超前进位加法器将计算乘法结果
wire adder32_cout;
adder32 u_adder32_0(
    .a    (S_t[31:0] ),
    .b    ({C_t[30:0],1'b0} ),
    .cin  (1'b0  ),
    .out  (product[31:0]  ),
    .cout (adder32_cout )
);

adder32 u_adder32_1(
    .a    (S_t[63:32] ),
    .b    (C_t[62:31] ),
    .cin  (adder32_cout  ),
    .out  (product[63:32]  ),
    .cout ( )
);

endmodule
