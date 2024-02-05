import defs::*;

module rv_cpu(
    input logic CLK, 
    input logic RST
    );

    //レジスタ
    reg[BIN_DIG-1:0] pc_reg;
    reg[31:0][BIN_DIG-1:0] general_reg;
    assign general_reg = '0;

    logic loac_active;

    //命令コード
    reg[BIN_DIG-1:0] inst;

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

    //インターフェースのインスタンス化
    fetchToDecode fetchToDecode(.CLK(CLK), .RST(RST));
    decodeToExecOrDmem decodeToExecOrDmem(.CLK(CLK), .RST(RST));
    execToWriteback execToWriteback(.CLK(CLK), .RST(RST));
    topToExecOrDmem topToExecOrDmem(.CLK(CLK), .RST(RST));
    dmemToWriteback dmemToWriteback(.CLK(CLK), .RST(RST));

    //インターフェースへの割り当て
    assign fetchToDecode.addr = pc_reg;
    assign topToExecOrDmem.curr_pc_reg = pc_reg;
    assign topToExecOrDmem.curr_general_reg = general_reg;

    //モジュールのインスタンス化
    fetcher fetcher(.fetchToDecode(fetchToDecode.fetch));
    decoder decoder(.fetchToDecode(fetchToDecode.decode), .decodeToExecOrDmem(decodeToExecOrDmem.decode));
    exec exec(.decodeToExecOrDmem(decodeToExecOrDmem.execOrDmem), .execToWriteback(execToWriteback.exec), .topToExecOrDmem(topToExecOrDmem.exec));
    memaccess memaccess(.decodeToExecOrDmem(decodeToExecOrDmem.execOrDmem), .topToExecOrDmem(topToExecOrDmem.dmem), .dmemToWriteback(dmemToWriteback.dmem));

    //実行ログ確認用の配線
    assign opcode = decodeToExecOrDmem.next_opcode;
    assign rd = decodeToExecOrDmem.next_rd;
    assign rs1 = decodeToExecOrDmem.next_rs1;
    assign rs2 = decodeToExecOrDmem.next_rs2;
    assign funct3 = decodeToExecOrDmem.next_funct3;
    assign funct7 = decodeToExecOrDmem.next_funct7;
    assign imm = decodeToExecOrDmem.next_imm;

endmodule

