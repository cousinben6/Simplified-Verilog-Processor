///////////////////////////////////////////////////////////////////////
//Benjamin Evan Ryle
// 11/16/2019
//		Simplified processor design
//
//KNOWN ISSUES:
//
//	need to create an extra state to better process reset signals
//	Processor falls out of sync after given 4 recursive jump routines
//
///////////////////////////////////////////////////////////////////////

module proj1(
           clk,
           rst,
			MemRW_IO,
			MemAddr_IO,
           MemD_IO
		    );

           input clk;
           input rst;
			output MemRW_IO;
			output [7:0]MemAddr_IO;
           output [15:0]MemD_IO;

          wire   zflag;
          wire   [7:0]opcode;
          wire   [7:0]MemAddr;
          wire   [15:0]MemD;
		 wire [15:0]MemQ;
		 wire muxPC;
		 wire muxMAR;
		 wire muxACC;
		 wire loadMAR;
		 wire loadPC;
		 wire loadACC;
		 wire loadMDR;
		 wire loadIR;
		 wire opALU;
		 wire MemRW;
		 wire mullDone;
		 wire mullACC;
//one instance of memory
ram r1(
       MemRW,//write enable
       MemD,//data input
       MemQ,//data output
       MemAddr); //input address
//one instance of controller
ctr c1(
	//inputs
        .clk(clk),		//clock
		.rst(rst),		//reset
		.zflag(zflag),		//zflag for jumps
		.opcode(opcode), 	//tells me what to decode
	//outputs	
		.muxPC(muxPC),
		.muxMAR(muxMAR),
		.muxACC(muxACC),
		.loadMAR(loadMAR),
		.loadPC(loadPC),
		.loadACC(loadACC),
		.loadMDR(loadMDR),
		.loadIR(loadIR),
		.opALU(opALU),
		.MemRW(MemRW),
		.mullACC(mullACC),
		.mullDone(mullDone)
		);
//one instance of datapath1
datapath	d1(
		//inputs
           .clk(clk),
           .rst(rst),
           .muxPC(muxPC),	
           .muxMAR(muxMAR),
           .muxACC(muxACC),
           .loadMAR(loadMAR),
           .loadPC(loadPC),
           .loadACC(loadACC),
           .loadMDR(loadMDR),
           .loadIR(loadIR),
           .opALU(opALU),
		   //outputs
           .zflag(zflag),
           .opcode(opcode),
           .MemAddr(MemAddr),
           .MemD(MemD),
		   //input
           .MemQ(MemQ),
		   .mullACC(mullACC),
		   .mullDone(mullDone)
			);
			
//these are just to observe the signals.
 assign MemAddr_IO = MemAddr;
 assign MemD_IO = MemD;
 assign MemRW_IO = MemRW;

endmodule


