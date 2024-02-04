// module exec(
//     decodeToExec.exec decodeToExec
// );
// typedef enum logic [6:0]{
//     JAL = 7'h6f
// };

// //jal命令：次の命令のアドレス（pc+4）をx[rd]に書き込み、それから現在のpcに符号拡張されたoffsetを加えて、pcに設定する。rdが省かれると、x1と想定される。
// //???：rdが省かれると、x1と想定されるとは？

// always_comb begin
//     if(decodeToExec.opcode == JAL)begin
//         assign next_pc_reg = pc_reg + {12{decodeToExec.imm[19]},decodeToExec.imm[19:0]};
//         assign next_general_reg[rd] = pc_reg + 32'h4;
//     end
// end
// endmodule


// // input logic[6:0] opcode,
// // input logic[4:0] rd,
// // input logic[4:0] rs1,
// // input logic[4:0] rs2,
// // input logic[2:0] funct3,
// // input logic[7:0] funct7,
// // input logic[20:0] imm,
// // input reg[31:0][31:0] general_reg,
// // input reg[31:0] pc_reg,
// // output reg[31:0] next_pc_reg, 
// // output reg[31:0][31:0] next_general_reg
