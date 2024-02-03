import defs::*;
// import interfaces::*;

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

    //インターフェースの定義
    fetchToDecode fetchToDecode(.CLK(CLK), .RST(RST));
    assign fetchToDecode.fetch.addr = pc_reg;

    decodeToExec decodeToExec(.CLK(CLK), .RST(RST));


    always_ff @(posedge CLK)begin
        if (RST) begin
            pc_reg <= 32'h0;
        end else begin
            pc_reg <= pc_reg + 32'h4;
        end
    end

    fetcher fetcher(.fetchToDecode(fetchToDecode.fetch));
    decoder decoder(.fetchToDecode(fetchToDecode.decode), .decodeToExec(decodeToExec.decode));

    assign opcode = decodeToExec.exec.next_opcode;
    assign rd = decodeToExec.exec.next_rd;
    assign rs1 = decodeToExec.exec.next_rs1;
    assign rs2 = decodeToExec.exec.next_rs2;
    assign funct3 = decodeToExec.exec.next_funct3;
    assign funct7 = decodeToExec.exec.next_funct7;
    assign imm = decodeToExec.exec.next_imm;



    // exec exec(.opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm), .general_reg(general_reg));

    // assign feta.fetch.addr = pc_reg;
    // fetch_test fettes(.fet(feta.fetch));
    // decode_test dectes(.dec(feta.decode), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));


endmodule

// module fetch_test(fetchToDecode.fetch fet);
// //    assign fet.fetch_inst = fet.addr;
//    fetcher fettt(.addr(fet.addr), .inst(fet.fetch_inst));
// endmodule

// module decode_test(fetchToDecode.decode dec, output logic[6:0] opcode,
// output logic[4:0] rd,
// output logic[4:0] rs1,
// output logic[4:0] rs2,
// output logic[2:0] funct3,
// output logic[7:0] funct7,
// output logic[20:0] imm);
//     // assign dec.opcode = dec.decode_inst;
//     decoder deco(.inst(dec.decode_inst), .opcode(opcode), .rd(rd), .rs1(rs1), .rs2(rs2), .funct3(funct3), .funct7(funct7), .imm(imm));
// endmodule