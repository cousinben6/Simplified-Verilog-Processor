//unpipelined full adder module
//will later be replaced with a piplined full adder
module fulladder(x, y, O);
input [15:0] x;
input [15:0] y;
output wire [15:0] O;
assign O = y + x;
endmodule
