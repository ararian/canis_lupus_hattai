import defs::*;

module exec(
    writebackToForward.exec writebackToForward, 
    decodeToExecOrDmem.execOrDmem decodeToExecOrDmem,
    execToWriteback.exec execToWriteback, 
    hazard.exec hazard
);

assign execToWriteback.next_rd = decodeToExecOrDmem.next_rd;
//TODO：共通部分のモジュール化

//J形式の命令記述
always_comb begin
    if(decodeToExecOrDmem.next_opcode == JAL) begin
        execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{11{decodeToExecOrDmem.next_imm[20]}}, decodeToExecOrDmem.next_imm[20:0]}; //TODO：rdが省かれると、x1と想定されるとは？
        execToWriteback.next_rd_value = decodeToExecOrDmem.next_pc_reg + 32'h4;
        hazard.jamp = 1'b1;
    end   
end
//B形式の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        BEQ: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] == writebackToForward.general_reg[decodeToExecOrDmem.next_rs2])begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end
        BNE: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] != writebackToForward.general_reg[decodeToExecOrDmem.next_rs2])begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end
        BLT: begin
            if($signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1]) < $signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs2]))begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end
        BGE: begin
            if($signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1]) >= $signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs2]))begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end
        BLTU: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] < writebackToForward.general_reg[decodeToExecOrDmem.next_rs2])begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end
        BGEU: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] >= writebackToForward.general_reg[decodeToExecOrDmem.next_rs2])begin
                execToWriteback.next_pc_reg = decodeToExecOrDmem.next_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]};
                hazard.branch = 1'b1;
            end
        end      
    endcase
end

//R形式の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct7, decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        ADD: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] + writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        SUB: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] - writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        SLL: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] <<< writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        SLT: begin
            if($signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1]) < $signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs2])) begin
                execToWriteback.next_rd_value = 32'h1;
            end else begin
                execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTU: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] < writebackToForward.general_reg[decodeToExecOrDmem.next_rs2]) begin
                execToWriteback.next_rd_value = 32'h1;
            end else begin
                execToWriteback.next_rd_value = 32'h0;
            end
        end
        XOR: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] ^ writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        SRL: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] >>> writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        SRA: begin
            execToWriteback.next_rd_value = $signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1]) >>> decodeToExecOrDmem.next_rs2;
        end
        OR: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] | writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
        AND: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] & writebackToForward.general_reg[decodeToExecOrDmem.next_rs2];
        end
    endcase
end

//I形式 a の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        JALR: begin
            execToWriteback.next_pc_reg = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]}; // TODO：算出されたアドレスの再開ビットをマスクしてpcに設定？
            execToWriteback.next_rd_value = decodeToExecOrDmem.next_pc_reg + 32'h4;
            hazard.jamp = 1'b1;
        end
        ADDI: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] +  {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        SLTI: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] < $signed(decodeToExecOrDmem.next_imm[11:0]))begin 
                execToWriteback.next_rd_value = 32'h1;
            end else begin
                execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTIU: begin
            if(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] < decodeToExecOrDmem.next_imm[11:0])begin 
                execToWriteback.next_rd_value = 32'h1;
            end else begin
                execToWriteback.next_rd_value = 32'h0;
            end
        end
        XORI: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] ^ {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        ORI: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] | {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        ANDI: begin
            execToWriteback.next_rd_value = writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] & {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
    endcase
end


// I形式 b の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct7, decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        SLLI: begin
            execToWriteback.next_rd_value =  writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] <<< decodeToExecOrDmem.next_imm[5:0];
        end
        SRLI: begin
            execToWriteback.next_rd_value =  writebackToForward.general_reg[decodeToExecOrDmem.next_rs1] >>> decodeToExecOrDmem.next_imm[5:0];
        end
        SRAI: begin
            execToWriteback.next_rd_value = $signed(writebackToForward.general_reg[decodeToExecOrDmem.next_rs1]) >>> decodeToExecOrDmem.next_imm[5:0];
        end
    endcase
end

endmodule


