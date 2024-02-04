import defs::*;

module exec(
    decodeToExec.exec decodeToExec,
    execToWriteback.exec execToWriteback,
    topToExec.exec topToExec
);

assign execToWriteback.next_rd = decodeToExec.next_rd;
reg tmp;
//TODO：分岐命令実行時のフラッシュ処理等を実施する
//TODO：共通部分のモジュール化
//J形式の命令記述
always_comb begin
    if(decodeToExec.next_opcode == JAL) begin
        assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{12{decodeToExec.next_imm[19]}}, decodeToExec.next_imm[19:0]}; //TODO：rdが省かれると、x1と想定されるとは？
        assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
    end   
end
//B形式の命令記述
always_comb begin
    case({decodeToExec.next_funct3, decodeToExec.next_opcode})
        BEQ: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] == topToExec.curr_general_reg[decodeToExec.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end
        BNE: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] != topToExec.curr_general_reg[decodeToExec.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end
        BLT: begin
            if($signed(topToExec.curr_general_reg[decodeToExec.next_rs1]) < $signed(topToExec.curr_general_reg[decodeToExec.next_rs2]))begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end
        BGE: begin
            if($signed(topToExec.curr_general_reg[decodeToExec.next_rs1]) >= $signed(topToExec.curr_general_reg[decodeToExec.next_rs2]))begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end
        BLTU: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] < topToExec.curr_general_reg[decodeToExec.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end
        BGEU: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] >= topToExec.curr_general_reg[decodeToExec.next_rs2])begin
                assign execToWriteback.next_pc_reg = topToExec.curr_pc_reg + {{19{decodeToExec.next_imm[12]}}, decodeToExec.next_imm[12:0]}; //TODO：符号拡張の指定範囲やデータサイズの確認
            end else begin
                assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
            end
        end      
    endcase
end

//R形式の命令記述
always_comb begin
    case({decodeToExec.next_funct7, decodeToExec.next_funct3, decodeToExec.next_opcode})
        ADD: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] + topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        SUB: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] - topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        SLL: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] << topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        SLT: begin
            if($signed(topToExec.curr_general_reg[decodeToExec.next_rs1]) < $signed(topToExec.curr_general_reg[decodeToExec.next_rs2])) begin
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTU: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] < topToExec.curr_general_reg[decodeToExec.next_rs2]) begin
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        XOR: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] ^ topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        SRL: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] >> topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        SRA: begin
            assign tmp = topToExec.curr_general_reg[decodeToExec.next_rs1][31];
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] >> decodeToExec.next_rs2;
            for(int i=0;i<decodeToExec.next_rs2;i++)begin
                assign execToWriteback.next_rd_value[BIN_DIG-1-i] = tmp;
            end

        end
        OR: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] | topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
        AND: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] & topToExec.curr_general_reg[decodeToExec.next_rs2];
        end
    endcase
end

//I形式 a の命令記述
always_comb begin
    case({decodeToExec.next_funct3, decodeToExec.next_opcode})
        JALR: begin
            assign execToWriteback.next_pc_reg = topToExec.curr_general_reg[decodeToExec.next_rs1] + {{20{decodeToExec.next_imm[11]}}, decodeToExec.next_imm[11:0]}; // TODO：算出されたアドレスの再開ビットをマスクしてpcに設定？
            assign execToWriteback.next_rd_value = topToExec.curr_pc_reg + 32'h4;
        end
        ADDI: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] +  {{20{decodeToExec.next_imm[11]}}, decodeToExec.next_imm[11:0]};
        end
        SLTI: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] < $signed(decodeToExec.next_imm))begin 
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        SLTIU: begin
            if(topToExec.curr_general_reg[decodeToExec.next_rs1] < decodeToExec.next_imm)begin 
                assign execToWriteback.next_rd_value = 32'h1;
            end else begin
                assign execToWriteback.next_rd_value = 32'h0;
            end
        end
        XORI: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] ^ {{20{decodeToExec.next_imm[11]}}, decodeToExec.next_imm[11:0]};
        end
        ORI: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] | {{20{decodeToExec.next_imm[11]}}, decodeToExec.next_imm[11:0]};
        end
        ANDI: begin
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] & {{20{decodeToExec.next_imm[11]}}, decodeToExec.next_imm[11:0]};
        end
    endcase
end


// I形式 b の命令記述
always_comb begin
    case({decodeToExec.next_funct7, decodeToExec.next_funct3, decodeToExec.next_opcode})
        SLLI: begin
            assign execToWriteback.next_rd_value =  topToExec.curr_general_reg[decodeToExec.next_rs1] << decodeToExec.next_imm[5:0];
        end
        SRLI: begin
            assign execToWriteback.next_rd_value =  topToExec.curr_general_reg[decodeToExec.next_rs1] >> decodeToExec.next_imm[5:0];
        end
        SRAI: begin
            assign tmp = topToExec.curr_general_reg[decodeToExec.next_rs1][31];
            assign execToWriteback.next_rd_value = topToExec.curr_general_reg[decodeToExec.next_rs1] >> decodeToExec.next_imm[5:0];
            for(int i=0;i<decodeToExec.next_imm[5:0];i++)begin
                assign execToWriteback.next_rd_value[BIN_DIG-1-i] = tmp;
            end
        end
    endcase
end

endmodule


