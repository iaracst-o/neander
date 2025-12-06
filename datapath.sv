module datapath(
    input logic clk,rst, pc_load, pc_inc,
  	input logic rem_load, ac_load, rdm_load,
  	input logic mem_write, ri_load, n_load,
  	input logic z_load, sel_rem,
  	output logic[15:0] mem_in,
  	output logic [3:0] opcode,
  	output logic n_out, z_out
);

    // SINAIS

    // PC
 
    logic [7:0] pc_in;     // dado que vai ser recebido por pc
    logic [7:0] pc_out;    // valor que sai de pc

    logic [7:0] rem_out;
  	logic [7:0] rem_in;  //saída rem
  
    logic [15:0] rdm_out;  //dado guardado no RDM
  	logic [15:0] mem_out;
  	logic [7:0] addr;

    //RI
    logic [3:0] ri_out;   // a saida de RI é o OPCODE
  	assign opcode = ri_out;

    // AC
    logic [15:0] ac_out;     // saída AC
    logic [15:0] ula_out;    // entrada para ac (resultado da ULA)


    logic [2:0] selULA;       // operação da ULA
    logic flag_N, flag_Z;      // flags

    //instanciando pc

    pc_inc teste_PC (
        .clk(clk),      //clock do datapath
        .rst(rst),      // reset do datapath
        .load(pc_load), // carrega novo valor no PC
        .incrementa(pc_inc), // PC + 1 quando ativo
        .entrada(pc_in),    // valor que entra no PC
        .pc(pc_out)         // valor atual do PC (saida)
    );
  
  	assign pc_in = rdm_out[7:0];

    // PC -> REM

    //instanciando rem

    rem teste_REM (
        .clk(clk),
        .rst(rst),
        .load(rem_load),
      	.d(rem_in),  // a saida de pc entra no rem
        .q(rem_out) // saida do REM, endereço que vai pra memoria
    );
  
  assign rem_in = (sel_rem ? pc_out : rdm_out[7:0]); 

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
  
  	assign mem_in = ac_out;
  	assign addr = rem_out;

    //instanciando  RI

    //PC -> REM -> MEMORIA -> RDM -> RI

   ri teste_RI(
    .clk(clk),           
    .rst(rst),           
    .load(ri_load),      
    .d(rdm_out[15:12]),    // pega os 4 bits menos significativos do RDM
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

    // instanciando a ULA

    // PC -> REM -> MEMORIA -> RDM -> AC -> ULA -> AC

    ULA teste_ULA (
        .X(ac_out),          // entrada X da ULA
        .Y(rdm_out),         // entrada Y da ULA
        .selULA(selULA),     // seleciona operação
        .AC(ula_out),        // resultado da ULA
        .N(flag_N),          // flag No
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
          if (n_load)
            N_reg <= flag_N;  // pega o valor de N da ULA
          if (z_load)
            Z_reg <= flag_Z;  // valor de Z da uLA
        end
    end

    // saídas para usar as flags em outro modulo
    assign n_out = N_reg;
    assign z_out = Z_reg;

endmodule
