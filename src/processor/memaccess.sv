
module memaccess(
    decodeToExecOrDmem.execOrDmem decodeToExecOrDmem, 
    topToExecOrDmem.dmem topToExecOrDmem, 
    dmemToWriteback.dmem dmemToWriteback, 
    output load_active, 
    input CLK
    );
    logic [BIN_DIG-1:0]d_mem [MEM_SIZE-1:0];
    logic [BIN_DIG-1:0]addr;
    logic load_active;
    assign dmemToWriteback.next_rd = decodeToExecOrDmem.next_rd;
    assign load_active =1'b0;

    case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode}) 
        SB: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            always_ff @(posedge CLK) begin
                d_mem[addr] <= topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2][7:0];
            end
        end
        SH: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            always_ff @(posedge CLK) begin
                d_mem[addr] <= topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2][15:0];
            end
        end
        SW: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            always_ff @(posedge CLK) begin
                d_mem[addr] <= topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
            end
        end
        LB: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            assign dmemToWriteback.next_rd_value = {{24{d_mem[addr][7]}}, d_mem[addr][7:0]};
            assign load_active =1'b1;
        end
        LH: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            assign dmemToWriteback.next_rd_value = {{24{d_mem[addr][15]}}, d_mem[addr][15:0]};
            assign load_active =1'b1;
        end
        LW: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            assign dmemToWriteback.next_rd_value = d_mem[addr];
            assign load_active =1'b1;
        end
        LBU: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            assign dmemToWriteback.next_rd_value = {{24{1'b0}}, d_mem[addr][7:0]};
            assign load_active =1'b1;
        end
        LHU: begin
            assign addr = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm};
            assign dmemToWriteback.next_rd_value = {{16{1'b0}}, d_mem[addr][15:0]};
            assign load_active =1'b1;
        end
    endcase
endmodule

