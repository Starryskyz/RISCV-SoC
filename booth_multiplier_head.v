module half_adder (
    input  wire [1:0]  cin ,
    output wire        Cout,
    output wire        S    
);
    assign S    = (cin[0]&~cin[1])|(~cin[0]&cin[1]);
    assign Cout = cin[0]&cin[1];
endmodule
//////////////////////////////////////////////////////////////////////////////////
module full_adder (
    input  wire  [2:0] cin ,
    output wire        Cout,
    output wire        S    
);
    assign S = (cin[0]&~cin[1]&~cin[2])|(~cin[0]&cin[1]&~cin[2])|(~cin[0]&~cin[1]&cin[2])|(cin[0]&cin[1]&cin[2]);
    assign Cout = cin[0]&cin[1]|cin[0]&cin[2]|cin[1]&cin[2];
endmodule
//////////////////////////////////////////////////////////////////////////////////
module adder4
(
input    wire          cin ,//来自低位的进位输入
input    wire [3:0]    p   ,//p=a|b 进位传递因子
input    wire [3:0]    g   ,//g=a&b 进位生成因子
output   wire          G   ,//下一级的进位生成因子
output   wire          P   ,//下一级的进位传递因子
output   wire [2:0]    cout //每个bit对应的进位输出
);

assign P=&p;
assign G=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);
assign cout[0]=g[0]|(p[0]&cin);
assign cout[1]=g[1]|(p[1]&g[0])|(p[1]&p[0]&cin);
assign cout[2]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin);
endmodule
//////////////////////////////////////////////////////////////////////////////////
module adder32(
    input  wire [31:0]  a   ,//输入数据，二进制补码
    input  wire [31:0]  b   ,//输入数据，二进制补码
    input  wire         cin ,//来自低位的进位输入
    output wire [31:0]  out ,//输出和a + b，二进制补码（不包含最高位的进位）
    output wire         cout //输出和a + b，的进位
);

// level1
wire [31:0] p1 = a|b;
wire [31:0] g1 = a&b;
wire [31:0] c;//每一位的进位输出
wire [7:0] p2, g2;
wire [1:0] p3, g3;
assign c[0] = cin;

genvar j;
generate
    for (j = 0; j<8; j=j+1) begin
        adder4 u_adder4_l1 (.p(p1[(4*j+3)-:4]),.g(g1[(4*j+3)-:4]),.cin(c[j*4]),.P(p2[j]),.G(g2[j]),.cout(c[(4*j+3)-:3]));
    end
endgenerate

// level2
generate
    for (j = 0; j<2; j=j+1) begin
        adder4 u_adder4_l2 (.p(p2[(4*j+3)-:4]),.g(g2[(4*j+3)-:4]),.cin(c[j*16]),.P(p3[j]),.G(g3[j]),.cout({c[j*16+12],c[j*16+8],c[j*16+4]}));
    end
endgenerate

// level3
assign c[16]=g3[0]|(p3[0]&c[0]);

// 得到进位后计算加法和
assign cout = (a[31]&b[31]) | (a[31]&c[31]) | (b[31]&c[31]);
assign out = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);

endmodule
//////////////////////////////////////////////////////////////////////////////////
module booth_decoder (
    input  wire [31:0] xin ,//乘数x
    input  wire [2: 0] yin ,//从程序y选取的，3bit控制信号
    output wire        cout,//得到的部分积如果是负数的话，需要"取反加一"，这里用来指示是否"加一"
    output wire [32:0] xout //booth编码后得到的1个部分积（待修正）
);
    // wire x_none = (~yin[2]&~yin[1]&~yin[0])|(yin[2]&yin[1]&yin[0]);
    wire x_add1 = (~yin[2]&~yin[1]&yin[0])|(~yin[2]&yin[1]&~yin[0]);
    wire x_add2 = (~yin[2]&yin[1]&yin[0]);
    wire x_sub2 = (yin[2]&~yin[1]&~yin[0]);
    wire x_sub1 = (yin[2]&~yin[1]&yin[0])|(yin[2]&yin[1]&~yin[0]);

    assign xout = {33{x_add1}} & {xin[31],xin}//加法为正数，符号位为0
                | {33{x_add2}} & {xin[31:0],1'b0}
                | {33{x_sub1}} & {~xin[31],~xin} 
                | {33{x_sub2}} & ({~xin[31:0],1'b1}) 
                ;
    assign cout = x_sub1|x_sub2;
endmodule
//////////////////////////////////////////////////////////////////////////////////
module booth_decoder_16 (
    input  wire [31:0] xin       ,//乘数x
    input  wire [31:0] yin       ,//乘数y，依序取其3bit进行译码得到booth编码的选择信号
    output wire [15:0] cout      ,//得到的部分积如果是负数的话，需要"取反加一"，这里用来指示是否"加一"
    // output wire [31:0] xout[7:0]  //booth编码后得到的8个部分积（待修正）
    output wire [63:0] xout0     ,
    output wire [63:0] xout1     ,
    output wire [63:0] xout2     ,
    output wire [63:0] xout3     ,
    output wire [63:0] xout4     ,
    output wire [63:0] xout5     ,
    output wire [63:0] xout6     ,
    output wire [63:0] xout7     ,
    output wire [63:0] xout8     ,
    output wire [63:0] xout9     ,
    output wire [63:0] xout10    ,
    output wire [63:0] xout11    ,
    output wire [63:0] xout12    ,
    output wire [63:0] xout13    ,
    output wire [63:0] xout14    ,
    output wire [63:0] xout15    
    
);
wire [63:0] xout[15:0];
assign xout0 = xout[0];
assign xout1 = xout[1];
assign xout2 = xout[2];
assign xout3 = xout[3];
assign xout4 = xout[4];
assign xout5 = xout[5];
assign xout6 = xout[6];
assign xout7 = xout[7];
assign xout8 = xout[8];
assign xout9 = xout[9];
assign xout10 = xout[10];
assign xout11 = xout[11];
assign xout12 = xout[12];
assign xout13 = xout[13];
assign xout14 = xout[14];
assign xout15 = xout[15];

wire [32:0] yin_t = {yin,1'b0};
wire [32:0] xout_t[15:0];
genvar j;
generate
    for(j=0; j<16; j=j+1)
    begin:booth_decoder_loop
        booth_decoder u_booth_decoder(
        	.xin  (xin  ),
            .yin  (yin_t[(j+1)*2-:3]),
            .xout (xout_t[j]),
            .cout (cout[j] )
        );
        assign xout[j]={{(31-j*2){xout_t[j][32]}},xout_t[j],{(j*2){cout[j]}}};
        // 低位默认是0，负数的话，进行取反
    end
endgenerate
endmodule
//////////////////////////////////////////////////////////////////////////////////
module wallace_1_16(
    input   [15: 0]    N   ,// N个1bit数进行压缩(拥有相同的权重)
    input   [15: 0]    cin ,// 来自右侧的进位(index大的在高层)
    output             C   ,// 最后一级计算的C
    output             S   ,// 最后一级计算的S
    output  [15: 0]     cout // 传递到左侧的进位
);
    // layer 1
    wire [11: 0]    layer_2_in;
    full_adder u_adder_l1_1(.cin(N[15-:3]),.Cout(cout[0]),.S(layer_2_in[11]));
    full_adder u_adder_l1_2(.cin(N[12-:3]),.Cout(cout[1]),.S(layer_2_in[10]));
    full_adder u_adder_l1_3(.cin(N[9-:3]),.Cout(cout[2]),.S(layer_2_in[9]));
    full_adder u_adder_l1_4(.cin(N[6-:3]),.Cout(cout[3]),.S(layer_2_in[8]));
    half_adder u_adder_l1_5(.cin(N[3-:2]),.Cout(cout[4]),.S(layer_2_in[7]));
    half_adder u_adder_l1_6(.cin(N[1-:2]),.Cout(cout[5]),.S(layer_2_in[6]));
    assign layer_2_in[5:0] = cin[5:0];
    
    // layer 2
    wire [7: 0]    layer_3_in;
    full_adder u_adder_l2_1(.cin(layer_2_in[11-:3]),.Cout(cout[6]),.S(layer_3_in[7]));
    full_adder u_adder_l2_2(.cin(layer_2_in[8-:3]),.Cout(cout[7]),.S(layer_3_in[6]));
    full_adder u_adder_l2_3(.cin(layer_2_in[5-:3]),.Cout(cout[8]),.S(layer_3_in[5]));
    full_adder u_adder_l2_4(.cin(layer_2_in[2-:3]),.Cout(cout[9]),.S(layer_3_in[4]));
    assign layer_3_in[3:0] = cin[9:6];

    // layer 3
    wire [5: 0]    layer_4_in;
    full_adder u_adder_l3_1(.cin(layer_3_in[7-:3]),.Cout(cout[10]),.S(layer_4_in[5]));
    full_adder u_adder_l3_2(.cin(layer_3_in[4-:3]),.Cout(cout[11]),.S(layer_4_in[4]));
    half_adder u_adder_l3_3(.cin(layer_3_in[1-:2]),.Cout(cout[12]),.S(layer_4_in[3]));
    assign layer_4_in[2:0] = cin[12:10];

    // layer 4
    wire [3:0]    layer_5_in;
    full_adder u_adder_l4_1(.cin(layer_4_in[5-:3]),.Cout(cout[13]),.S(layer_5_in[3]));
    full_adder u_adder_l4_2(.cin(layer_4_in[2-:3]),.Cout(cout[14]),.S(layer_5_in[2]));
    assign layer_5_in[1:0] = cin[14:13];
    
    // layer 5
    wire [2:0]    layer_6_in;
    full_adder u_adder_l5_1(.cin(layer_5_in[3-:3]),.Cout(cout[15]),.S(layer_6_in[2]));
    assign layer_6_in[1:0] = {layer_5_in[0],cin[15]};

    // layer 6
    full_adder u_adder_l6_1(.cin(layer_6_in[2-:3]),.Cout(C      ),.S(S            ));

endmodule
//////////////////////////////////////////////////////////////////////////////////
module wallace_64_16(
    // input wire [31:0]  xin[7:0] ,//booth编码后得到的8个部分积
    input wire [63:0]  xin0     ,
    input wire [63:0]  xin1     ,
    input wire [63:0]  xin2     ,
    input wire [63:0]  xin3     ,
    input wire [63:0]  xin4     ,
    input wire [63:0]  xin5     ,
    input wire [63:0]  xin6     ,
    input wire [63:0]  xin7     ,
    input wire [63:0]  xin8     ,
    input wire [63:0]  xin9     ,
    input wire [63:0]  xin10    ,
    input wire [63:0]  xin11    ,
    input wire [63:0]  xin12    ,
    input wire [63:0]  xin13    ,
    input wire [63:0]  xin14    ,
    input wire [63:0]  xin15    ,
    input wire [15:0]   cin      ,//32位数的wallace树最右侧的cin
    output wire [63:0] C        ,//32位数的wallace树最上面的输出进位C
    output wire [63:0] S        ,//32位数的wallace树最上面的输出结果S
    output wire [15:0]  cout      //32位数的wallace树最左侧的cout，被丢弃了，没用
);

wire [15:0] c_t[64:0];
assign c_t[0] = cin[15:0];
genvar j;
generate
    for(j=0; j<64; j=j+1)
    begin:wallace_1_16_loop
        wallace_1_16 u_wallace_1_16(
        	.N    ({xin15[j],xin14[j],xin13[j],xin12[j],xin11[j],xin10[j],xin9[j],xin8[j],xin7[j],xin6[j],xin5[j],xin4[j],xin3[j],xin2[j],xin1[j],xin0[j]}),
            .cin  (c_t[j]   ),
            .C    (C[j]     ),
            .S    (S[j]     ),
            .cout (c_t[j+1] )
        );
    end
endgenerate

assign cout = c_t[32];

endmodule
