module fetchtest;

logic CLK, RST;
rv_cpu rv_cpu(.CLK(CLK), .RST(RST));

always begin
    CLK <= 1'b1; #50;
    CLK <= 1'b0; #50;
end

initial begin
    RST <= 1'b1; #100;
    RST <= 1'b0; #50;
    #1000;
    $finish;
end

endmodule
