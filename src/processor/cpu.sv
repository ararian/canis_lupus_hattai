import defs::*;

module rv_cpu(
    input logic CLK, 
    input logic RST
    );

    //レジスタ
    reg[31:0] pc_reg;
    reg[31:0][31:0] general_reg;
    assign general_reg = '0;

    //命令コード
    reg[31:0] inst;

    //デコード命令
    logic[6:0] opcode;
    logic[4:0] rd;
    logic[4:0] rs1;
    logic[4:0] rs2;
    logic[2:0] funct3;
    logic[7:0] funct7;
    logic[20:0] imm;


    always_ff @(posedge CLK)begin
        if (RST) begin
            pc_reg <= 32'h0;
        end else begin
            pc_reg <= pc_reg + 32'h4;
        end
    end

    fetcher fetcher(.addr(pc_reg), .inst(inst));
    decoder decoder(.inst(inst), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));


endmodule
