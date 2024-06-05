//������ˮ�߳�ͻ��ͨ��ǰ�ƣ�ͣ���Լ���ˢ�������ð�պͿ���ð��
module HazardSolving(
    input wire rst,
    input wire BranchE, JalrE, JalD, 
    input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input wire [1:0] RegReadE,
    input wire MemToRegE,
    input wire [2:0] RegWriteM, 
    input wire [2:0] RegWriteW,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW,
    output reg [1:0] Forward1E, 
    output reg [1:0] Forward2E
    );

	always@(*) begin
		FlushF <= rst;//IF�Ĵ�����PC�Ĵ�����ֻ�г�ʼ��ʱ��Ҫ���
		FlushD <= rst || (BranchE || JalrE || JalD);//ID�Ĵ���������IF/ID֮��ļĴ������ڷ���3����תʱ���
		FlushE <= rst || (MemToRegE && (RdE == Rs1D || RdE == Rs2D)) || (BranchE || JalrE);//EX�Ĵ����ڷ���2����ת���޷�ת�����������ʱ���
		FlushM <= rst;//MEM�Ĵ���������EX/MEM֮��ļĴ�����ֻ�г�ʼ��ʱ��Ҫ���
		FlushW <= rst;//WB�Ĵ���������MEM/WB֮��ļĴ�����ֻ�г�ʼ��ʱ��Ҫ���
		StallF <= ~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D));//��ʱͣ��
		StallD <= ~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D));//��ʱͣ��
		StallE <= 1'b0;
		StallM <= 1'b0;
		StallW <= 1'b0;
	end


	always@(*) begin
		//����ǰ��
		//��ǰָ����EX�׶�
		//Ĭ��forward=2'b00
		//���RegWriteM��Ϊ0��˵����һ��ָ���ʱ��MEM�׶Σ���ALU���Ҫд�ؼĴ���----���1----forward=2'b01
		//���RegWriteW��Ϊ0��˵������һ��ָ���ʱ��WB�׶Σ��ķô���Ҫд�ؼĴ���----���2----forward=2'b10
		Forward1E[0] <= RdW != 0 && |RegWriteW && RegReadE[1] && (RdW == Rs1E) && ~(|RegWriteM && RegReadE[1] && (RdM == Rs1E));//���������ָ��д��λ����Rs1E������ָ��Ҳ�ǣ���Ӧ��ȡ����ָ��д��ֵ
		Forward1E[1] <= RdM != 0 && |RegWriteM && RegReadE[1] && (RdM == Rs1E);

		Forward2E[0] <= RdW != 0 && |RegWriteW && RegReadE[0] && (RdW == Rs2E) && ~(|RegWriteM && RegReadE[0] && (RdM == Rs2E));//���������ָ��д��λ����Rs2E������ָ��Ҳ�ǣ���Ӧ��ȡ����ָ��д��ֵ
		Forward2E[1] <= RdM != 0 && |RegWriteM && RegReadE[0] && (RdM == Rs2E);
	end
endmodule

