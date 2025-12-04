module pc_inc(
    input  logic clk,rst,load,
    input  logic incrementa,
    input  logic [7:0] entrada,
    output logic [7:0] pc
);

    logic [7:0] q_reg;

    assign pc = q_reg;    //tudo que tiver em q_reg sera mostrado como pc fora do modulo

    always_ff @(posedge clk or posedge rst) 
    begin
        if (rst == 1) 
            q_reg <= 8'b0;              //zera 
        else 
        begin
            if (incrementa == 1) 
                q_reg <= q_reg + 1;  //incrementa 

            else if (load == 1) 
                q_reg <= entrada;       //carrega
        end
    end

endmodule
