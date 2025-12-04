
//sem incremento

module pc(
    input logic clk,rst,load,
    input logic [7:0] d,
    output logic [7:0] q
);

    logic [7:0] q_reg, q_next;

    always_ff @(posedge clk)
    
        begin
            if (rst == 1)
                q_reg <= 8'b0; 

            else if (load==1)
                q_reg <= q_next;
        end

    //Logica de entrada
    assign q_next = d;

    //saida
    assign q = q_reg;

endmodule