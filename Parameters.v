`ifndef CONST_VALUES
`define CONST_VALUES

//OPcode[6:0]
    `define OP_JAL    7'b1101111 
    `define OP_JALR   7'b1100111 
    `define OP_Load   7'b0000011
    `define OP_Store  7'b0100011
    `define OP_Branch 7'b1100011
    `define OP_LUI    7'b0110111
    `define OP_AUIPC  7'b0010111
    `define OP_RegReg 7'b0110011
    `define OP_RegImm 7'b0010011
    `define OP_Vec 7'b1000011

//ALUContrl[3:0]
    `define ADD  4'b0000
    `define SLL  4'b0001
    `define SLT  4'b0010
    `define SLTU 4'b0011
    `define XOR  4'b0100
    `define SRL  4'b0101
    `define OR   4'b0110
    `define AND  4'b0111
    `define SUB  4'b1000
    `define SRA  4'b1101
    `define LUI  4'b1010
    `define MUL  4'b1011
    `define MULH  4'b1100
    `define MULHSU  4'b1100
    `define MULHU  4'b1100

//VectorType    
    `define VM 4'b1111
    `define VL 4'b1001
    `define VS 4'b1101
    
//BranchType[2:0]
    `define NOBRANCH  3'b000
    `define BEQ  3'b110
    `define BNE  3'b111
    `define BLT  3'b010
    `define BGE  3'b011
    `define BLTU  3'b100
    `define BGEU  3'b101
//ImmType[2:0]
    `define ITYPE  3'd1
    `define STYPE  3'd2
    `define BTYPE  3'd3
    `define UTYPE  3'd4
    `define JTYPE  3'd5  
//RegWrite[2:0]  six kind of ways to save values to Register
    `define NOREGWRITE  3'b000	//	Do not write Register
    `define LB  3'b001			//	load 8bit from Mem then signed extended to 32bit
    `define LH  3'b010			//	load 16bit from Mem then signed extended to 32bit
    `define LW  3'b011			//	write 32bit to Register
    `define LBU  3'b101			//	load 8bit from Mem then unsigned extended to 32bit
    `define LHU  3'b110			//	load 16bit from Mem then unsigned extended to 32bit
`endif
