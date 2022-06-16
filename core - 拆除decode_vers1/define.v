`define CpuRstAddr 32'd0

`define InstrAddrBus 31:0//PCaddress 
`define InstrBus 31:0

`define RstEnable 1'b1
`define RstDisable 1'b0 

`define ChipEnable 1'b1 
`define ChipDisable 1'b0

`define ZeroWord 32'b0;


// RomMem_InstrFetch
`define RomMemNum 1024 //2^10
`define RomMemNumLog2 1024 //10bit

//IF_ID
`define Opcode6_0 6:0 
`define OpNop 6'b000000
`define InstrNop 32'd0//

//ID
`define RegAddrBus 4:0//5-bit
`define OpcodeBus 6:0//7-bit
`define ZeroOpcode 7'b0
`define rdBus 4:0//5-bit
`define func3Bus 2:0//3-bit
`define Zerofunc3 3'b0
`define func7Bus 6:0//7-bit
`define Zerofunc7 7'b0
`define rs1Bus 4:0//5-bit
`define rs2Bus 4:0//5-bit
`define imm12Bus 11:0//12-bit
`define shamt_I 4:0//5-bit

`define ZeroRegAddr 5'b0

//RefgFile
`define RegFileNum 512
`define RegDataBits 32


`define RegDataBus 31:0//5-bit
`define ZeroRegData 32'b0

// opcpde
`define I_Type 7'b0010011//addi, slti, sltiu, xori, ori, andi
`define I_Type_J 7'b1100111  
`define I_Type_Ld 7'b0000011 

`define RdEnable 1'b1
`define RdDisable 1'b0


//Control Unit

//func3
`define func3_ANDI 3'b111//7
`define func3_ORI 3'b110//6
`define func3_XORI 3'b100//4
`define func3_SLTI 3'b010//2
`define func3_SLTIU 3'b011//3
`define func3_ADDI 3'b000//0
`define func3_SLLI 3'b001//1

`define func3_SRLI_SRAI 3'b101//5

`define func_LB 3'b000
`define func_LH 3'b001
`define func_LW 3'b010
`define func_LBU 3'b100
`define func_LHU 3'b101 

//Write
`define WrtEnable 1'b1
`define WrtDisable 1'b0

`define ALUOpBus 4:0
`define ZeroALUOp 5'b0

//ALUop
//I-type
`define ANDI 5'b00000//0
`define ORI 5'b00001//1
`define XORI 5'b00010//2
`define SLTI 5'b00011//3
`define SLTIU 5'b00100//4
`define ADDI 5'b00101//5
`define SLLI 5'b00110//6
`define SRLI 5'b00111//7
`define SRAI 5'b01000//8

`define LW 5'b01001//9
`define LB 5'b01010//10
`define LH 5'b01011//11
`define LBU 5'b01100//12
`define LHU 5'b01101//13

`define JALR 5'b01110//14

//R-type
`define AND 5'b10000//0
`define OR 5'b10001//1
`define XOR 5'b10010//2
`define SLT 5'b10011//3
`define SLTU 5'b10100//4
`define ADD 5'b10101//5
`define SUB 5'b10110//6
`define SLL 5'b10111//7
`define SRL 5'b11000//8
`define SRA 5'b11001//9
 

