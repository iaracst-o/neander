module flag_n(
    input logic d,clk,
    output logic q
);
    always_ff @(posedge clk)
        q <= d;
        
endmodule