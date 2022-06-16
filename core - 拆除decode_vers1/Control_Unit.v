`include "define.v"
module Control_Unit(
// from testCore
    input wire clk_i_Control,
    input wire rst_i_Control,
//from ID
    input wire [`InstrBus] instr_i_Control,
    input wire [`OpcodeBus] OpCode_i_Control,//4:0
    input wire [`func3Bus] func3_i_Control,
    input wire [`func7Bus] func7_i_Control,
    
    //to IF_ID
    output reg [`InstrBus] instr_o_Control,
    
    //to ID_EXE - EXE_MEM - MEM_WB ->regfile
    output reg regWrite_o_Control,
    //to ID_EXE - EXE
    output reg [`ALUOpBus] ALUOp_o_Control
);


    always @(posedge clk_i_Control) begin
        if(rst_i_Control == `RstEnable) begin
            regWrite_o_Control <= `WrtDisable;
            ALUOp_o_Control <= `ZeroALUOp;
            instr_o_Control <= `ZeroRegAddr;
            //$display("Zero!");
        end 
        else begin
            instr_o_Control <= instr_i_Control;
            //$display("pass instr_o_Control");
            //$display("!!!`I_Type:begin!!!OpCode_i_Control:%b", OpCode_i_Control);
            case(OpCode_i_Control)
            `I_Type:
            begin
            //$display("!!!`I_Type:begin!!!OpCode_i_Control:%b", OpCode_i_Control);
                case(func3_i_Control)
                `func3_ANDI: 
                begin 
                    ALUOp_o_Control <= `ANDI;
                    regWrite_o_Control <= `WrtEnable;
                end
                `func3_ORI: 
                begin 
                    ALUOp_o_Control <= `ORI;
                    regWrite_o_Control <= `WrtEnable;
                    //$display("$$$$$$$$$$$$");
                end
                `func3_XORI: 
                begin 
                    ALUOp_o_Control <= `XORI;
                    regWrite_o_Control <= `WrtEnable;
                end
                `func3_SLTI: 
                begin 
                    ALUOp_o_Control <= `SLTI;
                    regWrite_o_Control <= `WrtEnable;
                end
                `func3_SLTIU: 
                begin 
                    ALUOp_o_Control <= `SLTIU;
                    regWrite_o_Control <= `WrtEnable;
                end
                `func3_ADDI: 
                begin 
                    ALUOp_o_Control <= `ADDI;
                    regWrite_o_Control <= `WrtEnable;
                end
                `func3_SLLI: 
                begin 
                    ALUOp_o_Control <= `SLLI;
                    regWrite_o_Control <= `WrtEnable;
                end
                default: 
                begin
                    regWrite_o_Control <= `WrtDisable;
                    ALUOp_o_Control <= `ZeroALUOp;
                end
                endcase
            end
            default: 
            begin
            end
            endcase
        end
    end


endmodule