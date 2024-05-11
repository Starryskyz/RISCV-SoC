//处理流水线冲突，通过前移，停顿以及冲刷解决数据冒险和控制冒险
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
		FlushF <= rst;//IF寄存器（PC寄存器）只有初始化时需要清空
		FlushD <= rst || (BranchE || JalrE || JalD);//ID寄存器（处于IF/ID之间的寄存器）在发生3种跳转时清空
		FlushE <= rst || (MemToRegE && (RdE == Rs1D || RdE == Rs2D)) || (BranchE || JalrE);//EX寄存器在发生2种跳转和无法转发的数据相关时清空
		FlushM <= rst;//MEM寄存器（处于EX/MEM之间的寄存器）只有初始化时需要清空
		FlushW <= rst;//WB寄存器（处于MEM/WB之间的寄存器）只有初始化时需要清空
		StallF <= ~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D));//此时停顿
		StallD <= ~rst && (MemToRegE && (RdE == Rs1D || RdE == Rs2D));//此时停顿
		StallE <= 1'b0;
		StallM <= 1'b0;
		StallW <= 1'b0;
	end


	always@(*) begin
		//数据前移
		//当前指令在EX阶段
		//默认forward=2'b00
		//如果RegWriteM不为0，说明上一条指令（此时在MEM阶段）的ALU结果要写回寄存器----情况1----forward=2'b01
		//如果RegWriteW不为0，说明上上一条指令（此时在WB阶段）的访存结果要写回寄存器----情况2----forward=2'b10
		Forward1E[0] <= RdW != 0 && |RegWriteW && RegReadE[1] && (RdW == Rs1E) && ~(|RegWriteM && RegReadE[1] && (RdM == Rs1E));//如果上上条指令写回位置是Rs1E，上条指令也是，则应该取上条指令写的值
		Forward1E[1] <= RdM != 0 && |RegWriteM && RegReadE[1] && (RdM == Rs1E);

		Forward2E[0] <= RdW != 0 && |RegWriteW && RegReadE[0] && (RdW == Rs2E) && ~(|RegWriteM && RegReadE[0] && (RdM == Rs2E));//如果上上条指令写回位置是Rs2E，上条指令也是，则应该取上条指令写的值
		Forward2E[1] <= RdM != 0 && |RegWriteM && RegReadE[0] && (RdM == Rs2E);
	end
endmodule

