import defs::*;

//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(
    fetchToDecode.fetch fetchToDecode
    );
    logic [31:0]memory [MEM_SIZE-1:0];
    initial
        $readmemh("memory_data.txt", memory);
    assign fetchToDecode.curr_inst = memory[fetchToDecode.addr];

endmodule

