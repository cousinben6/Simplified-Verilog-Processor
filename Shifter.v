
// nonpipelined shifter
// will later be replaced with a piplined shifter
module shifter (in, N, O );
input [15:0] in;
input [2:0] N;
output [15:0] O;
reg [7:0] out_reg;
assign O = out_reg;
always @(N or in) begin
case (N)
7 : out_reg <= { in[7:0],7'b0};
6 : out_reg <= { in[7:0],6'b0};
5 : out_reg <= { in[7:0],5'b0};
4 : out_reg <= { in[7:0],4'b0};
3 : out_reg <= { in[7:0],3'b0};
2 : out_reg <= { in[7:0],2'b0};
1 : out_reg <= { in[7:0],1'b0};
0 : out_reg <= in[7:0];
endcase
end
endmodule