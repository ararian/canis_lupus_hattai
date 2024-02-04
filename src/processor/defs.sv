package defs;
    parameter MEM_SIZE = 4000;
    parameter BIN_DIG = 32;

    typedef enum logic [6:0]{
        JAL = 7'h6f
    } J_TYPE;

    typedef enum logic[9:0]{
        BEQ = 10'h063, 
        BNE = 10'h0E3, 
        BLT = 10'h263,
        BGE = 10'h2E3, 
        BLTU = 10'h363, 
        BGEU = 10'h3E3
    }B_TYPE;

    typedef enum logic[16:0]{
        ADD = 17'h00033, 
        SUB = 17'h08033, 
        SLL = 17'h000B3,
        SLT = 17'h00133, 
        SLTU = 17'h001B3, 
        XOR = 17'h00233, 
        SRL = 17'h002B3, 
        SRA = 17'h082B3,
        OR = 17'h00333,
        AND = 17'h003B3
    }R_TYPE;

    typedef enum logic[9:0]{
        SB = 10'h023,
        SH = 10'h0A3,
        SW = 10'h123
    }S_TYPE;

    typedef enum logic[9:0]{
        JALR = 10'h067, 
        LB = 10'h003, 
        LH = 10'h083,
        LW = 10'h103, 
        LBU = 10'h203,
        LHU = 10'h283, 
        ADDI = 10'h013,
        SLTI = 10'h113,
        SLTIU = 10'h193,
        XORI = 10'h213,
        ORI = 10'h313, 
        ANDI = 10'h393
    }I_a_TYPE;

    typedef enum logic[16:0]{
        SLLI = 17'h00093,
        SRLI = 17'h00293,
        SRAI = 17'h08293
    }I_b_TYPE;

    typedef enum logic[9:0]{
        FENCE = 10'h00F,
        FENCE_I = 10'h08F
    }I_c_TYPE;

    typedef enum logic[16:0]{
        ECALL = 17'h00073,
        EBREAK = 17'h00473      
    }I_d_TYPE;

    typedef enum logic[9:0]{
        CSRRW = 10'hF3,
        CSRRS = 10'h173,
        CSRRC = 10'h1F3,
        CSRRWI = 10'h2F3,
        CSRRSI = 10'h373,
        CSRRCI = 10'h3F3
    }I_e_TYPE;
endpackage
