
module memaccess(
    decodeToExecOrDmem.execOrDmem decodeToExecOrDmem, 
    topToExecOrDmem.dmem topToExecOrDmem, 
    dmemToWriteback.dmem dmemToWriteback
    );
    logic [BIN_DIG-1:0]d_mem [MEM_SIZE-1:0];
    logic [BIN_DIG-1:0]addr;
    assign dmemToWriteback.next_rd = decodeToExecOrDmem.next_rd;

    always_comb begin
        case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode}) 
            SB: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                d_mem[addr] = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2][7:0];
                dmemToWriteback.load_active =1'b0;
            end
            SH: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                d_mem[addr] = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2][15:0];
                dmemToWriteback.load_active =1'b0;
            end
            SW: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                d_mem[addr] = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
                dmemToWriteback.load_active =1'b0;
            end
            LB: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                dmemToWriteback.next_rd_value = {{24{d_mem[addr][7]}}, d_mem[addr][7:0]};
                dmemToWriteback.load_active =1'b1;
            end
            LH: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                dmemToWriteback.next_rd_value = {{24{d_mem[addr][15]}}, d_mem[addr][15:0]};
                dmemToWriteback.load_active =1'b1;
            end
            LW: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                dmemToWriteback.next_rd_value = d_mem[addr];
                dmemToWriteback.load_active =1'b1;
            end
            LBU: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                dmemToWriteback.next_rd_value = {{24{1'b0}}, d_mem[addr][7:0]};
                dmemToWriteback.load_active =1'b1;
            end
            LHU: begin
                addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
                dmemToWriteback.next_rd_value = {{16{1'b0}}, d_mem[addr][15:0]};
                dmemToWriteback.load_active =1'b1;
            end
            default: begin
                dmemToWriteback.load_active =1'b0;
            end
        endcase
    end
endmodule

