`include "define.v"
//`include "ControlUnit.v"
module Decode(
// from IFID 
    input wire [`InstrBus] instr_i_Decode, //31:0 //input to ID
    input wire [`InstrAddrBus] pc_addr_i_Decode, //31:0//passing to ID_EXE
// from testbanch(outside)
    input wire rst_i_Decode,
    input wire clk_i_Decode,
// to ID_EXE
    output wire [`InstrBus] instr_o_Decode, //31:0
    output wire [`InstrAddrBus] pc_addr_o_Decode,//31:0//passing to ID_EXE
    
    output wire [`ALUOpBus] ALUop_o_Decode,
    output wire WrEn_o_Decode, 

    output wire [`InstrBus] imm32_o_Decode, 
    output wire [`RegAddrBus] Instr1_o_Decode, 
    output wire [`RegAddrBus] Instr2_o_Decode, 
    output wire [`RegDataBus] Data1_o_Decode, 
    output wire [`RegDataBus] Data2_o_Decode, 

// for DataHazard input to RegFile
// from WB
    input wire WrEn_i_Decode, 
    input wire [`RegAddrBus] WrAddr_i_Decode, 
    input wire [`RegDataBus] WrData_i_Decode, 
// from EXE
    input wire [`RegAddrBus] ExeAddr1_i_Decode,
    input wire [`RegDataBus] ExeData1_i_Decode,  
    input wire [`RegAddrBus] ExeAddr2_i_Decode, 
    input wire [`RegDataBus] ExeData2_i_Decode, 
// feom MEM 
    input wire [`RegAddrBus] MemAddr1_i_Decode,
    input wire [`RegDataBus] MemData1_i_Decode, 
    input wire [`RegAddrBus] MemAddr2_i_Decode,
    input wire [`RegDataBus] MemData2_i_Decode 
);

wire [`OpcodeBus] oID_OpCode_iControl;
wire [`func3Bus] oID_func3_iControl;
wire [`func7Bus] oID_func7_iControl;

wire oID_RdEn1_iRegFile;
wire oID_RdEn2_iRegFile;
wire [`RegAddrBus] oID_RdAddr1_iRegFile;
wire [`RegAddrBus] oID_RdAddr2_iRegFile;
wire [`InstrBus] oID_immSignExtend_Decode;

assign imm32_o_Decode = oID_immSignExtend_Decode;

    ID ID0(
    //in
        .rst_i_ID(rst_i_Decode),
        .instr_i_ID(instr_i_Decode), .pc_addr_i_ID(pc_addr_i_Decode),
    //out to Control Unit 
        .OpCode_o_ID(oID_OpCode_iControl),
        .func3_o_ID(oID_func3_iControl),
        .func7_o_ID(oID_func7_iControl),
    //out to RegFile
        .RdEn_1_o_ID(oID_RdEn1_iRegFile), .RdEn_2_o_ID(oID_RdEn2_iRegFile),
        .Rd_Addr1_o_ID(oID_RdAddr1_iRegFile), .Rd_Addr2_o_ID(oID_RdAddr2_iRegFile), 
        .immSignExtend_o_ID(oID_immSignExtend_Decode)

    );

    ControlUnit ControlUnit0(
    //in
        .rst_i_Control(rst_i_Decode),
    //in from ID
        .OpCode_i_Control(oID_OpCode_iControl),
        .func3_i_Control(oID_func3_iControl),
        .func7_i_Control(oID_func7_iControl),
    //out to Decode/ID_EXE
        .regWrite_o_Control(WrEn_o_Decode),
        .ALUOp_o_Control(ALUop_o_Decode)       

    );

    RegsFile RegsFile0(
    //in
        .Rst_i_RegFile(rst_i_Decode),
        .clk_i_RegFile(clk_i_Decode),
//in from ID
        .RdEn_1_i_RegFile(oID_RdEn1_iRegFile), .RdEn_2_i_RegFile(oID_RdEn2_iRegFile),
        .Rd_Addr1_i_RegFile(oID_RdAddr1_iRegFile), .Rd_Addr2_i_RegFile(oID_RdAddr2_iRegFile),
//out to Decode/ID_EXE
        .Rd_Addr1_o_RegFile(Instr1_o_Decode),
        .Rd_Addr2_o_RegFile(Instr2_o_Decode),
        .Rd_Data1_o_RegFile(Data1_o_Decode),
        .Rd_Data2_o_RegFile(Data2_o_Decode),
//in from WB for dataHazard
        .WrtEn_i_RegFile(WrEn_i_Decode),
        .Wrt_Addr_i_RegFile(WrAddr_i_Decode),
        .Wrt_Data_i_RegFile(WrData_i_Decode),
//in from EXE for dataHazard        
        .from_EXE_Addr1_i_RegFile(ExeAddr1_i_Decode),
        .from_EXE_Data1_i_RegFile(ExeData1_i_Decode),
        .from_EXE_Addr2_i_RegFile(ExeAddr2_i_Decode),
        .from_EXE_Data2_i_RegFile(ExeData2_i_Decode),
//in from MEM for dataHazard
        .from_MEM_Addr1_i_RegFile(MemAddr1_i_Decode),
        .from_MEM_Data1_i_RegFile(MemData1_i_Decode),
        .from_MEM_Addr2_i_RegFile(MemAddr2_i_Decode),
        .from_MEM_Data2_i_RegFile(MemData2_i_Decode)

    );

endmodule