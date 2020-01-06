
//testbench
module proj1_tb;
	reg clk;
	reg rst;
	wire MemRW_IO;
	wire [7:0]MemAddr_IO;
	wire [15:0]MemD_IO;

always@(t.c1.reg_state) 
begin
	case (t.c1.reg_state)

		0: $display($time," Fetch_1");
		1: $display($time," Fetch_2");
		2: $display($time," Fetch_3");
		3: $display($time," Decode");
		4: $display($time," ExecAdd_1");
		5: $display($time," ExecOr_1");
		6: $display($time," ExecLoad_1");
		7: $display($time," ExecStore_1");
		8: $display($time," ExecJump");
		9: $display($time," ExecAdd_2");
		10:$display($time," ExecOr_2");
		11:$display($time," ExecLoad_2");
		12:$display($time," ExecMull_1");
		13:$display($time," ExecMull_2");
		
		default: $display($time," Unrecognized reg_state");

	endcase 
end

always 
begin
      #5  clk = !clk;
end
		
initial 
begin
	$dumpfile("Proj1_waves.vcd");
  	$dumpvars;
	clk=1'b0;
	rst=1'b1;
	$readmemh("mem.dat", proj1_tb.t.r1.mem);
	#20 rst=1'b0;
	#4350
	$display("Final value\n");
	$display("0x00d %d\n", proj1_tb.t.r1.mem[16'h000d]);
	$finish;
end

proj1 t(clk, rst, MemRW_IO, MemAddr_IO, MemD_IO);	   

endmodule
