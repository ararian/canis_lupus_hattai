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

    //インターフェースの定義
    fetchToDecode fetchToDecode(.CLK(CLK), .RST(RST));
    assign fetchToDecode.addr = pc_reg;

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

    //実行ログ確認用の配線
    assign opcode = decodeToExec.next_opcode;
    assign rd = decodeToExec.next_rd;
    assign rs1 = decodeToExec.next_rs1;
    assign rs2 = decodeToExec.next_rs2;
    assign funct3 = decodeToExec.next_funct3;
    assign funct7 = decodeToExec.next_funct7;
    assign imm = decodeToExec.next_imm;


endmodule

