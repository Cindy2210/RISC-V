module testCore();

reg reset;
reg clk;

wire [`InstrAddrBus] IFID_pcAddr;
wire [`InstrBus] IFID_instr; 

wire _IDEXE_regWrite; 
wire [`ALUOpBus] _IDEXE_ALUOp; 
wire [`InstrBus] _IDEXE_imm32; 
wire [`RegAddrBus] _IDEXE_Addr1; 
wire [`RegAddrBus] _IDEXE_Addr2; 
wire [`RegDataBus] _IDEXE_Data1; 
wire [`RegDataBus] _IDEXE_Data2; 

wire [`RegDataBus] _EXEMEM_WrtData; 
wire [`RegAddrBus] _EXEMEM_WrtAddr; 
wire _EXEMEM_WrtEn; 
wire [`RegAddrBus] _EXEMEM_Addr1; 
wire [`RegAddrBus] _EXEMEM_Addr2; 
wire [`RegDataBus] _EXEMEM_Data1; 
wire [`RegDataBus] _EXEMEM_Data2; 

wire [`RegDataBus] _MEMWB_WrtData;
wire [`RegAddrBus] _MEMWB_WrtAddr; 
wire _MEMWB_WrtEn;
wire [`RegAddrBus] _MEMWB_Addr1; 
wire [`RegAddrBus] _MEMWB_Addr2; 
wire [`RegDataBus] _MEMWB_Data1; 
wire [`RegDataBus] _MEMWB_Data2;

wire [`RegDataBus] _WB_WrtData; 
wire [`RegAddrBus] _WB_WrtAddr; 
wire _WB_WrtEn; 


always begin
    #5 clk = ~clk;
end

initial begin
    $dumpfile("debug.vcd");
    $dumpvars(1);

    $readmemb("./Rom.data", rv32IRJCore0.ROM_InstrMem0.rom);
    $readmemb("./RegFile.data", rv32IRJCore0.RegFile0.regsfile_);

    $monitor("===time:%4d   clk: %b   reset: %b===\nIFID_ pcAddr: %b   instr: %b\nIDEXE_ regWrt: %b\nALUOp: %b   imm32:%b\nAddr1: %b    Data1: %b\nAddr2: %b   Data2: %b\nEXEMEM_ WrtData: %b   WrtAddr: %b\nWrtEn: %b\nAddr1: %b   Data1: %b\nAddr2: %b   Data2: %b\nMEM_WB_ WrtData: %b   WrtAddr: %b\nWrtEn: %b\nAddr1: %b   Data1: %b\nAddr2: %b   Data2: %b\nWB_ WrtData: %b   WrtAddr: %b\nWrtEn: %b\n", $stime, clk, reset, IFID_pcAddr, IFID_instr,_IDEXE_regWrite ,_IDEXE_ALUOp ,_IDEXE_imm32 ,_IDEXE_Addr1 ,_IDEXE_Data1 ,_IDEXE_Addr2 , _IDEXE_Data2, _EXEMEM_WrtData, _EXEMEM_WrtAddr, _EXEMEM_WrtEn, _EXEMEM_Addr1, _EXEMEM_Data1, _EXEMEM_Addr2, _EXEMEM_Data2, _MEMWB_WrtData, _MEMWB_WrtAddr, _MEMWB_WrtEn, _MEMWB_Addr1, _MEMWB_Data1, _MEMWB_Addr2, _MEMWB_Data2, _WB_WrtData, _WB_WrtAddr, _WB_WrtEn);

    reset = 1;
    clk = 0;
#8  reset = 0;
end
initial begin
#120 $finish;
end

rv32IRJCore rv32IRJCore0(
    .debug_IFID_pcAddr(IFID_pcAddr) , 
    .debug_IFID_instr(IFID_instr) , 

    .debug_IDEXE_regWrite(_IDEXE_regWrite) , 
    .debug_IDEXE_ALUOp(_IDEXE_ALUOp) , 
    .debug_IDEXE_imm32(_IDEXE_imm32) , 
    .debug_IDEXE_Addr1(_IDEXE_Addr1) , 
    .debug_IDEXE_Addr2(_IDEXE_Addr2) , 
    .debug_IDEXE_Data1(_IDEXE_Data1) , 
    .debug_IDEXE_Data2(_IDEXE_Data2) , 

    .debug_EXEMEM_WrtData(_EXEMEM_WrtData) , 
    .debug_EXEMEM_WrtAddr(_EXEMEM_WrtAddr) , 
    .debug_EXEMEM_WrtEn(_EXEMEM_WrtEn) , 
    .debug_EXEMEM_Addr1(_EXEMEM_Addr1) , 
    .debug_EXEMEM_Addr2(_EXEMEM_Addr2) , 
    .debug_EXEMEM_Data1(_EXEMEM_Data1) , 
    .debug_EXEMEM_Data2(_EXEMEM_Data2) , 

    .debug_MEMWB_WrtData(_MEMWB_WrtData) , 
    .debug_MEMWB_WrtAddr(_MEMWB_WrtAddr) , 
    .debug_MEMWB_WrtEn(_MEMWB_WrtEn) , 
    .debug_MEMWB_Addr1(_MEMWB_Addr1) , 
    .debug_MEMWB_Addr2(_MEMWB_Addr2) , 
    .debug_MEMWB_Data1(_MEMWB_Data1) , 
    .debug_MEMWB_Data2(_MEMWB_Data2) , 
    .debug_WB_WrtData(_WB_WrtData) , 
    .debug_WB_WrtAddr(_WB_WrtAddr) , 
    .debug_WB_WrtEn(_WB_WrtEn) , 
    .reset_i_core(reset),
    .clk_i_core(clk)

);



endmodule