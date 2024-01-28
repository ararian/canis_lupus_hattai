parameter MEM_SIZE = 4000-1;


module cpu(input wire CLK, wire RST);

reg[31:0] pc_reg;

always_ff(@posedge CLK)
if RST begin
    pc_reg <= 32'h0;
end else begin
    pc_reg <= pc_reg + 32'h4;
end

reg[31:0] result;

fetcher fetcher(.addr(pc_reg), .inst(result))



endmodule
