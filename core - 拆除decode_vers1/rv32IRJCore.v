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

// wire between IFID and ID
wire [`InstrBus] oIFID_instr_iID;
wire [`InstrAddrBus] oIFID_pcAddr_iID;
//IF_ID
    IF_ID IF_ID0(
        //In
        .rst_i_IFID(reset_i_core), .clk_i_IFID(clk_i_core),
    //In from ROM
        .instr_i_IFID(oROM_instr_iIFID), .pc_addr_i_IFID(oROM_pcAddr_iIFID),
    //Out to ID
        .instr_o_IFID(oIFID_instr_iID), .pc_addr_o_IFID(oIFID_pcAddr_iID)
    );

// between ID and Control
wire [`InstrBus] oID_instr_iControl;
wire [`OpcodeBus] oID_OpCode_iControl;
wire [`func3Bus] oID_func3_iControl;
wire [`func7Bus] oID_func7_iControl;

// between ID and RegsFile
wire oID_RdEn1_iRegFile;
wire oID_RdEn2_iRegFile;
wire [`RegAddrBus] oID_RdAddr1_iRegFile;
wire [`RegAddrBus] oID_RdAddr2_iRegFile;

// between ID and ID_EXE
wire [`InstrBus] oID_imm32_iID_EXE;
wire [`InstrAddrBus] oID_pcAddr_iID_EXE;



    ID ID0(
// from testCore
        .rst_i_ID(reset_i_core), .clk_i_ID(clk_i_core),
    // from IF_ID
        .instr_i_ID(oIFID_instr_iID), .pc_addr_i_ID(oIFID_pcAddr_iID),
    // to Control Unit
        .instr_o_ID(oID_instr_iControl), .OpCode_o_ID(oID_OpCode_iControl),
        .func3_o_ID(oID_func3_iControl), .func7_o_ID(oID_func7_iControl),
    // to RegFileo
        .RdEn_1_o_ID(oID_RdEn1_iRegFile), .Rd_Addr1_o_ID(oID_RdAddr1_iRegFile),
        .RdEn_2_o_ID(ID_RdEn2_iRegFile), .Rd_Addr2_o_ID(oID_RdAddr2_iRegFile),
    // to ID_EXE
        .immSignExtend_o_ID(oID_imm32_iID_EXE),
        .pc_addr_o_ID(oID_pcAddr_iID_EXE)

    );

//wire between ControlUnit and ID_EXE
wire [`InstrBus] oControl_instr_iID_EXE;
wire oControl_WtEn_iID_EXE;
wire [`ALUOpBus] oControl_ALUOp_iID_EXE;

    Control_Unit Control_Unit0(
//input from testCore
        .rst_i_Control(reset_i_core), .clk_i_Control(clk_i_core),

//input from ID
        .instr_i_Control(oID_instr_iControl), .OpCode_i_Control(oID_OpCode_iControl),
        .func3_i_Control(oID_func3_iControl), .func7_i_Control(oID_func7_iControl),

    //to ID_EXE
        .instr_o_Control(oControl_instr_iID_EXE),
    //to ID_EXE - EXE_MEM - MEM_WB ->regfile
        .regWrite_o_Control(oControl_WtEn_iID_EXE),
    //to ID_EXE - EXE
        .ALUOp_o_Control(oControl_ALUOp_iID_EXE)
    );


// for DataHazard input to RegFile

//wire between WB and RegFile
// from WB
wire oWrEn_iRegs; 
wire [`RegAddrBus] oWrAddr_iRegs; 
wire [`RegDataBus] oWrData_iRegs; 

//wire between EXE and RegFile
// from EXE
    //to RegFile for dataHazard
    //and to EXE_MEM for passing
wire [`RegDataBus] oEXEData1_iEXE_MEM_iRegs;
wire [`RegDataBus] oEXEData2_iEXE_MEM_iRegs;
wire [`RegAddrBus] oEXEAddr1_iEXE_MEM_iRegs;//5-bit [4:0]
wire [`RegAddrBus] oEXEAddr2_iEXE_MEM_iRegs;//5-bit [4:0]

//wire between MEM and RegFile
// from MEM 
    //to RegFile for dataHazard
    //and to MEM_WB for passing
wire [`RegAddrBus] oMemAddr1_iMEM_WB_iRegs;
wire [`RegDataBus] oMemData1_iMEM_WB_iRegs; 
wire [`RegAddrBus] oMemAddr2_iMEM_WB_iRegs;
wire [`RegDataBus] oMemData2_iMEM_WB_iRegs;



//wire between RegFile and ID_EXE
wire [`RegAddrBus] oRegFile_Addr1_iID_EXE;//5-bit [4:0]
wire [`RegDataBus] oRegFile_Data1_iID_EXE;//32-bit
wire [`RegAddrBus] oRegFile_Addr2_iID_EXE;//5-bit [4:0]
wire [`RegDataBus] oRegFile_Data2_iID_EXE;//32-bit

    RegsFile RegFile0(
    //input from testCore
        .Rst_i_Regs(reset_i_core),
        .clk_i_Regs(clk_i_core),
    //input from ID
        .RdEn_1_i_Regs(oID_RdEn1_iRegFile), .Rd_Addr1_i_Regs(oID_RdAddr1_iRegFile),
        .RdEn_2_i_Regs(oID_RdEn2_iRegFile), .Rd_Addr2_i_Regs(oID_RdAddr2_iRegFile),
    // Out to ID_EXE
        .Rd_Addr1_o_Regs(oRegFile_Addr1_iID_EXE),
        .Rd_Data1_o_Regs(oRegFile_Data1_iID_EXE),
        .Rd_Addr2_o_Regs(oRegFile_Addr2_iID_EXE),
        .Rd_Data2_o_Regs(oRegFile_Data2_iID_EXE),
    //input from WB
        .WrEn_i_Regs(oWrEn_iRegs),
        .WrAddr_i_Regs(oWrAddr_iRegs), .WrData_i_Regs(oWrData_iRegs),

// passing for dataHazard
    //input from EXE
        .fEXE_Addr1_i_Regs(oEXEAddr1_iEXE_MEM_iRegs),
        .fEXE_Data1_i_Regs(oEXEData1_iEXE_MEM_iRegs),
        .fEXE_Addr2_i_Regs(oEXEAddr2_iEXE_MEM_iRegs),
        .fEXE_Data2_i_Regs(oEXEData2_iEXE_MEM_iRegs),
    //input from MEM
        .fMEM_Addr1_i_Regs(oMemAddr1_iMEM_WB_iRegs),
        .fMEM_Data1_i_Regs(oMemData1_iMEM_WB_iRegs),
        .fMEM_Addr2_i_Regs(oMemAddr2_iMEM_WB_iRegs),
        .fMEM_Data2_i_Regs(oMemData2_iMEM_WB_iRegs)

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
//In from ID
        .immSignExtend_i_ID_EXE(oID_imm32_iID_EXE), .pc_addr_i_ID_EXE(oID_pcAddr_iID_EXE),
//In from ControlUnit
        .instr_i_ID_EXE(oControl_instr_iID_EXE),
        .ALUOp_i_ID_EXE(oControl_ALUOp_iID_EXE), .regWrite_i_ID_EXE(oControl_WtEn_iID_EXE),
//In from RegsFile
        .Rd_Addr1_i_ID_EXE(oRegFile_Addr1_iID_EXE), .Rd_Addr2_i_ID_EXE(oRegFile_Addr2_iID_EXE),
        .Rd_Data1_i_ID_EXE(oRegFile_Data1_iID_EXE), .Rd_Data2_i_ID_EXE(oRegFile_Data2_iID_EXE),
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
    .Rd_Data1_o_EXE(oEXEData1_iEXE_MEM_iRegs), .Rd_Data2_o_EXE(oEXEData2_iEXE_MEM_iRegs), 
    .Rd_Addr1_o_EXE(oEXEAddr1_iEXE_MEM_iRegs), .Rd_Addr2_o_EXE(oEXEAddr2_iEXE_MEM_iRegs)

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
    .Rd_Data1_i_EXE_MEM(oEXEData1_iEXE_MEM_iRegs), .Rd_Data2_i_EXE_MEM(oEXEData2_iEXE_MEM_iRegs),
    .Rd_Addr1_i_EXE_MEM(oEXEAddr1_iEXE_MEM_iRegs), .Rd_Addr2_i_EXE_MEM(oEXEAddr2_iEXE_MEM_iRegs),

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
//Out to RegsFile
    .Rd_Data1_o_MEM(oMemData1_iMEM_WB_iRegs),
    .Rd_Addr1_o_MEM(oMemAddr1_iMEM_WB_iRegs),
    .Rd_Data2_o_MEM(oMemData2_iMEM_WB_iRegs),
    .Rd_Addr2_o_MEM(oMemAddr2_iMEM_WB_iRegs)

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
    .Rd_Data1_i_MEM_WB(oMemData1_iMEM_WB_iRegs),
    .Rd_Data2_i_MEM_WB(oMemData2_iMEM_WB_iRegs),
    .Rd_Addr1_i_MEM_WB(oMemAddr1_iMEM_WB_iRegs),
    .Rd_Addr2_i_MEM_WB(oMemAddr2_iMEM_WB_iRegs)
    
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
//out to Regsfile
    .Wt_Data_o_WB(oWrData_iRegs),
    .Wt_Addr_o_WB(oWrAddr_iRegs),
    .Wt_Enable_o_WB(oWrEn_iRegs)
    
    );

assign debug_IFID_pcAddr = oROM_pcAddr_iIFID;
assign debug_IFID_instr = oROM_instr_iIFID;


assign debug_IDEXE_regWrite = oID_EXE_WrEn_iEXE;
assign debug_IDEXE_ALUOp = oID_EXE_ALUOp_iEXE;
assign debug_IDEXE_imm32 = oID_imm32_iID_EXE;
assign debug_IDEXE_Addr1 = oRegFile_Addr1_iID_EXE;
assign debug_IDEXE_Addr2 = oRegFile_Addr2_iID_EXE;
assign debug_IDEXE_Data1 = oRegFile_Data1_iID_EXE;
assign debug_IDEXE_Data2 = oRegFile_Data2_iID_EXE;

 
assign debug_EXEMEM_WrtData = oEXE_WtData_iEXE_MEM;
assign debug_EXEMEM_WrtAddr = oEXE_WtAddr_iEXE_MEM;
assign debug_EXEMEM_WrtEn = oEXE_WtEn_iEXE_MEM;
assign debug_EXEMEM_Addr1 = oEXEAddr1_iEXE_MEM_iRegs;
assign debug_EXEMEM_Addr2 = oEXEAddr2_iEXE_MEM_iRegs;
assign debug_EXEMEM_Data1 = oEXEData1_iEXE_MEM_iRegs;
assign debug_EXEMEM_Data2 =oEXEData2_iEXE_MEM_iRegs ;

 
assign debug_MEMWB_WrtData = oMEM_WtData_iMEM_WB;
assign debug_MEMWB_WrtAddr = oMEM_WtAddr_iMEM_WB;
assign debug_MEMWB_WrtEn = oMEM_WtEn_iMEM_WB;
assign debug_MEMWB_Addr1 = oMemAddr1_iMEM_WB_iRegs;
assign debug_MEMWB_Addr2 = oMemAddr2_iMEM_WB_iRegs;
assign debug_MEMWB_Data1 = oMemData1_iMEM_WB_iRegs;
assign debug_MEMWB_Data2 = oMemData2_iMEM_WB_iRegs;

 
assign debug_WB_WrtData = oWrData_iRegs;
assign debug_WB_WrtAddr = oWrAddr_iRegs;
assign debug_WB_WrtEn =  oWrEn_iRegs;
endmodule