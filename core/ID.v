`include "define.v" 

module ID(
// from Decode
    input wire rst_i_ID,

    // from IF_ID
    input wire [`InstrBus] instr_i_ID,//instr31:0
    input wire [`InstrAddrBus] pc_addr_i_ID,//pc

    // to Control Unit
    output reg [`OpcodeBus] OpCode_o_ID,//4:0
    output reg [`func3Bus] func3_o_ID,
    output reg [`func7Bus] func7_o_ID,

    // to RegFile
    output reg RdEn_1_o_ID,
    output reg [`RegAddrBus] Rd_Addr1_o_ID,//5-bit [4:0] //to ID_EXE
    output reg RdEn_2_o_ID,
    output reg [`RegAddrBus] Rd_Addr2_o_ID,//5-bit [4:0] //to ID_EXE

    // to ID/EXE
    output reg [`InstrBus] immSignExtend_o_ID//31:0<-11:0

);

//I-type - ori, xori, andi, slti, sltiu, addi
//lb, lh, lw, lbu, lhu. jalr
    wire[`OpcodeBus] opcode = instr_i_ID[6:0];
    wire[`rdBus] rd = instr_i_ID[11:7];
    wire[`func3Bus] func3 = instr_i_ID[14:12];
    wire[`rs1Bus] rs1 = instr_i_ID[19:15];
    wire[`imm12Bus] imm12 = instr_i_ID[31:20];
//I-type - slli, srli, sral, 
    wire[`shamt_I] shamt = instr_i_ID[24:20];
    wire[`func7Bus] func7 = instr_i_ID[31:25];

//R-type - 
    wire[4:0] rs2 = instr_i_ID[24:20];
    
    always @(*) begin
        if(rst_i_ID == `RstEnable ) begin
            OpCode_o_ID <= `ZeroOpcode;
            func3_o_ID <= `Zerofunc3;
            func7_o_ID <= `Zerofunc7;
            RdEn_1_o_ID <= `RdDisable;
            RdEn_2_o_ID <= `RdDisable;
            Rd_Addr1_o_ID <= `ZeroRegAddr;//rs1
            Rd_Addr2_o_ID <= `ZeroRegAddr;//rd  
            immSignExtend_o_ID <= `ZeroWord;
        end
        else begin
            OpCode_o_ID <= opcode;
            func3_o_ID <= func3;
            func7_o_ID <= func7;
            RdEn_1_o_ID <= `RdEnable;
            RdEn_2_o_ID <= `RdEnable;
            Rd_Addr1_o_ID <= rs1;//rs1
            Rd_Addr2_o_ID <= rd;//rd
            immSignExtend_o_ID <= { {20{instr_i_ID[31]}} , instr_i_ID[11:0] };
        end
    end

endmodule