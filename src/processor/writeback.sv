
module writeback(
    execToWriteback.writeback execToWriteback, 
    dmemToWriteback.writeback dmemToWriteback,
    writebackToForward.writeback writebackToForward
);
    always_comb begin
        if(dmemToWriteback.load_active) begin
            writebackToForward.next_rd = dmemToWriteback.next_rd;
            writebackToForward.next_rd_value = dmemToWriteback.next_rd_value;
        end else begin
            writebackToForward.next_rd = execToWriteback.next_rd;
            writebackToForward.next_rd_value = execToWriteback.next_rd_value;
            writebackToForward.next_pc_reg = execToWriteback.next_pc_reg;
        end
    end
endmodule

