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

// 
`define I_Type 0010011//addi, slti, sltiu, xori, ori, andi
// `define I_Type_J 1100111  
//`define I_Type_Ld 0000011 



