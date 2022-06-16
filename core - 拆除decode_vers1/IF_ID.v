`include "define.v"

module IF_ID(
// from ROM
    input wire [`InstrBus] instr_i_IFID, //31:0
    input wire [`InstrAddrBus] pc_addr_i_IFID, //31:0

    input wire clk_i_IFID,
    input wire rst_i_IFID,
// to Decode
    output reg [`InstrAddrBus] pc_addr_o_IFID, //31:0
    output reg [`InstrBus] instr_o_IFID//31:0
);
    always @(posedge clk_i_IFID) begin
        if(rst_i_IFID == `RstEnable) begin
            instr_o_IFID <= `InstrNop;
            pc_addr_o_IFID <= `CpuRstAddr;
        end 
        else begin //rst_i == `RstDisable
            instr_o_IFID <= instr_i_IFID;
            pc_addr_o_IFID <= pc_addr_i_IFID;
            $display("IFID_\trst_i == `RstDisable  instr_o_IFID:%b   pc_addr_o_IFID:%b ", instr_o_IFID, pc_addr_o_IFID);
        end
    end

endmodule
