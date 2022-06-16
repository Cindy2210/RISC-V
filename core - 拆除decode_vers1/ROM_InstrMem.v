`include "define.v"

module ROM_InstrMem(
// from PC_
    input wire [`InstrAddrBus]pc_addr_i_ROM,//31:0
    input wire chip_enable_i_ROM,
// to IFID
    output reg [`InstrBus] instr_o_IFID,//31:0
    output reg [`InstrAddrBus] pc_addr_o_IFID

    );

    reg [`InstrBus] rom [0:`RomMemNum];
    //there are 1024(==RomMemNum) registers, and
    //32(==InstrBus) Bits for each register 
    //rom start addr 8'b00000000

    always @(*) begin
        if(chip_enable_i_ROM == `ChipDisable) begin //`ChipDisable == 1'b0
            instr_o_IFID <= `ZeroWord;
            pc_addr_o_IFID <= `CpuRstAddr;
        end
        else begin//chip_enable_i == `ChipEnable
            instr_o_IFID <= rom[pc_addr_i_ROM];
            pc_addr_o_IFID <= pc_addr_i_ROM;
//            $display("PC_\tinstr_o_ROM <= rom[pc_addr_i_ROM]:%b ", instr_o_ROM);
        end
    end

    
endmodule