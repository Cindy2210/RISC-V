`include "define.v"

module PC_(
// from testCore
    input wire reset_i_PC,
    input wire clk_i_PC,
// to PC_
    output reg [`InstrAddrBus] pc_addr_o_PC,//31:0 // to Instru_Fetch
    output reg chip_enable_o_PC
);
    reg [`InstrAddrBus] pc_addr_temp;

     always @(posedge clk_i_PC) begin 
        if( reset_i_PC == `RstEnable ) begin
            chip_enable_o_PC <= `ChipDisable;
//            $display("PC_\tchip_enable_o_PC <= `ChipDDDDisable;");
            pc_addr_o_PC <= `CpuRstAddr; // 1'd0 = 8'b00000000
            pc_addr_temp <= `CpuRstAddr;
            //$display("PC_\tChipDisable  pc_addr_o_PC:%b   pc_addr_temp:%b ", pc_addr_o_PC, pc_addr_temp);
        end
        else begin//reset_i == `RstDisable
            chip_enable_o_PC <= `ChipEnable;
//            $display("PC_\tchip_enable_o_PC <= `ChipEEEEnable;");
            pc_addr_o_PC <= pc_addr_temp;
            pc_addr_temp <= pc_addr_temp + 1;
            $display("PC_\tChipEnable  pc_addr_o_PC:%b   pc_addr_temp:%b ", pc_addr_o_PC, pc_addr_temp);
        end
    end
endmodule

/*    always @(posedge clk_i_PC) begin 
        if( reset_i_PC == `RstEnable ) begin
            chip_enable_o_PC <= `ChipDisable;
            $display("chip_enable_o_PC <= `ChipDDDDisable;");

        end
        else begin//reset_i == `RstDisable
            chip_enable_o_PC <= `ChipEnable;
            $display("chip_enable_o_PC <= `ChipEEEEnable;");
        end
    end

    always @(posedge clk_i_PC) begin 
        if( chip_enable_o_PC == `ChipDisable ) begin
            pc_addr_o_PC <= `CpuRstAddr; // 1'd0 = 8'b00000000
            pc_addr_temp <= `CpuRstAddr;
            $display("ChipDisable  pc_addr_o_PC:%b   pc_addr_temp:%b ", pc_addr_o_PC, pc_addr_temp);

        end
        else begin//chip_enable_o == `ChipEnable
            pc_addr_o_PC <= pc_addr_temp;
            pc_addr_temp <= pc_addr_temp + 1;
            $display("Enable  pc_addr_o_PC:%b   pc_addr_temp:%b ", pc_addr_o_PC, pc_addr_temp);

        end
    end
 */
