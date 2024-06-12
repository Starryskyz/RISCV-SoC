`timescale 1ns / 1ps

module riscv_kernel_tb2_top(
    input clk_in,
    input rst_n,
    input start_n,
    output right
    );
    
    wire clk;
    assign clk = clk_in;
    //clk_wiz_0 u_clk_wiz(
    //    .clk_in1(clk_in),
    //    .clk_out1(clk),
    //    .reset(~rst_n),
    //    .locked()
    //);
    
    wire [5:0]imem_address0;
    wire imem_ce0;
    wire [31:0]imem_q0;

    wire reset;
    wire done;
    wire idle;
    //wire ready;
    wire start;

    wire [4:0] kernel2dmem_address0;
    wire kernel2dmem_ce0;
    wire kernel2dmem_we0;
    wire [31:0]kernel2dmem_d0;
    wire [31:0]kernel2dmem_q0;

    reg [31:0]dmem_golden[0:9];
    reg [4:0] right_cnt;

    wire [63:0]dmem_vecd;
    wire [63:0]dmem_vecq;
    wire dmem_vec_en;
    

    //
    // wire [63:0] dmem_d;
    // assign dmem_d = dmem_vec_en ? dmem_vecd : {32'b0,kernel2dmem_d0};
    // wire [63:0] dmem_q;
    // assign kernel2dmem_q0 = dmem_q[31:0];
    // assign dmem_vecq = dmem_q;
    //
    wire [31:0]dmem_d_a;
    wire [31:0]dmem_d_b;
    wire [31:0]dmem_q_a;
    wire [31:0]dmem_q_b;
    assign dmem_d_a = dmem_vec_en ?dmem_vecd[31:0]:kernel2dmem_d0;
    assign dmem_d_b = dmem_vecd[63:32];
    assign kernel2dmem_q0 = dmem_q_a;
    assign dmem_vecq = {dmem_q_b,dmem_q_a};


    assign right = (&right_cnt);
    assign start = !start_n;

    initial begin
        dmem_golden[0] = 32'h00000001;
        dmem_golden[1] = 32'h00000005;
        dmem_golden[2] = 32'h00000008;
        dmem_golden[3] = 32'h00000007;
        dmem_golden[4] = 32'h00000002;
        dmem_golden[5] = 32'h0000000d;
        dmem_golden[6] = 32'h00000018;
        dmem_golden[7] = 32'h00000006;
        dmem_golden[8] = 32'h00000003;
        dmem_golden[9] = 32'h0000002c;
        right_cnt = 5'b0;
    end

    assign reset = !rst_n;


    always @(posedge clk) begin
        if(rst_n==0) begin
            right_cnt <= 5'b0;
        end
        else if(kernel2dmem_ce0&&kernel2dmem_we0) begin
            case(kernel2dmem_address0)
                5'b00000: if(dmem_d_a==dmem_golden[0]&&dmem_d_b==dmem_golden[1]) right_cnt[0] <= 1;
                5'b00010: if(dmem_d_a==dmem_golden[2]&&dmem_d_b==dmem_golden[3]) right_cnt[1] <= 1;
                5'b00100: if(dmem_d_a==dmem_golden[4]&&dmem_d_b==dmem_golden[5]) right_cnt[2] <= 1;
                5'b00110: if(dmem_d_a==dmem_golden[6]&&dmem_d_b==dmem_golden[7]) right_cnt[3] <= 1;
                5'b01000: if(dmem_d_a==dmem_golden[8]&&dmem_d_b==dmem_golden[9]) right_cnt[4] <= 1;
                default:;
            endcase
        end
    end

    // riscv_kernel_dmem riscv_kernel_dmem_test(
    //     .reset(reset),
    //     .clk(~clk),
    //     .address0(kernel2dmem_address0),
    //     .ce0(kernel2dmem_ce0),
    //     .we0(kernel2dmem_we0),
    //     .d0(dmem_d),
    //     .q0(dmem_q)
    // );
    //
    //dp_riscv_kernel_dmem_ram riscv_kernel_dmem_test(
    //    .rst_n(~reset),
    //    .clk(~clk),
    //    .wr_en_a(kernel2dmem_we0),
    //    .re_en_a(kernel2dmem_ce0 & (~kernel2dmem_we0)),
    //   .addr_a(kernel2dmem_address0),
    //    .data_in_a(dmem_d_a),
    //    .data_out_a(dmem_q_a),
    //    .wr_en_b(kernel2dmem_we0 & dmem_vec_en),//����д
    //    .re_en_b(kernel2dmem_ce0&(~kernel2dmem_we0)),
    //    .addr_b(kernel2dmem_address0 + 5'b00001),
    //    .data_in_b(dmem_d_b),
    //    .data_out_b(dmem_q_b)
    //);
    blk_mem_gen_0 riscv_kernel_dmem_test(
        .clka(~clk),
        .clkb(~clk),
        .wea(kernel2dmem_we0),
        .addra({1'b0,kernel2dmem_address0}),
        .dina(dmem_d_a),
        .douta(dmem_q_a),
        .web(kernel2dmem_we0 & dmem_vec_en),//����д
        .addrb({1'b0,kernel2dmem_address0} + 5'b00001),
        .dinb(dmem_d_b),
        .doutb(dmem_q_b)
    );

    riscv_kernel_imem riscv_kernel_imem_test(
        .reset(reset),
        .clk(~clk),
        .address0(imem_address0),
        .ce0(imem_ce0),
        .q0(imem_q0)
    );

    riscv_kernel riscv_kernel_test(
        .ap_clk(clk),
        .ap_rst(reset),
        .ap_start(start),
        .ap_done(done),
        .ap_idle(idle),
        //.ap_ready(ready),
        .imem_address0(imem_address0),
        .imem_ce0(imem_ce0),
        .imem_q0(imem_q0),
        .dmem_address0(kernel2dmem_address0),
        .dmem_ce0(kernel2dmem_ce0),
        .dmem_we0(kernel2dmem_we0),
        .dmem_d0(kernel2dmem_d0),
        .dmem_q0(kernel2dmem_q0),
        .dmem_vecd(dmem_vecd),
        .dmem_vecq(dmem_vecq),
        .dmem_vec_en(dmem_vec_en)
    );


endmodule





module dp_riscv_kernel_dmem_ram #(
    parameter 		DWIDTH = 32,//RAM����λ��
    parameter 		AWIDTH = 5,//RAM��ַλ��
    parameter 		DEPTH = 64	//RAM����
    )(
    input           clk,
    input           rst_n,
    
    input           wr_en_a,//a��дʹ��
    input           re_en_a,//a�˶�ʹ��
    input           [AWIDTH-1:0]   addr_a,//a�˵�ַ
    input           [DWIDTH-1:0]   data_in_a,//a����������
    output   reg    [DWIDTH-1:0]   data_out_a,//a����������

    input           wr_en_b,//b��дʹ��
    input           re_en_b,//b�˶�ʹ��
    input           [AWIDTH-1:0]   addr_b,//b�˵�ַ
    input           [DWIDTH-1:0]   data_in_b,//b����������
    output   reg    [DWIDTH-1:0]   data_out_b//b����������
    );
reg [DWIDTH-1:0]    ram [DEPTH-1:0];  
initial begin
    ram[0] = 32'h00000008;
    ram[1] = 32'h00000007;
    ram[2] = 32'h00000003;
    ram[3] = 32'h0000002c;
    ram[4] = 32'h00000001;
    ram[5] = 32'h00000005;
    ram[6] = 32'h00000018;
    ram[7] = 32'h00000006;
    ram[8] = 32'h00000002;
    ram[9] = 32'h0000000d;
end

//a�ˡ�b������д���洢��RAM��   

    always @(posedge clk)begin
        if (wr_en_a & wr_en_b &(addr_a != addr_b))begin
            ram[addr_a] <= data_in_a; 
            ram[addr_b] <= data_in_b; 
        end
        else if (wr_en_a) begin//a��ʹ�ܸߵ�ƽʱд��		
            ram[addr_a] <= data_in_a; 
        end
        else if (wr_en_b) begin //b��ʹ�ܸߵ�ƽʱд��	 		
            ram[addr_b] <= data_in_b; 
        end
        else begin
            ram[addr_a] <= ram[addr_a];
            ram[addr_b] <= ram[addr_b];
        end
    end

//    	    if(!rst_n)begin
//                ram[i] = 0;						
//            end
//            else 


//a�ˡ�b�˶������� 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin							
        data_out_a <= 0;
        data_out_b <= 0;
    end
    else if(re_en_a & re_en_b)begin
        data_out_a <= ram[addr_a];					
        data_out_b <= ram[addr_b];
    end
    else if(re_en_a)begin		
        data_out_a <= ram[addr_a];					
        data_out_b <= data_out_b;
    end
    else if(re_en_b)begin
        data_out_b <= ram[addr_b];					
        data_out_a <= data_out_a;
    end
    else begin
        data_out_a <= data_out_a;
        data_out_b <= data_out_b;
    end
end

endmodule
// module riscv_kernel_dmem_ram (addr0, ce0, d0, we0, q0,  clk);

// parameter DWIDTH = 64;
// parameter AWIDTH = 5;
// parameter MEM_SIZE = 64;

// input[AWIDTH-1:0] addr0;
// input ce0;
// input[DWIDTH-1:0] d0;
// input we0;
// output reg[DWIDTH-1:0] q0;
// input clk;

// reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];

// initial begin
//     ram[0] = 64'h0000000800000007;
//     ram[1] = 64'h00000000;
//     ram[2] = 64'h000000030000002c;
//     ram[3] = 64'h00000000;
//     ram[4] = 64'h0000000100000005;
//     ram[5] = 64'h00000000;
//     ram[6] = 64'h0000001800000006;
//     ram[7] = 64'h00000000;
//     ram[8] = 64'h000000020000000d;
//     ram[9] = 64'h00000000;
// end



// always @(posedge clk)  
// begin 
//     if (ce0) begin
//         if (we0) 
//             ram[addr0] <= d0; 
//         q0 <= ram[addr0];
//     end
// end


// endmodule


// module riscv_kernel_dmem(
//     reset,
//     clk,
//     address0,
//     ce0,
//     we0,
//     d0,
//     q0);

// parameter DataWidth = 32'd64;
// parameter AddressRange = 32'd64;
// parameter AddressWidth = 32'd5;
// input reset;
// input clk;
// input[AddressWidth - 1:0] address0;
// input ce0;
// input we0;
// input[DataWidth - 1:0] d0;
// output[DataWidth - 1:0] q0;



// riscv_kernel_dmem_ram riscv_kernel_dmem_ram_U(
//     .clk( clk ),
//     .addr0( address0 ),
//     .ce0( ce0 ),
//     .we0( we0 ),
//     .d0( d0 ),
//     .q0( q0 ));

// endmodule

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
    $readmemh("C:/Users/Nick/Desktop/riscv_kernel_64_bram/imem_3.dat", ram); //change the file name and address to your .dat file
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[addr0];
    end
end



endmodule




