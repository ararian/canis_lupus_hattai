import defs::*;

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

