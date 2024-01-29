import defs::*;

//命令フェッチ：メモリから滅入れデータを取得する
//PCレジスタに記憶されたアドレスをメモリへ送信して、メモリはそのアドレスに格納された命令データをCPUへ返す。
module fetcher(
    input logic[31:0] addr, 
    output logic[31:0] inst
    );

    logic [MEM_SIZE:0][31:0]memory;
    assign memory = '0;
    assign memory[20] = '1;
    assign inst = memory[addr];

endmodule

