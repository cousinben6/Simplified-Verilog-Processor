
//pipelined multiplier made from unpiplined adder and shifter
//
module multiplier(
input wire [7:0] X, //mulitply input 1
input wire [7:0] Y, //multiply input 2
output reg [15:0] O, //output signal
input wire Rst, //synchronous reset
input wire Clk,
output reg Done);
wire [15:0] shift_A;
wire [15:0] add_out;
reg [1:0] state;
reg [7:0] A;
reg [7:0] B;
reg [2:0] C;

shifter u1(.in({8'b0,A}), .N(C), .O(shift_A));
fulladder u2(.x(B[C]?shift_A:16'b0), .y(O), .O(add_out));
always@(posedge Clk)
begin
case (state)
	2'b00:
		begin
		Done=1'b0;
		if (Rst==1)
			begin
			O<=16'b0;
			C<=3'b0;
			A<=X;
			B<=Y;
			state=2'b01;
			end
		else
			begin
			state=2'b00;
			C<=C;
			A<=A;
			B<=B;
			end
		end
	2'b01:
		begin
		Done=1'b0;
			C=C+1'b1;
			state=2'b10;
		end
	2'b10:
		begin
		Done=1'b0;
			O<=add_out;
			if (C==3'b111) state<=2'b11;
			else state<=2'b01;
		end
	2'b11:
	begin
		Done=1'b1;
		state<=2'b0;
	end
	default:
			begin
		Done=1'b0;
		if (Rst==1)
			begin
			O<=16'b0;
			C<=3'b0;
			A<=X;
			B<=Y;
			state=2'b01;
			end
		else
			begin
			state=2'b00;
			C<=C;
			A<=A;
			B<=B;
			end
		end
endcase
end
endmodule