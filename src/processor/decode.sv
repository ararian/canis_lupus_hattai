
// デコーダ：フェッチで取得した値を命令形式ごとに成型して解釈する
module decoder(
    fetchToDecode.decode fetchToDecode, 
    decodeToExec.decode decodeToExec
);

    assign decodeToExec.curr_opcode = fetchToDecode.next_inst[6:0];

    always_comb begin
        if(decodeToExec.curr_opcode inside {7'h17, 7'h37})begin 
            decodeToExec.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExec.curr_imm = fetchToDecode.next_inst[31:12]; //U形式
        end else if(decodeToExec.curr_opcode == 7'h6f)begin
            decodeToExec.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExec.curr_imm = {fetchToDecode.next_inst[31], fetchToDecode.next_inst[19:12], fetchToDecode.next_inst[20], fetchToDecode.next_inst[30:21]}; //J形式
        end else if(decodeToExec.curr_opcode inside {7'h67, 7'h03, 7'h13, 7'h0f, 7'h73})begin
            decodeToExec.curr_rd = fetchToDecode.next_inst[11:7]; decodeToExec.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExec.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExec.curr_imm = fetchToDecode.next_inst[31:20]; //I形式
        end else if(decodeToExec.curr_opcode == 7'h63)begin
            decodeToExec.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExec.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExec.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExec.curr_imm = {fetchToDecode.next_inst[31], fetchToDecode.next_inst[7], fetchToDecode.next_inst[30:25], fetchToDecode.next_inst[11:8]}; //B形式
        end else if(decodeToExec.curr_opcode == 7'h23)begin
            decodeToExec.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExec.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExec.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExec.curr_imm = {fetchToDecode.next_inst[31:25], fetchToDecode.next_inst[11:7]}; //S形式
        end else if(decodeToExec.curr_opcode == 7'h33)begin
            decodeToExec.curr_funct3 = fetchToDecode.next_inst[14:12]; decodeToExec.curr_rs1 = fetchToDecode.next_inst[19:15]; decodeToExec.curr_rs2 = fetchToDecode.next_inst[24:20]; decodeToExec.curr_imm = fetchToDecode.next_inst[31:25]; //R形式
        end
    end
endmodule
