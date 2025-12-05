module ULA(
  input logic[2:0] selULA, //seletor de operaçao
  input logic[15:0] X,Y,  // X vem do ac e Y do RDM
  output logic[15:0] AC, //resultado que volta pro ac
  output logic N, Z);
  
  always @(*)  // quando a entrada mudar, a ula recalcula tudo novamente
    begin
      case(selULA)
      3'b000:     // 000 ADD
        AC = X + Y; 
      3'b001:      // 001 AND
        AC = X | Y;
      3'b010:       // 010 OR
        AC = X & Y;
      3'b011:       // 011 NOT
      	AC = ~X;
      default:
        AC = X;
      endcase
      N = AC[15];
      Z = (AC == 16'b0);
    end
    
endmodule