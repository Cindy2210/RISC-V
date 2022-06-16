module MEM_WB(    
    input wire rst_i_MEM_WB,
    input wire clk_i_MEM_WB,
// from EXE_MEM
    input wire [`RegDataBus] Wt_Data_i_MEM_WB,
    input wire [`RegAddrBus] Wt_Addr_i_MEM_WB,
    input wire Wt_Enable_i_MEM_WB,
// to WB
    output reg [`RegDataBus] Wt_Data_o_MEM_WB,//32bits
    output reg [`RegAddrBus] Wt_Addr_o_MEM_WB,//5-bit [4:0]
    output reg Wt_Enable_o_MEM_WB,

    // from EXE_MEM for dataHazard
    input wire [`RegDataBus] Rd_Data1_i_MEM_WB,
    input wire [`RegDataBus] Rd_Data2_i_MEM_WB,
    input wire [`RegAddrBus] Rd_Addr1_i_MEM_WB,//5-bit [4:0]
    input wire [`RegAddrBus] Rd_Addr2_i_MEM_WB//5-bit [4:0]

);
    
    always @(posedge clk_i_MEM_WB) begin
        if(rst_i_MEM_WB == `RstEnable) begin
            Wt_Data_o_MEM_WB <= `ZeroRegData;
            Wt_Addr_o_MEM_WB <= `ZeroRegAddr;
            Wt_Enable_o_MEM_WB <= `WrtDisable;  
        end
        else begin
            Wt_Data_o_MEM_WB <= Wt_Data_i_MEM_WB;
            Wt_Addr_o_MEM_WB <= Wt_Addr_i_MEM_WB;
            Wt_Enable_o_MEM_WB <= Wt_Enable_i_MEM_WB; 
        end
    end
endmodule