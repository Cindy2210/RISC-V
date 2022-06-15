module ID_EXE(
    input wire rst_i_ID_EXE,
    input wire clk_i_ID_EXE,

// from Decode
    input wire [`InstrBus] instr_i_ID_EXE,
    input wire [`InstrAddrBus] pc_addr_i_ID_EXE,
    input wire [`ALUOpBus] ALUOp_i_ID_EXE,
    input wire regWrite_i_ID_EXE,
    input wire [`InstrBus] immSignExtend_i_ID_EXE,//31:0
    input wire [`RegAddrBus] Rd_Addr1_i_ID_EXE,//5-bit [4:0] //for dataHazard
    input wire [`RegAddrBus] Rd_Addr2_i_ID_EXE,//5-bit [4:0] //for dataHazard
    input wire [`RegDataBus] Rd_Data1_i_ID_EXE,
    input wire [`RegDataBus] Rd_Data2_i_ID_EXE,
//to EXE for passing
    output reg regWrite_o_ID_EXE,
    output reg [`ALUOpBus] ALUOp_o_ID_EXE,
    output reg [`InstrBus] immSignExtend_o_ID_EXE,//31:0
    // for dataHazard
    output reg [`RegDataBus] Rd_Data1_o_ID_EXE,
    output reg [`RegDataBus] Rd_Data2_o_ID_EXE,
    output reg [`RegAddrBus] Rd_Addr1_o_ID_EXE,//5-bit [4:0] //for dataHazard
    output reg [`RegAddrBus] Rd_Addr2_o_ID_EXE //5-bit [4:0] //for dataHazard

);
    always @(posedge clk_i_ID_EXE) begin
        if(rst_i_ID_EXE == `RstEnable) begin
            regWrite_o_ID_EXE <= `WrtDisable;
            ALUOp_o_ID_EXE <= `ZeroALUOp;
            Rd_Data1_o_ID_EXE <= `ZeroRegData;
            Rd_Data2_o_ID_EXE <= `ZeroRegData;
            immSignExtend_o_ID_EXE <= `ZeroWord;
            Rd_Addr1_o_ID_EXE <= `ZeroRegAddr;
            Rd_Addr2_o_ID_EXE <= `ZeroRegAddr;
        end
        else begin //rst_i == `RstDisable
            regWrite_o_ID_EXE <= regWrite_i_ID_EXE;
            ALUOp_o_ID_EXE <= ALUOp_i_ID_EXE;
            Rd_Data1_o_ID_EXE <= Rd_Data1_i_ID_EXE;
            Rd_Data2_o_ID_EXE <= Rd_Data2_i_ID_EXE;
            immSignExtend_o_ID_EXE <= immSignExtend_i_ID_EXE;
            Rd_Addr1_o_ID_EXE <= Rd_Addr1_o_ID_EXE;
            Rd_Addr2_o_ID_EXE <= Rd_Addr2_o_ID_EXE;
        
        end
    end
    
endmodule