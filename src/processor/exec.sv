import defs::*;

module exec(
    decodeToExecOrDmem.execOrDmem decodeToExecOrDmem,
    execToWriteback.exec execToWriteback,
    topToExecOrDmem.exec topToExecOrDmem
);

assign execToWriteback.next_rd = decodeToExecOrDmem.next_rd;
reg tmp;
//TODO：分岐命令実行時のフラッシュ処理等を実施する
//TODO：共通部分のモジュール化

//J形式の命令記述
always_comb begin
    if(decodeToExecOrDmem.next_opcode == JAL) begin
        assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{12{decodeToExecOrDmem.next_imm[19]}}, decodeToExecOrDmem.next_imm[19:0]}; //TODO：rdが省かれると、x1と想定されるとは？
        assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
    end   
end
//B形式の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        BEQ: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] == topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end
        BNE: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] != topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end
        BLT: begin
            if($signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1]) < $signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2]))begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end
        BGE: begin
            if($signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1]) >= $signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2]))begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end
        BLTU: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] < topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end
        BGEU: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] >= topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_pc_reg + {{19{decodeToExecOrDmem.next_imm[12]}}, decodeToExecOrDmem.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
            end
        end      
    endcase
end

//R形式の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct7, decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        ADD: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        SUB: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] - topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        SLL: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] << topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        SLT: begin
            if($signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1]) < $signed(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2])) begin
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTU: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] < topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2]) begin
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        XOR: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] ^ topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        SRL: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] >> topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        SRA: begin
            assign tmp = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1][31];
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] >> decodeToExecOrDmem.next_rs2;
            for(int i=0;i<decodeToExecOrDmem.next_rs2;i++)begin
                assign execToWriteback.next_rd_value[BIN_DIG-1-i] = tmp;
            end

        end
        OR: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] | topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
        AND: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] & topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs2];
        end
    endcase
end

//I形式 a の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        JALR: begin
            assign execToWriteback.next_pc_reg = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] + {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]}; // TODO：算出されたアドレスの再開ビットをマスクしてpcに設定？
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_pc_reg + 32'h4;
        end
        ADDI: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] +  {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        SLTI: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] < $signed(decodeToExecOrDmem.next_imm))begin 
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTIU: begin
            if(topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] < decodeToExecOrDmem.next_imm)begin 
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        XORI: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] ^ {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        ORI: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] | {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
        ANDI: begin
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] & {{20{decodeToExecOrDmem.next_imm[11]}}, decodeToExecOrDmem.next_imm[11:0]};
        end
    endcase
end


// I形式 b の命令記述
always_comb begin
    case({decodeToExecOrDmem.next_funct7, decodeToExecOrDmem.next_funct3, decodeToExecOrDmem.next_opcode})
        SLLI: begin
            assign execToWriteback.next_rd_value =  topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] << decodeToExecOrDmem.next_imm[5:0];
        end
        SRLI: begin
            assign execToWriteback.next_rd_value =  topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] >> decodeToExecOrDmem.next_imm[5:0];
        end
        SRAI: begin
            assign tmp = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1][31];
            assign execToWriteback.next_rd_value = topToExecOrDmem.curr_general_reg[decodeToExecOrDmem.next_rs1] >> decodeToExecOrDmem.next_imm[5:0];
            for(int i=0;i<decodeToExecOrDmem.next_imm[5:0];i++)begin
                assign execToWriteback.next_rd_value[BIN_DIG-1-i] = tmp;
            end
        end
    endcase
end

endmodule


