module MEM(
    input wire rst_i_MEM,
// from EXE
    input wire [`RegDataBus] Wt_Data_i_MEM,
    input wire [`RegAddrBus] Wt_Addr_i_MEM,
    input wire Wt_Enable_i_MEM,
// to MEM_WB
    output reg [`RegDataBus] Wt_Data_o_MEM,
    output reg [`RegAddrBus] Wt_Addr_o_MEM,
    output reg Wt_Enable_o_MEM,

// from EXE for dataHazard
    input wire [`RegDataBus] Rd_Data1_i_MEM,
    input wire [`RegAddrBus] Rd_Addr1_i_MEM,//5-bit [4:0]
    input wire [`RegDataBus] Rd_Data2_i_MEM,
    input wire [`RegAddrBus] Rd_Addr2_i_MEM,//5-bit [4:0]
//to RegFile for dataHazard
//and to MEM_WB for passing
    output reg [`RegDataBus] Rd_Data1_o_MEM,
    output reg [`RegAddrBus] Rd_Addr1_o_MEM,//5-bit [4:0]
    output reg [`RegDataBus] Rd_Data2_o_MEM,
    output reg [`RegAddrBus] Rd_Addr2_o_MEM //5-bit [4:0]
);
    
    always @(*) begin
        if( rst_i_MEM == `RstEnable) begin
            Wt_Data_o_MEM <= `ZeroRegData;
            Wt_Addr_o_MEM <= `ZeroRegAddr;
            Wt_Enable_o_MEM <= `WrtDisable;
            Rd_Data1_o_MEM <= `ZeroRegData;
            Rd_Data2_o_MEM <= `ZeroRegData;
            Rd_Addr1_o_MEM <= `ZeroRegAddr;
            Rd_Addr2_o_MEM <= `ZeroRegAddr;
        end
        else begin
            Wt_Data_o_MEM <= Wt_Data_i_MEM;
            Wt_Addr_o_MEM <= Wt_Addr_i_MEM;
            Wt_Enable_o_MEM <= Wt_Enable_i_MEM;
            Rd_Data1_o_MEM <= Rd_Data1_i_MEM;
            Rd_Data2_o_MEM <= Rd_Data2_i_MEM;
            Rd_Addr1_o_MEM <= Rd_Addr1_i_MEM;
            Rd_Addr2_o_MEM <= Rd_Addr2_i_MEM;
        end
    end
endmodule