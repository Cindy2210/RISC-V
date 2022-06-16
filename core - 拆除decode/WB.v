module WB(
    input wire rst_i_WB,
// from EXE_MEM
    input wire [`RegDataBus] Wt_Data_i_WB,
    input wire [`RegAddrBus] Wt_Addr_i_WB,
    input wire Wt_Enable_i_WB,
// to Regfile
    output reg [`RegDataBus] Wt_Data_o_WB,//32bits
    output reg [`RegAddrBus] Wt_Addr_o_WB,//5-bit [4:0]
    output reg Wt_Enable_o_WB

);
    
    always @(*) begin
        if(rst_i_WB == `RstEnable) begin
            Wt_Data_o_WB <= `ZeroRegData;
            Wt_Addr_o_WB <= `ZeroRegAddr;
            Wt_Enable_o_WB <= `WrtDisable;   
        end
        else begin
            Wt_Data_o_WB <= Wt_Data_i_WB;
            Wt_Addr_o_WB <= Wt_Addr_i_WB;
            Wt_Enable_o_WB <= Wt_Enable_i_WB;   
        end
    end
endmodule