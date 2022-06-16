`include "define.v"
module EXE(
    input wire rst_i_EXE,
// from ID_EXE
    input wire regWrite_i_EXE,
    input wire [`ALUOpBus] ALUOp_i_EXE,
    input wire [`InstrBus] immSignExtend_i_EXE,
    // for dataHazard
    input wire [`RegDataBus] Rd_Data1_i_EXE,
    input wire [`RegDataBus] Rd_Data2_i_EXE,
    input wire [`RegAddrBus] Rd_Addr1_i_EXE,//5-bit [4:0]
    input wire [`RegAddrBus] Rd_Addr2_i_EXE,//5-bit [4:0]

// to EXE_MEM
    output reg [`RegDataBus] Wt_Data_o_EXE,
    output reg [`RegAddrBus] Wt_Addr_o_EXE,
    output reg Wt_Enable_o_EXE,
//to RegFile for dataHazard
//and to EXE_MEM for passing
    output reg [`RegDataBus] Rd_Data1_o_EXE,
    output reg [`RegAddrBus] Rd_Addr1_o_EXE,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data2_o_EXE,
    output reg [`RegAddrBus] Rd_Addr2_o_EXE //5-bit [4:0]

);

    always @(*) begin
        if (rst_i_EXE == `RstEnable) begin 
            Wt_Data_o_EXE <= `ZeroRegData;
            Wt_Addr_o_EXE <= `ZeroRegAddr;
            Wt_Enable_o_EXE <= `WrtDisable;
            Rd_Data1_o_EXE <= `ZeroRegData;
            Rd_Data2_o_EXE <= `ZeroRegData;
            Rd_Addr1_o_EXE <= `ZeroRegAddr;
            Rd_Addr2_o_EXE <= `ZeroRegAddr;
        end
        else begin 
        case (ALUOp_i_EXE)
        `ORI:begin
            Wt_Data_o_EXE <= Rd_Data1_i_EXE|immSignExtend_i_EXE;//rs1|imm32
            Wt_Addr_o_EXE <= Rd_Addr2_i_EXE;
            Wt_Enable_o_EXE <= regWrite_i_EXE;
            Rd_Data1_o_EXE <= Rd_Data1_i_EXE;
            Rd_Data2_o_EXE <= Rd_Data2_i_EXE;
            Rd_Addr1_o_EXE <= Rd_Addr1_i_EXE;
            Rd_Addr2_o_EXE <= Rd_Addr2_i_EXE;
            $display("EXE passing~~~~~~~~~~~~~~~~~~~~\nRd_Addr2_i_EXE:%b  Wt_Addr_o_EXE:%b", Rd_Addr2_i_EXE, Wt_Addr_o_EXE);
        end
        endcase

        end
    end


endmodule