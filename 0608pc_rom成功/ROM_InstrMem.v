`include "define.v"

module ROM_InstrMem(
    
    input wire [`InstrAddrBus]pc_addr_i_ROM,//31:0
    input wire chip_enable_i_ROM,

    output reg [`InstrBus] instr_o_ROM//31:0

    );

//    reg [`InstrBus] rom [`RomMemNum-1];
    //there are 1024(==RomMemNum) registers, and
    //32(==InstrBus) Bits for each register 
    //rom start addr 8'b00000000

    reg [`InstrBus] rom [0:`RomMemNum];
    //there are 1024(==RomMemNum) registers, and
    //32(==InstrBus) Bits for each register 
    //rom start addr 8'b00000000

//    reg [`InstrBus] rom [`RomMemNum];
    //there are 1024(==RomMemNum) registers, and
    //32(==InstrBus) Bits for each register 
    //rom start addr 8'b00000000

    always @(*) begin
        if(chip_enable_i_ROM == `ChipDisable) begin //`ChipDisable == 1'b0
            instr_o_ROM <= `ZeroWord;
        end
        else begin//chip_enable_i == `ChipEnable
            instr_o_ROM <= rom[pc_addr_i_ROM];
        end
    end

    
endmodule