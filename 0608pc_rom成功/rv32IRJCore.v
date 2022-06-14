`include "define.v"
module rv32IRJCore(
    input wire reset_i_core,
    input wire clk_i_core,
    
    //to IF_ID
    output wire[`InstrBus] instr_i_core
);

wire[`InstrAddrBus] PC_Addr_instrMemROM;
wire PC_chipEn_instrMemROM;

wire[`InstrBus] ROM_instr_IFID;

//pc 
    PC_ PC_0(
        .clk_i_PC(clk_i_core), .reset_i_PC(reset_i_core),
        .pc_addr_o_PC(PC_Addr_instrMemROM), .chip_enable_o_PC(PC_chipEn_instrMemROM)
    );

assign instr_i_core = ROM_instr_IFID;
//ROM
    ROM_InstrMem ROM_InstrMem0(
        .pc_addr_i_ROM(PC_Addr_instrMemROM), .chip_enable_i_ROM(PC_chipEn_instrMemROM),
        .instr_o_ROM(instr_i_core)

    );

endmodule