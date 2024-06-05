//IF/ID�μĴ���,ʵ���ɴ����PC��ȡָ��洢��InstructionROMԤ�õ�����������PC���ݵ�EX��
module ID_reg(
    input wire clk,
    input wire en,//�Ĵ���ʹ�ܶˣ������Ƿ����ֵ
    input wire clear,//�Ĵ�����λ�ˣ������������
    input wire [31:0] PC_IF,//����IF_reg�Ĵ�����PC
    input wire [31:0] DataInstF,//��ָ��洢����Ӧ��ַ�ж���������
    output reg [31:0] DataInstD,
    output reg [31:0] PC_ID//����Ĵ��PC
    );
 
    always @(posedge clk)
        if(en)
        begin
            PC_ID <= clear ? 32'b0 : PC_IF;//���㡢��ˢ
            DataInstD <= clear ? 32'b0 : DataInstF;
        end
        else
        begin
            PC_ID <= PC_ID;//ͣ��
            DataInstD <=  DataInstD;
        end

endmodule