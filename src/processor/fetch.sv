import defs::*;

//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(
    fetchToDecode.fetch fetchToDecode
    );

    logic [MEM_SIZE-1:0][31:0]memory;
    assign memory = '0;
    assign memory[4] = 32'h000140EF;
    assign memory[16] = 32'b11111000001111100000111110010111;
    assign memory[20] = 32'b11111000001111100000111110110111;
    assign memory[24] = 32'b00000111110000011111000001101111;
    assign fetchToDecode.curr_inst = memory[fetchToDecode.addr];

endmodule

