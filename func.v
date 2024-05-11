`timescale 1ns/1ps

module riscv_kernel_tb2();

    logic [4:0]dmem_address0;
    logic dmem_ce0;
    logic dmem_we0;
    logic [31:0]dmem_d0;
    logic [31:0]dmem_q0;
    
    logic [5:0]imem_address0;
    logic imem_ce0;
    logic [31:0]imem_q0;

    logic clk;
    logic reset;
    logic start;
    logic done;
    logic idle;
    logic ready;

    riscv_kernel_dmem riscv_kernel_dmem_test(
        .reset(reset),
        .clk(~clk),
        .address0(dmem_address0),
        .ce0(dmem_ce0),
        .we0(dmem_we0),
        .d0(dmem_d0),
        .q0(dmem_q0)
    );

    riscv_kernel_imem riscv_kernel_imem_test(
        .reset(reset),
        .clk(~clk),
        .address0(imem_address0),
        .ce0(imem_ce0),
        .q0(imem_q0)
    );

    riscv_kernel riscv_kernel_test(
        ./*ap_*/clk(clk),
        ./*ap_*/rst(reset),
//        ./*ap_*/start(start),
//        ./*ap_*/done(done),
//        ./*ap_*/idle(idle),
//        ./*ap_*/ready(ready),
        .imem_address0(imem_address0),
        .imem_ce0(imem_ce0),
        .imem_q0(imem_q0),
        .dmem_address0(dmem_address0),
        .dmem_ce0(dmem_ce0),
        .dmem_we0(dmem_we0),
        .dmem_d0(dmem_d0),
        .dmem_q0(dmem_q0)
    );

    initial
    begin
        clk = 0;
        forever
        begin
            #5 clk = ~clk;
        end
    end

    initial
    begin
        reset =0;
        start = 0;
        #20 ;///////
        #20 reset = 1;
        #10 reset = 0;
        //#10 start = 1;
        //#10 start = 0;
        while(1)begin
            #10;
            dmem_verify();
            if($time > 100000) begin
                $display("dmem test failed");
                $finish;
            end
        end
    end

    task dmem_verify();
        logic [31:0]dmem_golden[0:9];
        automatic int correct = 0;
            dmem_golden[0] = -256;
            dmem_golden[1] = 15;
            dmem_golden[2] = -241;
            dmem_golden[3] = 4;
        for(int i = 0; i < 4; i = i + 1) begin
            if(riscv_kernel_dmem_test.riscv_kernel_dmem_ram_U.ram[i] == dmem_golden[i]) begin
                correct = correct + 1;
            end
        end
        if(correct == 4 /*&& idle==1*/) begin
            $display("dmem test passed");
            $display("RUN TIME  : %6dns", ($time-60));
            $display("RUN CYCLES: %6d", ($time-60)/10);
            $display("CPI       : %6.3f", ($time-60.0)/(400.0));
            $finish;
        end
    endtask

endmodule
                



module riscv_kernel_dmem_ram (addr0, ce0, d0, we0, q0,  clk);

parameter DWIDTH = 32;
parameter AWIDTH = 5;
parameter MEM_SIZE = 64;

input[AWIDTH-1:0] addr0;
input ce0;
input[DWIDTH-1:0] d0;
input we0;
output reg[DWIDTH-1:0] q0;
input clk;

reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];

initial begin
    for(int i = 0; i < MEM_SIZE; i = i + 1) begin
        ram[i] = 0;
    end
end



always @(posedge clk)  
begin 
    if (ce0) begin
        if (we0) 
            ram[addr0] <= d0; 
        q0 <= ram[addr0];
    end
end


endmodule


module riscv_kernel_dmem(
    reset,
    clk,
    address0,
    ce0,
    we0,
    d0,
    q0);

parameter DataWidth = 32'd32;
parameter AddressRange = 32'd64;
parameter AddressWidth = 32'd5;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
input we0;
input[DataWidth - 1:0] d0;
output[DataWidth - 1:0] q0;



riscv_kernel_dmem_ram riscv_kernel_dmem_ram_U(
    .clk( clk ),
    .addr0( address0 ),
    .ce0( ce0 ),
    .we0( we0 ),
    .d0( d0 ),
    .q0( q0 ));

endmodule



module riscv_kernel_imem_rom (
addr0, ce0, q0, clk);

parameter DWIDTH = 32;
parameter AWIDTH = 6;
parameter MEM_SIZE = 40;

input[AWIDTH-1:0] addr0;
input ce0;
output reg[DWIDTH-1:0] q0;
input clk;

reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];

initial begin
    $readmemh("/home/zhangjianrong/Desktop/imem_tb1.dat", ram);//change the file address according to the file location
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[addr0];
    end
end



endmodule


module riscv_kernel_imem(
    reset,
    clk,
    address0,
    ce0,
    q0);

parameter DataWidth = 32'd32;
parameter AddressRange = 32'd40;
parameter AddressWidth = 32'd6;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
output[DataWidth - 1:0] q0;



riscv_kernel_imem_rom riscv_kernel_imem_rom_U(
    .clk( clk ),
    .addr0( address0 ),
    .ce0( ce0 ),
    .q0( q0 ));

endmodule