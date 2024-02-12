import defs::*;

module rv_cpu(
    input logic CLK, 
    input logic RST
    );

    //デコード命令
    logic[6:0] opcode;
    logic[4:0] rd;
    logic[4:0] rs1;
    logic[4:0] rs2;
    logic[2:0] funct3;
    logic[7:0] funct7;
    logic[BIN_DIG-1:0] imm;

    // //制御ハザード用フラグ
    // logic branch, jamp;
    // logic ctrl_hazard;

    // assign ctrl_hazard = branch | jamp;

    //インターフェースのインスタンス化
    hazard hazard(.CLK(CLK), .RST(RST));
    fetchToDecode fetchToDecode(.CLK(CLK), .RST(RST), .hazard(hazard.fToD));
    decodeToExecOrDmem decodeToExecOrDmem(.CLK(CLK), .RST(RST), .hazard(hazard.dToED));
    execToWriteback execToWriteback(.CLK(CLK), .RST(RST));
    topToExecOrDmem topToExecOrDmem(.CLK(CLK), .RST(RST));
    dmemToWriteback dmemToWriteback(.CLK(CLK), .RST(RST));
    writebackToForward writebackToForward(.CLK(CLK), .RST(RST));


    //モジュールのインスタンス化
    fetcher fetcher(.writebackToForward(writebackToForward.fetch), .fetchToDecode(fetchToDecode.fetch));
    decoder decoder(.fetchToDecode(fetchToDecode.decode), .decodeToExecOrDmem(decodeToExecOrDmem.decode));
    exec exec(.writebackToForward(writebackToForward.exec), .decodeToExecOrDmem(decodeToExecOrDmem.execOrDmem), .execToWriteback(execToWriteback.exec), .hazard(hazard.exec));
    memaccess memaccess(.writebackToForward(writebackToForward.dmem), .decodeToExecOrDmem(decodeToExecOrDmem.execOrDmem), .dmemToWriteback(dmemToWriteback.dmem));
    writeback writeback(.execToWriteback(execToWriteback.writeback), .dmemToWriteback(dmemToWriteback.writeback), .writebackToForward(writebackToForward.writeback));
    
    //実行ログ確認用の配線
    assign opcode = decodeToExecOrDmem.next_opcode;
    assign rd = decodeToExecOrDmem.next_rd;
    assign rs1 = decodeToExecOrDmem.next_rs1;
    assign rs2 = decodeToExecOrDmem.next_rs2;
    assign funct3 = decodeToExecOrDmem.next_funct3;
    assign funct7 = decodeToExecOrDmem.next_funct7;
    assign imm = decodeToExecOrDmem.next_imm;

endmodule

