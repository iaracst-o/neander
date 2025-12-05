module datapath(
    input logic clk,rst
);

    // SINAIS

    // PC

    logic pc_load;          // carga pc
    logic pc_inc;          // incremento 
    logic [7:0] pc_in;     // dado que vai ser recebido por pc
    logic [7:0] pc_out;    // valor que sai de pc

    //REM

    logic rem_load;        // carga rem
    logic [7:0] rem_out;  //saída rem

    //MEMORIA

    logic mem_write;
    logic [15:0] mem_out; //dado que sai da memoria

    //RDM

    logic rdm_load;         // carga RDM
    logic [15:0] rdm_out;  //dado guardado no RDM

    //RI

    logic ri_load;  //carga RI (decide quando RI vai guardar o valor que chegou de RDM)
    logic [3:0] ri_out;   // a saida de RI é o OPCODE

    // AC

    logic ac_load;           // carga AC
    logic [15:0] ac_out;     // saída AC
    logic [15:0] ula_out;    // entrada para ac (resultado da ULA)

    // ULA

    logic [2:0] selULA;       // operação da ULA
    logic flag_N, flag_Z;      // flags

    // FLAGS

    logic n_load, z_load;      // sinais para carregar N e Z
    logic n_out, z_out;        // saída das flags


    //instanciando pc

    pc_inc teste_PC (
        .clk(clk),      //clock do datapath
        .rst(rst),      // reset do datapath
        .load(pc_load), // carrega novo valor no PC
        .incrementa(pc_inc), // PC + 1 quando ativo
        .entrada(pc_in),    // valor que entra no PC
        .pc(pc_out)         // valor atual do PC (saida)
    );

    //teste
    assign pc_load = 0;
    assign pc_inc = 0;
    assign pc_in = 8'b0;

    // PC -> REM

    //instanciando rem

    rem teste_REM (
        .clk(clk),
        .rst(rst),
        .load(rem_load),
        .d(pc_out),  // a saida de pc entra no rem
        .q(rem_out) // saida do REM, endereço que vai pra memoria
    );

    //teste
    assign rem_load = 0;


    // PC -> REM -> MEMORIA
    ram teste_MEM(
        .clk(clk),
        .addr(rem_out),    //endereço sai do rem e entra na memoria
        .write(mem_write), //ativa escrita na memoria
        .data_in(rdm_out), //dado que vai ser escrito
        .data_out(mem_out) //dado que foi lido
    );

   
    // instanciando RDM

    //PC -> REM -> MEMORIA -> RDM

    rdm teste_RDM (
        .clk(clk),
        .rst(rst),
        .load(rdm_load),
        .d(mem_out),          // dado sai da memoria e vai pro RDM
        .q(rdm_out)           // dado que saiu do RDM (dado que foi lido)
    );

    // teste
    assign mem_write = 0;
    assign rdm_load  = 0;


    //instanciando  RI

    //PC -> REM -> MEMORIA -> RDM -> RI

   ri teste_RI(
    .clk(clk),           
    .rst(rst),           
    .load(ri_load),      
    .d(rdm_out[3:0]),    // pega os 4 bits menos significativos do RDM
    .q(ri_out)           // saída do RI
);

    // instanciando AC

    ac teste_AC (
    .clk(clk),
    .rst(rst),
    .load(ac_load),
    .d(ula_out),    // resultado da ULA vai entrar no AC
    .q(ac_out)      // saída do AC
);

    // teste 
    assign ac_load = 0;


    // instanciando a ULA

    // PC -> REM -> MEMORIA -> RDM -> AC -> ULA -> AC

    ULA teste_ULA (
        .X(ac_out),          // entrada X da ULA
        .Y(rdm_out),         // entrada Y da ULA
        .selULA(selULA),     // seleciona operação
        .AC(ula_out),        // resultado da ULA
        .N(flag_N),          // flag N
        .Z(flag_Z)           // flag Z
    );

    // teste 
    assign selULA = 3'b000;  //operação soma


    // flip-flops (das flags)

    // AC -> ULA -> FLAGS

    logic N_reg, Z_reg;  // registradores que armazenam as flags

    always_ff @(posedge clk or posedge rst) 
    begin
        if (rst) 
        begin
            N_reg <= 0;   // reseta a flag N
            Z_reg <= 0;   // reseta a flag Z
        end 
        else 
        begin
            N_reg <= flag_N;  // pega o valor de N da ULA
            Z_reg <= flag_Z;  // valor de Z da uLA
        end
    end

    // saídas para usar as flags em outro modulo
    assign N_out = N_reg;
    assign Z_out = Z_reg;

endmodule
