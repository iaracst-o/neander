module ram(
input logic clk, 
input logic[7:0] addr,
input logic write,
input logic[15:0] data_in,
output logic[15:0] data_out

);

logic [15:0] ram[0:255];


initial begin
  $readmemb("memo.txt",ram);
  $display("memory loaded");
end

always_ff @(posedge clk) begin
  if ( write ) begin
    ram[addr] <= data_in;
    $display("write %b %b", data_in, addr);
  end
end

assign data_out =  ram[addr];

endmodule