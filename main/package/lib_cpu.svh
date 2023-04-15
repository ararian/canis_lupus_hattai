`ifndef LIB_CPU_SVH
`define LIB_CPU_SVH
package lib_cpu;
  typedef struct packed {
    logic [31:0] zero, ra, sp, gp, tp, t0, t1, t2, s0, a1, a2, a3, a4, a5, a6, a7, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, t3, t4, t5, t6, pc;
  } REGS;

  typedef enum logic [31:0] {
    LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, 
    LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, 
    SLLI, SRLI, SRAI, ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND, 
    FENCE, FENCE.I, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
  } OPECODE;
endpackage
`endif
