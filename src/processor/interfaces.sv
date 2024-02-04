import defs::*;

interface fetchToDecode(input logic CLK, RST);
    reg[BIN_DIG-1:0] addr;
    reg[BIN_DIG-1:0] curr_inst;
    reg[BIN_DIG-1:0] next_inst;

    modport fetch(
        input addr,
        output curr_inst
    );
    modport decode(
        input next_inst
    );
    always_ff @(posedge CLK)begin
        if(RST) begin
            next_inst <= '0;
        end else begin
            next_inst <= curr_inst;
        end
    end
endinterface

interface decodeToExec(input logic CLK, RST);
    logic[6:0] curr_opcode;
    logic[4:0] curr_rd;
    logic[4:0] curr_rs1;
    logic[4:0] curr_rs2;
    logic[2:0] curr_funct3;
    logic[7:0] curr_funct7;
    logic[20:0] curr_imm;

    logic[6:0] next_opcode;
    logic[4:0] next_rd;
    logic[4:0] next_rs1;
    logic[4:0] next_rs2;
    logic[2:0] next_funct3;
    logic[7:0] next_funct7;
    logic[20:0] next_imm;

    modport decode(
        output curr_opcode, 
        output curr_rd, 
        output curr_rs1, 
        output curr_rs2, 
        output curr_funct3, 
        output curr_funct7, 
        output curr_imm
    );
    modport exec(
        input next_opcode, 
        input next_rd, 
        input next_rs1, 
        input next_rs2, 
        input next_funct3, 
        input next_funct7, 
        input next_imm
    );
    always_ff @(posedge CLK)begin
        if(RST) begin
            next_opcode <= '0;
            next_rd <= '0;
            next_rs1 <= '0;
            next_rs2 <= '0;
            next_funct3 <= '0;
            next_funct7 <= '0;
            next_imm <= '0;
        end else begin
            next_opcode <= curr_opcode;
            next_rd <= curr_rd;
            next_rs1 <= curr_rs1;
            next_rs2 <= curr_rs2;
            next_funct3 <= curr_funct3;
            next_funct7 <= curr_funct7;
            next_imm <= curr_imm;
        end
    end
endinterface

interface execToWriteback(input CLK, RST);
    logic [BIN_DIG-1:0] next_pc_reg;
    logic [BIN_DIG-1:0] next_rd_value;
    logic[4:0] next_rd;
    
    modport exec(
        output next_pc_reg, 
        output next_rd_value, 
        output next_rd
    );
    modport writeback(
        input next_pc_reg, 
        input next_rd_value, 
        input next_rd
    );
endinterface

interface topToExec(input CLK, RST);
    logic [BIN_DIG-1:0] curr_pc_reg;
    reg[31:0][BIN_DIG-1:0] curr_general_reg;

    modport exec(
        input curr_pc_reg, 
        input curr_general_reg
    );
endinterface
