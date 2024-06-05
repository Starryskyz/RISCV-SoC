
//32��32λͨ�üĴ�����,�첽�����½���ͬ��д��
module RegisterFile(
    input wire clk,
    input wire rst,
    input wire [4:0] Address1,//A1�Ĵ�����ַ
    input wire [4:0] Address2,//A2�Ĵ�����ַ
    input wire [4:0] Address3,//A3�Ĵ�����ַ
    input wire RegWriteEN3,//A3�Ĵ���дʹ��
    input wire [31:0] RegDataW3,//A3�Ĵ���д����
    output wire [31:0] RegDataR1,//A1�Ĵ���������
    output wire [31:0] RegDataR2//A2�Ĵ���������
    );
    reg [31:0] RegFile[31:0];
    integer i;
    //x0
    always@(negedge clk or posedge rst) 
    begin
        if(rst)
            RegFile[0] <= 32'b0;
        else 
            RegFile[0] <= 32'b0;
    end
    
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

