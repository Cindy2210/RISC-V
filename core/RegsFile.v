`include "define.v"

module RegsFile(
// from Decode
    input wire Rst_i_RegFile,
    input wire clk_i_RegFile,

//from ID
    input wire RdEn_1_i_RegFile,
    input wire [`RegAddrBus] Rd_Addr1_i_RegFile,//5-bit [4:0]
    input wire RdEn_2_i_RegFile,
    input wire [`RegAddrBus] Rd_Addr2_i_RegFile,//5-bit [4:0]

    //to ID_EXE
    output reg [`RegAddrBus] Rd_Addr1_o_RegFile,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data1_o_RegFile,//32-bit
    output reg [`RegAddrBus] Rd_Addr2_o_RegFile,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data2_o_RegFile,//32-bit

    //from WB
    input wire WrtEn_i_RegFile,
    input wire [`RegAddrBus] Wrt_Addr_i_RegFile,//5-bit [4:0]
    input wire [`RegDataBus] Wrt_Data_i_RegFile,//32bits

// for dataHazard by forwarding
    // from EXE
    input wire [`RegAddrBus] from_EXE_Addr1_i_RegFile,//5-bit [4:0]
    input wire [`RegDataBus] from_EXE_Data1_i_RegFile,//32-bit
    input wire [`RegAddrBus] from_EXE_Addr2_i_RegFile,//5-bit [4:0]
    input wire [`RegDataBus] from_EXE_Data2_i_RegFile,//32-bit
    // from MEM
    input wire [`RegAddrBus] from_MEM_Addr1_i_RegFile,//5-bit [4:0]
    input wire [`RegDataBus] from_MEM_Data1_i_RegFile,//32-bit
    input wire [`RegAddrBus] from_MEM_Addr2_i_RegFile,//5-bit [4:0]
    input wire [`RegDataBus] from_MEM_Data2_i_RegFile//32-bit
);

    reg [`RegDataBits] regsfile_ [0:`RegFileNum];

//先寫入
    always @(posedge clk_i_RegFile) begin
        if(WrtEn_i_RegFile == `WrtEnable)begin
            regsfile_[Wrt_Addr_i_RegFile] <= Wrt_Data_i_RegFile;
//            $display("Reg_\tWrt_En  regsfile_[Wrt_Addr_i_RegFile]:%b ", regsfile_[Wrt_Addr_i_RegFile]);
        end
        else begin
            regsfile_[Wrt_Addr_i_RegFile] <= regsfile_[Wrt_Addr_i_RegFile];
//            $display("Reg_\tWrt_DIS  regsfile_[Wrt_Addr_i_RegFile]:%b ", regsfile_[Wrt_Addr_i_RegFile]);
        end
    end
//再讀出
    always @(negedge clk_i_RegFile) begin
    if(Rst_i_RegFile == `RstEnable) begin
        Rd_Addr1_o_RegFile <= `ZeroRegAddr;
        Rd_Data1_o_RegFile <= `ZeroRegData;
        Rd_Addr2_o_RegFile <= `ZeroRegAddr;
        Rd_Data2_o_RegFile <= `ZeroRegData;
//        $display("Reg_\tRstEnable ");
    end
    else begin
//passing
        Rd_Addr1_o_RegFile <= Rd_Addr1_i_RegFile;
        Rd_Addr2_o_RegFile <= Rd_Addr2_i_RegFile;
//        $display("Reg_\tRd_Addr1_o_RegFile:%b   Rd_Addr2_o_RegFile:%b ", Rd_Addr1_o_RegFile, Rd_Addr2_o_RegFile);

        if( (Rd_Addr1_i_RegFile == Wrt_Addr_i_RegFile) && (WrtEn_i_RegFile == `WrtEnable) && (RdEn_1_i_RegFile == `RdEnable) ) begin
            Rd_Data1_o_RegFile <= Wrt_Data_i_RegFile;
//            $display("Reg_\tData1 WB dataHazard  Wrt_Data_i_RegFile:%b ", Rd_Data1_o_RegFile);
        end //WB dataHazard
        else if( (Rd_Addr1_i_RegFile == from_EXE_Addr1_i_RegFile) && (RdEn_1_i_RegFile == `RdEnable) ) begin
            Rd_Data1_o_RegFile <= from_EXE_Data1_i_RegFile;        
//            $display("Reg_\tData1 EXE dataHazard  from_EXE_Data1_i_RegFile:%b ", Rd_Data1_o_RegFile);
        end //EXE dataHazard
        else if( (Rd_Addr1_i_RegFile == from_MEM_Addr1_i_RegFile) && (RdEn_1_i_RegFile == `RdEnable) ) begin
            Rd_Data1_o_RegFile <= from_MEM_Data1_i_RegFile;        
//            $display("Reg_\tData1 MEM dataHazard  from_MEM_Data1_i_RegFile:%b ", Rd_Data1_o_RegFile);
        end //MEM dataHazard
        else if(RdEn_1_i_RegFile == `RdEnable)begin
            Rd_Data1_o_RegFile <= regsfile_[Rd_Addr1_i_RegFile];
//            $display("Reg_\tData1 RdEnabl  regsfile_[Rd_Addr1_i_RegFile]:%b ", Rd_Data1_o_RegFile);
        end
        else begin
            Rd_Data1_o_RegFile <= `ZeroRegData;
//            $display("Reg_\tData1 ZeroRegData:%b ", Rd_Data1_o_RegFile);
        end

        if( (Rd_Addr2_i_RegFile == Wrt_Addr_i_RegFile) && (WrtEn_i_RegFile == `WrtEnable) && (RdEn_2_i_RegFile == `RdEnable) ) begin
            Rd_Data2_o_RegFile <= Wrt_Data_i_RegFile;       
//            $display("Reg_\tData2 WB dataHazard  Wrt_Data_i_RegFile:%b ", Rd_Data2_o_RegFile);
        end //WB dataHazard
        else if( (Rd_Addr2_i_RegFile == from_EXE_Addr2_i_RegFile) && (RdEn_2_i_RegFile == `RdEnable) ) begin
            Rd_Data2_o_RegFile <= from_EXE_Data2_i_RegFile;        
//            $display("Reg_\tData2 EXE dataHazard  from_EXE_Data1_i_RegFile:%b ", Rd_Data2_o_RegFile);
        end //EXE dataHazard
        else if( (Rd_Addr2_i_RegFile == from_MEM_Addr2_i_RegFile) && (RdEn_2_i_RegFile == `RdEnable) ) begin
            Rd_Data2_o_RegFile <= from_MEM_Data2_i_RegFile;     
//            $display("Reg_\tData2 MEM dataHazard  from_MEM_Data1_i_RegFile:%b ", Rd_Data2_o_RegFile);
        end //MEM dataHazard
        else  if(RdEn_2_i_RegFile == `RdEnable)begin
            Rd_Data2_o_RegFile <= regsfile_[Rd_Addr2_i_RegFile];
//            $display("Reg_\tData2 RdEnabl  regsfile_[Rd_Addr1_i_RegFile]:%b ", Rd_Data2_o_RegFile);
        end
        else begin
            Rd_Data2_o_RegFile <= `ZeroRegData;
//            $display("Reg_\tData2 ZeroRegData:%b ", Rd_Data2_o_RegFile);
        end
    end
    end


endmodule