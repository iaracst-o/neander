module rdm(
    input logic clk,rst,load,
    input logic [15:0] d,
    output logic [15:0] q
);

    logic [15:0] q_reg, q_next;

    always_ff @(posedge clk)
    
        begin
            if (rst == 1)
                q_reg <= 16'b0; //zera

            else if (load==1)
                q_reg <= q_next;
        end

    //Logica de entrada
    assign q_next = d;

    //saida
    assign q = q_reg;

endmodule