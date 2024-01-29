

// デコーダ：フェッチで取得した値を命令形式ごとに成型して解釈する
module decoder(
    input logic[31:0] inst, 
    output logic[6:0] opcode,
    output logic[4:0] rd,
    output logic[4:0] rs1,
    output logic[4:0] rs2,
    output logic[2:0] funct3,
    output logic[7:0] funct7,
    output logic[20:0] imm
);

    // typedef enum logic[]{

    // }
    assign opcode = inst[6:0];

    always_comb begin
        if(opcode inside {7'h17, 7'h37})begin 
            rd = inst[11:7]; imm = inst[31:12]; //U形式
        end else if(opcode == 7'h6f)begin
            rd = inst[11:7]; imm = {inst[31], inst[19:12], inst[20], inst[30:21]}; //J形式
        end else if(opcode inside {7'h67, 7'h03, 7'h13, 7'h0f, 7'h73})begin
            rd = inst[11:7]; funct3 = inst[14:12]; rs1 = inst[19:15]; imm = inst[31:20]; //I形式
        end else if(opcode == 7'h63)begin
            funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; imm = {inst[31], inst[7], inst[30:25], inst[11:8]}; //B形式
        end else if(opcode == 7'h23)begin
            funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; imm = {inst[31:25], inst[11:7]}; //S形式
        end else if(opcode == 7'h33)begin
            funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; imm = inst[31:25]; //R形式
        end
    end
endmodule
