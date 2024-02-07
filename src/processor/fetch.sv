import defs::*;

//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(
    fetchToDecode.fetch fetchToDecode
    );
    logic [BIN_DIG-1:0]i_mem [MEM_SIZE-1:0];
    initial
        $readmemh("memory_data.txt", i_mem);
    assign fetchToDecode.curr_inst = i_mem[fetchToDecode.curr_pc_reg];

endmodule

