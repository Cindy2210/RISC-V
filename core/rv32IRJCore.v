`include "define.v"
module rv32IRJCore(
//for debug!
    output wire [`InstrAddrBus] debug_IFID_pcAddr,
    output wire [`InstrBus] debug_IFID_instr, 

    output wire debug_IDEXE_regWrite, 
    output wire [`ALUOpBus] debug_IDEXE_ALUOp, 
    output wire [`InstrBus] debug_IDEXE_imm32, 
    output wire [`RegAddrBus] debug_IDEXE_Addr1, 
    output wire [`RegAddrBus] debug_IDEXE_Addr2, 
    output wire [`RegDataBus] debug_IDEXE_Data1, 
    output wire [`RegDataBus] debug_IDEXE_Data2, 

    output wire [`RegDataBus] debug_EXEMEM_WrtData, 
    output wire [`RegAddrBus] debug_EXEMEM_WrtAddr, 
    output wire debug_EXEMEM_WrtEn, 
    output wire [`RegAddrBus] debug_EXEMEM_Addr1, 
    output wire [`RegAddrBus] debug_EXEMEM_Addr2, 
    output wire [`RegDataBus] debug_EXEMEM_Data1, 
    output wire [`RegDataBus] debug_EXEMEM_Data2, 

    output wire [`RegDataBus] debug_MEMWB_WrtData, 
    output wire [`RegAddrBus] debug_MEMWB_WrtAddr, 
    output wire debug_MEMWB_WrtEn,
    output wire [`RegAddrBus] debug_MEMWB_Addr1, 
    output wire [`RegAddrBus] debug_MEMWB_Addr2, 
    output wire [`RegDataBus] debug_MEMWB_Data1, 
    output wire [`RegDataBus] debug_MEMWB_Data2,

    output wire [`RegDataBus] debug_WB_WrtData, 
    output wire [`RegAddrBus] debug_WB_WrtAddr, 
    output wire debug_WB_WrtEn, 

//debug end
    input wire reset_i_core,
    input wire clk_i_core
);


// wire between PC_ ROM
wire [`InstrAddrBus] oPC_Addr_iROM;//31:0 // to Instru_Fetch
wire oPC_chipEn_iROM;
// PC_
    PC_ PC_0(
        .reset_i_PC(reset_i_core),
        .clk_i_PC(clk_i_core),
        .pc_addr_o_PC(oPC_Addr_iROM),
        .chip_enable_o_PC(oPC_chipEn_iROM)


    );

// wire between ROM IF_ID
wire [`InstrBus] oROM_instr_iIFID;
wire [`InstrAddrBus] oROM_pcAddr_iIFID;

// ROM_InstrMem
    ROM_InstrMem ROM_InstrMem0(
        .pc_addr_i_ROM(oPC_Addr_iROM),
        .chip_enable_i_ROM(oPC_chipEn_iROM),
        .instr_o_IFID(oROM_instr_iIFID),
        .pc_addr_o_IFID(oROM_pcAddr_iIFID)
    );

// wire between IFID and Decode
wire [`InstrBus] oIFID_instr_iDecode;
wire [`InstrAddrBus] oIFID_pcAddr_iDecode;
//IF_ID
    IF_ID IF_ID0(
        //In
        .rst_i_IFID(reset_i_core), .clk_i_IFID(clk_i_core),
    //In from ROM
        .instr_i_IFID(oROM_instr_iIFID), .pc_addr_i_IFID(oROM_pcAddr_iIFID),
    //Out to Decode
        .instr_o_IFID(oIFID_instr_iDecode), .pc_addr_o_IFID(oIFID_pcAddr_iDecode)
    );

// wire between Decode and ID_EXE
wire [`InstrBus] oDecode_instr_iID_EXE; //31:0
wire [`InstrAddrBus] oDecode_pc_addr_iID_EXE;//31:0//passing to ID_EXE
wire [`ALUOpBus] oDecode_ALUop_iID_EXE;
wire oDecode_WrEn_iID_EXE; 
wire [`InstrBus] oDecode_imm32_iID_EXE;
wire [`RegAddrBus] oDecode_Instr1_iID_EXE; 
wire [`RegAddrBus] oDecode_Instr2_iID_EXE; 
wire [`RegDataBus] oDecode_Data1_iID_EXE; 
wire [`RegDataBus] oDecode_Data2_iID_EXE;

// for DataHazard input to RegFile
// from WB
wire oWrEn_iDecode; 
wire [`RegAddrBus] oWrAddr_iDecode; 
wire [`RegDataBus] oWrData_iDecode; 
// from EXE
    //to RegFile for dataHazard
    //and to EXE_MEM for passing
wire [`RegDataBus] oEXEData1_iEXE_MEM_iRegDecode;
wire [`RegDataBus] oEXEData2_iEXE_MEM_iRegDecode;
wire [`RegAddrBus] oEXEAddr1_iEXE_MEM_iRegDecode;//5-bit [4:0]
wire [`RegAddrBus] oEXEAddr2_iEXE_MEM_iRegDecode;//5-bit [4:0]
// from MEM 
    //to RegFile for dataHazard
    //and to MEM_WB for passing
wire [`RegAddrBus] oMemAddr1_iMEM_WB_iRegDecode;
wire [`RegDataBus] oMemData1_iMEM_WB_iRegDecode; 
wire [`RegAddrBus] oMemAddr2_iMEM_WB_iRegDecode;
wire [`RegDataBus] oMemData2_iMEM_WB_iRegDecode;

//Decode
    Decode Decode0(
// from IFID 
        .instr_i_Decode(oIFID_instr_iDecode), .pc_addr_i_Decode(oIFID_pcAddr_iDecode),
// from testbanch(outside)
        .rst_i_Decode(reset_i_core), .clk_i_Decode(clk_i_core),
// to ID_EXE
        .instr_o_Decode(oDecode_instr_iID_EXE), .pc_addr_o_Decode(oDecode_pc_addr_iID_EXE),
        .ALUop_o_Decode(oDecode_ALUop_iID_EXE), .WrEn_o_Decode(oDecode_WrEn_iID_EXE),
        .imm32_o_Decode(oDecode_imm32_iID_EXE),
        .Instr1_o_Decode(oDecode_Instr1_iID_EXE), .Instr2_o_Decode(oDecode_Instr2_iID_EXE),
        .Data1_o_Decode(oDecode_Data1_iID_EXE), .Data2_o_Decode(oDecode_Data2_iID_EXE),
// for DataHazard input to RegFile
// from WB
        .WrEn_i_Decode(oWrEn_iDecode),
        .WrAddr_i_Decode(oWrAddr_iDecode), .WrData_i_Decode(oWrData_iDecode),
// from EXE
        .ExeAddr1_i_Decode(oEXEAddr1_iEXE_MEM_iRegDecode), .ExeData1_i_Decode(oEXEData1_iEXE_MEM_iRegDecode),
        .ExeAddr2_i_Decode(oEXEAddr2_iEXE_MEM_iRegDecode), .ExeData2_i_Decode(oEXEData2_iEXE_MEM_iRegDecode),
// feom MEM 
        .MemAddr1_i_Decode(oMemAddr1_iMEM_WB_iRegDecode), .MemData1_i_Decode(oMemData1_iMEM_WB_iRegDecode),
        .MemAddr2_i_Decode(oMemAddr2_iMEM_WB_iRegDecode), .MemData2_i_Decode(oMemData2_iMEM_WB_iRegDecode)
    );
//from ID_EXE to EXE
wire oID_EXE_WrEn_iEXE;
wire [`ALUOpBus] oID_EXE_ALUOp_iEXE;
wire [`InstrBus] oID_EXE_imm32_iEXE;//31:0
    // for dataHazard
wire [`RegDataBus] oID_EXE_Data1_iEXE;
wire [`RegDataBus] oID_EXE_Data2_iEXE;
wire [`RegAddrBus] oID_EXE_Addr1_iEXE;//5-bit [4:0] //for dataHazard
wire [`RegAddrBus] oID_EXE_Addr2_iEXE;//5-bit [4:0] //for dataHazard
//ID_EXE
    ID_EXE ID_EXE0(
        .rst_i_ID_EXE(reset_i_core), .clk_i_ID_EXE(clk_i_core),
//In from Decode
        .instr_i_ID_EXE(oDecode_instr_iID_EXE), .pc_addr_i_ID_EXE(oDecode_pc_addr_iID_EXE),
        .ALUOp_i_ID_EXE(oDecode_ALUop_iID_EXE), .regWrite_i_ID_EXE(oDecode_WrEn_iID_EXE),
        .immSignExtend_i_ID_EXE(oDecode_imm32_iID_EXE),
        .Rd_Addr1_i_ID_EXE(oDecode_Instr1_iID_EXE), .Rd_Addr2_i_ID_EXE(oDecode_Instr2_iID_EXE),
        .Rd_Data1_i_ID_EXE(oDecode_Data1_iID_EXE), .Rd_Data2_i_ID_EXE(oDecode_Data2_iID_EXE),
//Out to EXE
        .regWrite_o_ID_EXE(oID_EXE_WrEn_iEXE), .ALUOp_o_ID_EXE(oID_EXE_ALUOp_iEXE),
        .immSignExtend_o_ID_EXE(oID_EXE_imm32_iEXE),
        .Rd_Data1_o_ID_EXE(oID_EXE_Data1_iEXE), .Rd_Data2_o_ID_EXE(oID_EXE_Data2_iEXE),
        .Rd_Addr1_o_ID_EXE(oID_EXE_Addr1_iEXE), .Rd_Addr2_o_ID_EXE(oID_EXE_Addr2_iEXE)
    );

// from EXE to EXE_MEM
wire [`RegDataBus] oEXE_WtData_iEXE_MEM;
wire [`RegAddrBus] oEXE_WtAddr_iEXE_MEM;
wire oEXE_WtEn_iEXE_MEM;

//EXE
    EXE EXE0(
//In
    .rst_i_EXE(reset_i_core), 
//In from  ID_EXE
    .regWrite_i_EXE(oID_EXE_WrEn_iEXE), .ALUOp_i_EXE(oID_EXE_ALUOp_iEXE), 
    .immSignExtend_i_EXE(oID_EXE_imm32_iEXE), 
    // passing for dataHazard
    .Rd_Data1_i_EXE(oID_EXE_Data1_iEXE), .Rd_Data2_i_EXE(oID_EXE_Data2_iEXE), 
    .Rd_Addr1_i_EXE(oID_EXE_Addr1_iEXE), .Rd_Addr2_i_EXE(oID_EXE_Addr2_iEXE), 

//Out to EXE_MEM
    .Wt_Data_o_EXE(oEXE_WtData_iEXE_MEM), .Wt_Addr_o_EXE(oEXE_WtAddr_iEXE_MEM), 
    .Wt_Enable_o_EXE(oEXE_WtEn_iEXE_MEM), 
    // passing for dataHazard 
    .Rd_Data1_o_EXE(oEXEData1_iEXE_MEM_iRegDecode), .Rd_Data2_o_EXE(oEXEData2_iEXE_MEM_iRegDecode), 
    .Rd_Addr1_o_EXE(oEXEAddr1_iEXE_MEM_iRegDecode), .Rd_Addr2_o_EXE(oEXEAddr2_iEXE_MEM_iRegDecode)

    );

//EXE_MEM
    EXE_MEM EXE_MEM0(
//In
    .rst_i_EXE_MEM(reset_i_core),
    .clk_i_EXE_MEM(clk_i_core),
// from EXE
    .Wt_Data_i_EXE_MEM(oEXE_WtData_iEXE_MEM), .Wt_Addr_i_EXE_MEM(oEXE_WtAddr_iEXE_MEM),
    .Wt_Enable_i_EXE_MEM(oEXE_WtEn_iEXE_MEM),
    // passing for dataHazard
    .Rd_Data1_i_EXE_MEM(oEXEData1_iEXE_MEM_iRegDecode), .Rd_Data2_i_EXE_MEM(oEXEData2_iEXE_MEM_iRegDecode),
    .Rd_Addr1_i_EXE_MEM(oEXEAddr1_iEXE_MEM_iRegDecode), .Rd_Addr2_i_EXE_MEM(oEXEAddr2_iEXE_MEM_iRegDecode),

//Out
// to MEM
    .Wt_Data_o_EXE_MEM(oEXE_MEM_WtData_iMEM), .Wt_Addr_o_EXE_MEM(oEXE_MEM_WtAddr_iMEM),
    .Wt_Enable_o_EXE_MEM(oEXE_MEM_WtEn_iMEM),
    // passing for dataHazard
    .Rd_Data1_o_EXE_MEM(oEXE_MEM_Data1_iMEM), .Rd_Addr1_o_EXE_MEM(oEXE_MEM_Addr1_iMEM),
    .Rd_Data2_o_EXE_MEM(oEXE_MEM_Data2_iMEM), .Rd_Addr2_o_EXE_MEM(oEXE_MEM_Addr2_iMEM)

    );

//from EXE_MEM to MEM_WB
wire [`RegDataBus] oEXE_MEM_WtData_iMEM;
wire [`RegAddrBus] oEXE_MEM_WtAddr_iMEM;
wire oEXE_MEM_WtEn_iMEM;
wire [`RegDataBus] oEXE_MEM_Data1_iMEM;
wire [`RegDataBus] oEXE_MEM_Data2_iMEM;
wire [`RegAddrBus] oEXE_MEM_Addr1_iMEM;//5-bit [4:0] //for dataHazard
wire [`RegAddrBus] oEXE_MEM_Addr2_iMEM;//5-bit [4:0] //for dataHazard

//MEM
    MEM MEM0(
//In
    .rst_i_MEM(reset_i_core),
//In from EXE_MEM
    .Wt_Data_i_MEM(oEXE_MEM_WtData_iMEM), .Wt_Addr_i_MEM(oEXE_MEM_WtAddr_iMEM),
    .Wt_Enable_i_MEM(oEXE_MEM_WtEn_iMEM),
//Out to MEM_WB
    .Wt_Data_o_MEM(oMEM_WtData_iMEM_WB),
    .Wt_Addr_o_MEM(oMEM_WtAddr_iMEM_WB),
    .Wt_Enable_o_MEM(oMEM_WtEn_iMEM_WB),

// passing for DataHazard
//In from EXE_MEM
    .Rd_Data1_i_MEM(oEXE_MEM_Data1_iMEM), .Rd_Data2_i_MEM(oEXE_MEM_Data2_iMEM),
    .Rd_Addr1_i_MEM(oEXE_MEM_Addr1_iMEM), .Rd_Addr2_i_MEM(oEXE_MEM_Addr2_iMEM),
//Out to RegDecode
    .Rd_Data1_o_MEM(oMemData1_iMEM_WB_iRegDecode),
    .Rd_Addr1_o_MEM(oMemAddr1_iMEM_WB_iRegDecode),
    .Rd_Data2_o_MEM(oMemData2_iMEM_WB_iRegDecode),
    .Rd_Addr2_o_MEM(oMemAddr2_iMEM_WB_iRegDecode)

    );
//from MEM to MEM_WB
wire [`RegDataBus] oMEM_WtData_iMEM_WB;
wire [`RegAddrBus] oMEM_WtAddr_iMEM_WB;
wire oMEM_WtEn_iMEM_WB;

//MEM_WB
    MEM_WB MEM_WB0(
//In
    .rst_i_MEM_WB(reset_i_core),
    .clk_i_MEM_WB(clk_i_core),
//In from MEM
    .Wt_Data_i_MEM_WB(oMEM_WtData_iMEM_WB),
    .Wt_Addr_i_MEM_WB(oMEM_WtAddr_iMEM_WB),
    .Wt_Enable_i_MEM_WB(oMEM_WtEn_iMEM_WB),
//Out to WB
    .Wt_Data_o_MEM_WB(oMEM_WB_WtData_iWB),
    .Wt_Addr_o_MEM_WB(oMEM_WB_WtAddr_iWB),
    .Wt_Enable_o_MEM_WB(oMEM_WB_WtEn_iWB),

// passing for dataHazard
//In from MEM
    .Rd_Data1_i_MEM_WB(oMemData1_iMEM_WB_iRegDecode),
    .Rd_Data2_i_MEM_WB(oMemData2_iMEM_WB_iRegDecode),
    .Rd_Addr1_i_MEM_WB(oMemAddr1_iMEM_WB_iRegDecode),
    .Rd_Addr2_i_MEM_WB(oMemAddr2_iMEM_WB_iRegDecode)
    
    );
//from MEM_WB to WB
wire [`RegDataBus] oMEM_WB_WtData_iWB;
wire [`RegAddrBus] oMEM_WB_WtAddr_iWB;
wire oMEM_WB_WtEn_iWB;

    WB WB0(
    .rst_i_WB(reset_i_core),
// from MEM_WB
    .Wt_Data_i_WB(oMEM_WB_WtData_iWB),
    .Wt_Addr_i_WB(oMEM_WB_WtAddr_iWB),
    .Wt_Enable_i_WB(oMEM_WB_WtEn_iWB),
// to Decode==Regfile
    .Wt_Data_o_WB(oWrData_iDecode),
    .Wt_Addr_o_WB(oWrAddr_iDecode),
    .Wt_Enable_o_WB(oWrEn_iDecode)
    
    );

assign debug_IFID_pcAddr = oIFID_pcAddr_iDecode;
assign debug_IFID_instr = oIFID_instr_iDecode;


assign debug_IDEXE_regWrite = oID_EXE_WrEn_iEXE;
assign debug_IDEXE_ALUOp = oID_EXE_ALUOp_iEXE;
assign debug_IDEXE_imm32 = oDecode_imm32_iID_EXE;
assign debug_IDEXE_Addr1 = oDecode_Instr1_iID_EXE;
assign debug_IDEXE_Addr2 = oDecode_Instr2_iID_EXE;
assign debug_IDEXE_Data1 = oDecode_Data1_iID_EXE;
assign debug_IDEXE_Data2 = oDecode_Data2_iID_EXE;
 
assign debug_EXEMEM_WrtData = oEXE_WtData_iEXE_MEM;
assign debug_EXEMEM_WrtAddr = oEXE_WtAddr_iEXE_MEM;
assign debug_EXEMEM_WrtEn = oEXE_WtEn_iEXE_MEM;
assign debug_EXEMEM_Addr1 = oEXEAddr1_iEXE_MEM_iRegDecode;
assign debug_EXEMEM_Addr2 = oEXEAddr2_iEXE_MEM_iRegDecode;
assign debug_EXEMEM_Data1 = oEXEData1_iEXE_MEM_iRegDecode;
assign debug_EXEMEM_Data2 = oEXEData2_iEXE_MEM_iRegDecode;
 
assign debug_MEMWB_WrtData = oMEM_WtData_iMEM_WB;
assign debug_MEMWB_WrtAddr = oMEM_WtAddr_iMEM_WB;
assign debug_MEMWB_WrtEn = oMEM_WtEn_iMEM_WB;
assign debug_MEMWB_Addr1 = oMemAddr1_iMEM_WB_iRegDecode;
assign debug_MEMWB_Addr2 = oMemAddr2_iMEM_WB_iRegDecode;
assign debug_MEMWB_Data1 = oMemData1_iMEM_WB_iRegDecode;
assign debug_MEMWB_Data2 = oMemData2_iMEM_WB_iRegDecode;
 
assign debug_WB_WrtData = oMEM_WB_WtData_iWB;
assign debug_WB_WrtAddr = oMEM_WB_WtAddr_iWB;
assign debug_WB_WrtEn =  oMEM_WB_WtEn_iWB;
endmodule