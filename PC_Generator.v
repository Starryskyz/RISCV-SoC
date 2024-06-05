//����������������µ�PCָ��
module PC_Generator(
    input clk,
    input rst,
    input en,
    
    input wire [31:0] PC_IF,//��PC
    input wire [31:0] JalTarget,//jalָ��Ķ�Ӧ����תĿ��    
    input wire [31:0] JalrTarget,//jalrָ��Ķ�Ӧ����תĿ��
    input wire [31:0] BranchTarget,//branchָ��Ķ�Ӧ����תĿ��
    input wire JalD,//Ϊ1��ʾID�׶ε�Jalָ��ȷ����ת
    input wire BranchE,//Ϊ1��ʾEx�׶ε�Branchָ��ȷ����ת
    input wire JalrE,//Ϊ1��ʾEx�׶ε�Jalrָ��ȷ����ת
    output reg [31:0] PC_Out//�����PC
    );
    always @(posedge clk) begin
        if(rst)
            PC_Out <= 32'd0;
        else if(en) begin
            if(BranchE)
		         PC_Out <= BranchTarget;
            else if(JalrE)
			     PC_Out <= JalrTarget;
		    else if(JalD)//EX�ε��źű�ID�ε��ź���һ��ָ���������ȶ��ú�
			     PC_Out <= JalTarget;
		    else
			     PC_Out <= PC_IF + 32'd4;
	    end
	    else 
	       PC_Out <= PC_Out;
	end
	
	/*
	always @(*)
		if(BranchE)
			PC_Out = BranchTarget;
		else if(JalrE)
			PC_Out = JalrTarget;
		else if(JalD)//EX�ε��źű�ID�ε��ź���һ��ָ���������ȶ��ú�
			PC_Out = JalTarget;
		else
			PC_Out = PC_IF + 32'd4;
			
			
			
			
			
      
    always @(posedge clk)
        if(en) 
        begin
            if(clear)
                PC_IF <= 32'b0;//���㡢��ˢ
            else 
                PC_IF <= PC_In;
        end
        else
            PC_IF <= PC_IF;//ͣ��
    
			
			*/
endmodule


