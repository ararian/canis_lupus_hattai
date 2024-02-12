import defs::*;

//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(
    writebackToForward.fetch writebackToForward, 
    fetchToDecode.fetch fetchToDecode
    );
    logic [BIN_DIG-1:0]i_mem [MEM_SIZE-1:0];
    initial
        $readmemh("i_mem.txt", i_mem);
    assign fetchToDecode.curr_inst = i_mem[writebackToForward.fixed_pc_reg];
    assign fetchToDecode.curr_pc_reg = writebackToForward.fixed_pc_reg;

endmodule

