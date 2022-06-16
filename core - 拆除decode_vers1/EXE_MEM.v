module EXE_MEM(
    
    input wire rst_i_EXE_MEM,
    input wire clk_i_EXE_MEM,
// from EXE
    input wire [`RegDataBus] Wt_Data_i_EXE_MEM,
    input wire [`RegAddrBus] Wt_Addr_i_EXE_MEM,
    input wire Wt_Enable_i_EXE_MEM,
// to MEM_WB
    output reg [`RegDataBus] Wt_Data_o_EXE_MEM,
    output reg [`RegAddrBus] Wt_Addr_o_EXE_MEM,
    output reg Wt_Enable_o_EXE_MEM,

// passing for dataHazard from EXE to MEM_WB
    input wire [`RegDataBus] Rd_Data1_i_EXE_MEM,
    input wire [`RegDataBus] Rd_Data2_i_EXE_MEM,
    input wire [`RegAddrBus] Rd_Addr1_i_EXE_MEM,//5-bit [4:0]
    input wire [`RegAddrBus] Rd_Addr2_i_EXE_MEM,//5-bit [4:0]

    output reg [`RegDataBus] Rd_Data1_o_EXE_MEM,
    output reg [`RegDataBus] Rd_Data2_o_EXE_MEM,
    output reg [`RegAddrBus] Rd_Addr1_o_EXE_MEM,//5-bit [4:0]
    output reg [`RegAddrBus] Rd_Addr2_o_EXE_MEM //5-bit [4:0]
);
    
    always @(posedge clk_i_EXE_MEM) begin
        if( rst_i_EXE_MEM == `RstEnable) begin
            Wt_Data_o_EXE_MEM <= `ZeroRegData;
            Wt_Addr_o_EXE_MEM <= `ZeroRegAddr;
            Wt_Enable_o_EXE_MEM <= `WrtDisable;   
            Rd_Data1_o_EXE_MEM <= `ZeroRegData;
            Rd_Data2_o_EXE_MEM <= `ZeroRegData;
            Rd_Addr1_o_EXE_MEM <= `ZeroRegAddr;
            Rd_Addr2_o_EXE_MEM <= `ZeroRegAddr;
        end
        else begin
            Wt_Data_o_EXE_MEM <= Wt_Data_i_EXE_MEM;
            Wt_Addr_o_EXE_MEM <= Wt_Addr_i_EXE_MEM;
            Wt_Enable_o_EXE_MEM <= Wt_Enable_i_EXE_MEM;   
            Rd_Data1_o_EXE_MEM <= Rd_Data1_i_EXE_MEM;
            Rd_Data2_o_EXE_MEM <= Rd_Data2_i_EXE_MEM;
            Rd_Addr1_o_EXE_MEM <= Rd_Addr1_i_EXE_MEM;
            Rd_Addr2_o_EXE_MEM <= Rd_Addr2_i_EXE_MEM;
        end
    end
endmodule