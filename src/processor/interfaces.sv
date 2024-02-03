interface fetchToDecode(input logic CLK, RST);
    reg[31:0] addr;
    reg[31:0] curr_inst;
    reg[31:0] next_inst;

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
