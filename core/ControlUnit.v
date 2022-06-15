`include "define.v"
module ControlUnit(
// from Decode
    input wire rst_i_Control,
//from ID
    input wire [`OpcodeBus] OpCode_i_Control,//4:0
    input wire [`func3Bus] func3_i_Control,
    input wire [`func7Bus] func7_i_Control,
    
    //to IF_ID
    //output reg [`InstrBus] instr_i_Control,
    
    //to ID_EXE - EXE_MEM - MEM_WB ->regfile
    output reg regWrite_o_Control,
    //to ID_EXE - EXE
    output reg [`ALUOpBus] ALUOp_o_Control
);

    always @(*) begin
        if (rst_i_Control == `RstEnable) begin
            regWrite_o_Control <= `WrtDisable;
            ALUOp_o_Control <= `ZeroALUOp;
        end else begin
            case (OpCode_i_Control)
            `I_Type:begin
                case (func3_i_Control)
                `func3_ANDI, `func3_ORI,`func3_XORI, `func3_SLTI, `func3_SLTIU, `func3_ADDI, `func3_SLLI: begin
                    regWrite_o_Control <= `WrtEnable;
                    case (func3_i_Control)
                    `func3_ANDI: ALUOp_o_Control <= `ANDI;
                    `func3_ORI: ALUOp_o_Control <= `ORI;
                    `func3_XORI: ALUOp_o_Control <= `XORI;
                    `func3_SLTI: ALUOp_o_Control <= `SLTI;
                    `func3_SLTIU: ALUOp_o_Control <= `SLTIU;
                    `func3_ADDI: ALUOp_o_Control <= `ADDI;
                    `func3_SLLI: ALUOp_o_Control <= `SLLI;
                    endcase
                end
                default: begin
                    regWrite_o_Control <= `WrtDisable;
                    ALUOp_o_Control <= `ZeroALUOp;
                end
                endcase
            end
            endcase
        end
    end


endmodule