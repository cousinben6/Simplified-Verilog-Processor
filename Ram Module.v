
//////////////////////////////////////////////
//Ram module implemented as array of flipflops
//
//
///////////////////////////////////////////////
	module  ram(
    we,//write enable
    d,//data input
    q,//data output
    addr); //input address
	  
	input wire we; //1 bit read/write enable
	input wire [15:0] d; //16 bit data input
	input wire [7:0] addr; //8 bit input address
	output wire [15:0] q; //16 bit data output
	
	reg [15:0] mem [31:0]; //ram storage just implemented as flipflops, 
	
	always@(posedge we)
		mem [addr] <=d;
	assign q = mem [addr]&~we;
	endmodule
	

	module alu(//im happy with this module.
           A,
           B,
           opALU,
           Rout
);
		input wire [15:0] A;
		input wire [15:0] B;
		input wire opALU;
		output wire [15:0] Rout;
	assign Rout =opALU? A+B : A|B; 
	endmodule
	
//A => 16 bit input 1
//B => 16 bit input 2
//opALU => 1 bit input
//	       1 A + B
//                   0 A | B
//Rout => 16 bit output