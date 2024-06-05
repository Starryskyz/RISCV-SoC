//IF/ID段寄存器,实现由传入的PC提取指令存储器InstructionROM预置的命令并将命令及其PC传递到EX段
module ID_reg(
    input wire clk,
    input wire en,//寄存器使能端，控制是否更新值
    input wire clear,//寄存器复位端，用于清空数据
    input wire [31:0] PC_IF,//来自IF_reg寄存器的PC
    input wire [31:0] DataInstF,//从指令存储器对应地址中读出的数据
    output reg [31:0] DataInstD,
    output reg [31:0] PC_ID//输出寄存的PC
    );
 
    always @(posedge clk)
        if(en)
        begin
            PC_ID <= clear ? 32'b0 : PC_IF;//清零、冲刷
            DataInstD <= clear ? 32'b0 : DataInstF;
        end
        else
        begin
            PC_ID <= PC_ID;//停顿
            DataInstD <=  DataInstD;
        end

endmodule