
module writeback(
    execToWriteback.writeback execToWriteback, 
    dmemToWriteback.writeback dmemToWriteback,
    writebackToTop.writeback writebackToTop
);
    always_comb begin
        if(dmemToWriteback.load_active) begin
            assign writebackToTop.next_rd = dmemToWriteback.next_rd;
            assign writebackToTop.next_rd_value = dmemToWriteback.next_rd_value;
            assign writebackToTop.next_pc_reg = execToWriteback.next_pc_reg + 32'h4;
        end else begin
            assign writebackToTop.next_rd = execToWriteback.next_rd;
            assign writebackToTop.next_rd_value = execToWriteback.next_rd_value;
            assign writebackToTop.next_pc_reg = execToWriteback.next_pc_reg;
        end
    end
endmodule

