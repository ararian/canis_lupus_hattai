
module writeback(
    execToWriteback.writeback execToWriteback, 
    dmemToWriteback.writeback dmemToWriteback,
    writebackToTop.writeback writebackToTop
);
    always_comb begin
        if(dmemToWriteback.load_active) begin
            writebackToTop.next_rd = dmemToWriteback.next_rd;
            writebackToTop.next_rd_value = dmemToWriteback.next_rd_value;
        end else begin
            writebackToTop.next_rd = execToWriteback.next_rd;
            writebackToTop.next_rd_value = execToWriteback.next_rd_value;
            writebackToTop.next_pc_reg = execToWriteback.next_pc_reg;
        end
    end
endmodule

