
//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(input logic[31:0] addr, logic[MEM_SIZE:0][31:0]memory, output inst);
    logic [MEM_SIZE:0][31:0]memory;

    instr = memory[addr];
endmodule

