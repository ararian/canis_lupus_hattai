parameter MEM_SIZE = 4000-1;


module rv_cpu(
    input wire CLK, 
    input wire RST
    );

    reg [31:0] pc_reg;

    always_ff @(posedge CLK)begin
        if (RST) begin
            pc_reg <= 32'h0;
        end else begin
            pc_reg <= pc_reg + 32'h4;
        end
    end
    reg[31:0] result;

    fetcher fetcher(.addr(pc_reg), .inst(result));



endmodule
