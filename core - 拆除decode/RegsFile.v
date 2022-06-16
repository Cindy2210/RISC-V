`include "define.v"

module RegsFile(
// from Decode
    input wire Rst_i_Regs,
    input wire clk_i_Regs,

//from ID
    input wire RdEn_1_i_Regs,
    input wire [`RegAddrBus] Rd_Addr1_i_Regs,//5-bit [4:0]
    input wire RdEn_2_i_Regs,
    input wire [`RegAddrBus] Rd_Addr2_i_Regs,//5-bit [4:0]

    //to ID_EXE
    output reg [`RegAddrBus] Rd_Addr1_o_Regs,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data1_o_Regs,//32-bit
    output reg [`RegAddrBus] Rd_Addr2_o_Regs,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data2_o_Regs,//32-bit

    //from WB
    input wire WrEn_i_Regs,
    input wire [`RegAddrBus] WrAddr_i_Regs,//5-bit [4:0]
    input wire [`RegDataBus] WrData_i_Regs,//32bits

// for dataHazard by forwarding
    // from EXE
    input wire [`RegAddrBus] fEXE_Addr1_i_Regs,//5-bit [4:0]
    input wire [`RegDataBus] fEXE_Data1_i_Regs,//32-bit
    input wire [`RegAddrBus] fEXE_Addr2_i_Regs,//5-bit [4:0]
    input wire [`RegDataBus] fEXE_Data2_i_Regs,//32-bit
    // from MEM
    input wire [`RegAddrBus] fMEM_Addr1_i_Regs,//5-bit [4:0]
    input wire [`RegDataBus] fMEM_Data1_i_Regs,//32-bit
    input wire [`RegAddrBus] fMEM_Addr2_i_Regs,//5-bit [4:0]
    input wire [`RegDataBus] fMEM_Data2_i_Regs//32-bit
);

    reg [`RegDataBits] regsfile_ [0:`RegFileNum-1];

//後寫入
    always @(negedge clk_i_Regs) begin
        if(WrEn_i_Regs == `WrtEnable)begin
            regsfile_[WrAddr_i_Regs] <= WrData_i_Regs;
//            $display("Reg_\tWrt_En  regsfile_[Wrt_Addr_i_Regs]:%b ", regsfile_[Wrt_Addr_i_Regs]);
        end
        else begin
            regsfile_[WrAddr_i_Regs] <= regsfile_[WrAddr_i_Regs];
//            $display("Reg_\tWrt_DIS  regsfile_[Wrt_Addr_i_Regs]:%b ", regsfile_[Wrt_Addr_i_Regs]);
        end
    end
//先讀出
    always @( posedge clk_i_Regs) begin
    if(Rst_i_Regs == `RstEnable) begin
        Rd_Addr1_o_Regs <= `ZeroRegAddr;
        Rd_Data1_o_Regs <= `ZeroRegData;
        Rd_Addr2_o_Regs <= `ZeroRegAddr;
        Rd_Data2_o_Regs <= `ZeroRegData;
//        $display("Reg_\tRstEnable ");
    end
    else begin
//passing
        Rd_Addr1_o_Regs <= Rd_Addr1_i_Regs;
        Rd_Addr2_o_Regs <= Rd_Addr2_i_Regs;
        $display("Reg_\tRd_Addr1_i_Regs:%b   Rd_Addr2_i_Regs:%b ", Rd_Addr1_i_Regs, Rd_Addr2_i_Regs);

        $display("Reg_\tRd_Addr1_o_Regs:%b   Rd_Addr2_o_Regs:%b ", Rd_Addr1_o_Regs, Rd_Addr2_o_Regs);

        if( (Rd_Addr1_i_Regs == WrAddr_i_Regs) && (WrEn_i_Regs == `WrtEnable) && (RdEn_1_i_Regs == `RdEnable) ) begin
            Rd_Data1_o_Regs <= WrData_i_Regs;
            $display("Reg_\tData1 WB dataHazard  Wrt_Data_i_Regs:%b ", Rd_Data1_o_Regs);
        end //WB dataHazard
        else if(RdEn_1_i_Regs == `RdEnable)begin
            Rd_Data1_o_Regs <= regsfile_[Rd_Addr1_i_Regs];
            $display("Reg_\tData1 RdEnabl  regsfile_[Rd_Addr1_i_Regs]:%b ", Rd_Data1_o_Regs);
        end
        else if( (Rd_Addr1_i_Regs == fEXE_Addr1_i_Regs) && (RdEn_1_i_Regs == `RdEnable) ) begin
            Rd_Data1_o_Regs <= fEXE_Data1_i_Regs;        
            $display("Reg_\tData1 EXE dataHazard  from_EXE_Data1_i_Regs:%b ", Rd_Data1_o_Regs);
        end //EXE dataHazard
        else if( (Rd_Addr1_i_Regs == fMEM_Addr1_i_Regs) && (RdEn_1_i_Regs == `RdEnable) ) begin
            Rd_Data1_o_Regs <= fMEM_Data1_i_Regs;        
            $display("Reg_\tData1 MEM dataHazard  from_MEM_Data1_i_Regs:%b ", Rd_Data1_o_Regs);
        end //MEM dataHazard
        else begin
            Rd_Data1_o_Regs <= `ZeroRegData;
            $display("Reg_\tData1 ZeroRegData:%b ", Rd_Data1_o_Regs);
        end


        if( (Rd_Addr2_i_Regs == WrAddr_i_Regs) && (WrEn_i_Regs == `WrtEnable) && (RdEn_2_i_Regs == `RdEnable) ) begin
            Rd_Data2_o_Regs <= WrData_i_Regs;       
            $display("Reg_\tData2 WB dataHazard  Wrt_Data_i_Regs:%b ", Rd_Data2_o_Regs);
        end //WB dataHazard
        else  if(RdEn_2_i_Regs == `RdEnable)begin
            Rd_Data2_o_Regs <= regsfile_[Rd_Addr2_i_Regs];
            $display("Reg_\tData2 RdEnabl  regsfile_[Rd_Addr1_i_Regs]:%b ", Rd_Data2_o_Regs);
        end
        else if( (Rd_Addr2_i_Regs == fEXE_Addr2_i_Regs) && (RdEn_2_i_Regs == `RdEnable) ) begin
            Rd_Data2_o_Regs <= fEXE_Data2_i_Regs;        
            $display("Reg_\tData2 EXE dataHazard  from_EXE_Data1_i_Regs:%b ", Rd_Data2_o_Regs);
        end //EXE dataHazard
        else if( (Rd_Addr2_i_Regs == fMEM_Addr2_i_Regs) && (RdEn_2_i_Regs == `RdEnable) ) begin
            Rd_Data2_o_Regs <= fMEM_Data2_i_Regs;     
            $display("Reg_\tData2 MEM dataHazard  from_MEM_Data1_i_Regs:%b ", Rd_Data2_o_Regs);
        end //MEM dataHazard
        else begin
            Rd_Data2_o_Regs <= `ZeroRegData;
            $display("Reg_\tData2 ZeroRegData:%b ", Rd_Data2_o_Regs);
        end
    end
    end

endmodule