
// デコーダ：フェッチで取得した値を命令形式ごとに成型して解釈する
module decoder(
    fetchToDecode.decode fetchToDecode, 
    decodeToExecOrDmem.decode decodeToExecOrDmem
);

    assign decodeToExecOrDmem.curr_pc_reg = fetchToDecode.next_pc_reg;
    assign decodeToExecOrDmem.curr_opcode = fetchToDecode.next_inst[6:0];

    always_comb begin
        if(decodeToExecOrDmem.curr_opcode inside {7'h17, 7'h37})begin 
            decodeToExecOrDmem.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExecOrDmem.curr_imm = fetchToDecode.next_inst[31:12]; //U形式
        end else if(decodeToExecOrDmem.curr_opcode == 7'h6f)begin
            decodeToExecOrDmem.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExecOrDmem.curr_imm = {fetchToDecode.next_inst[31], fetchToDecode.next_inst[19:12], fetchToDecode.next_inst[20], fetchToDecode.next_inst[30:21]}; //J形式
        end else if(decodeToExecOrDmem.curr_opcode inside {7'h67, 7'h03, 7'h13, 7'h0f, 7'h73})begin
            decodeToExecOrDmem.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExecOrDmem.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExecOrDmem.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExecOrDmem.curr_imm = fetchToDecode.next_inst[31:20]; //I形式
        end else if(decodeToExecOrDmem.curr_opcode == 7'h63)begin
            decodeToExecOrDmem.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExecOrDmem.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExecOrDmem.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExecOrDmem.curr_imm = {fetchToDecode.next_inst[31], fetchToDecode.next_inst[7], fetchToDecode.next_inst[30:25], fetchToDecode.next_inst[11:8]}; //B形式
        end else if(decodeToExecOrDmem.curr_opcode == 7'h23)begin
            decodeToExecOrDmem.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExecOrDmem.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExecOrDmem.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExecOrDmem.curr_imm = {fetchToDecode.next_inst[31:25], fetchToDecode.next_inst[11:7]}; //S形式
        end else if(decodeToExecOrDmem.curr_opcode == 7'h33)begin
            decodeToExecOrDmem.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExecOrDmem.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExecOrDmem.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExecOrDmem.curr_imm = fetchToDecode.next_inst[31:25]; //R形式
        end
    end
endmodule
