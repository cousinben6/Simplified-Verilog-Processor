
//////////////////////////////////////
//ctr is a meely reg_state machine
// it's the processors control path.
//
//
//////////////////////////////////////
	module ctr (
	//inputs
        clk,		//clock
		rst,		//reset
		zflag,		//zflag for jumps
		opcode, 	//tells me what to decode
	//outputs	
		muxPC,
		muxMAR,
		muxACC,
		loadMAR,
		loadPC,
		loadACC,
		loadMDR,
		loadIR,
		opALU,
		MemRW,//memory read/write
		mullACC,
		mullDone
		);	

		input clk;
		input rst;
		input zflag;
		input [7:0]opcode;
		output reg muxPC;
		output reg muxMAR;
		output reg muxACC;
		output reg loadMAR;
		output reg loadPC;
		output reg loadACC;
		output reg loadMDR;
		output reg loadIR;
		output reg opALU;
		output reg MemRW;
		output reg mullACC;
		input mullDone;   
		reg [3:0] reg_state;
		reg state_done;

//These opcode representation need to be followed for proper operation
parameter op_add		=		8'b001;
parameter op_or			= 		8'b010;
parameter op_jump		=		8'b011;
parameter op_jumpz		=		8'b100;
parameter op_load		=		8'b101;
parameter op_store		=		8'b110;
parameter op_mull		=		8'b1001;

//state machine states (ever clk a new reg_state)
parameter Fetch_1 		= 		4'b0000;
parameter Fetch_2 		= 		4'b0001;
parameter Fetch_3 		= 		4'b0010;
parameter Decode 		= 		4'b0011;
parameter ExecAdd_1 	=		4'b0100;
parameter ExecOr_1 		=		4'b0101;
parameter ExecLoad_1	=		4'b0110;
parameter ExecStore_1	=		4'b0111;
parameter ExecJump 		=		4'b1000;
parameter ExecAdd_2 	=		4'b1001;
parameter ExecOr_2 		=		4'b1010;
parameter ExecLoad_2	=		4'b1011;
parameter ExecMull_1	=		4'b1100;
parameter ExecMull_2	=		4'b1101;
always@(posedge rst)
	begin
		state_done=1'b1;
		reg_state=Fetch_1;
		MemRW	=	1'b0;
		loadMDR	=	1'b0;
		loadIR	=	1'b0;
		muxMAR  =	1'b0;	
		muxPC	=	1'b0;
		loadPC	=	1'b0;
		loadMAR	=	1'b1;
		loadACC	=	1'b0;
		muxACC	=	1'b0;
		opALU	=	1'b0;
	end
	
always @(posedge clk)
begin
	case (reg_state)
	
	Fetch_1:
	begin
		reg_state=Fetch_2;
		muxMAR	=	1'b0;
		muxPC	=	1'b0;
		loadPC	=	1'b1;
		loadMAR	=	1'b1;
		loadACC =	1'b0;
		mullACC	=	1'b0;

	end
	
	Fetch_2:
	begin
		reg_state = Fetch_3;
		MemRW 	=	1'b0;
		loadMDR	=	1'b1;
		loadPC	=	1'b0;
	end
	
	Fetch_3:
	begin
		reg_state	=	Decode;
		loadIR	=	1'b1;
	end
	
	Decode:
	begin
		muxMAR	=	1'b1;
		loadMAR	=	1'b1;
		loadIR	=	1'b0;
		if (state_done==1'b1)begin
		case (opcode)
			op_add:
				reg_state	=	ExecAdd_1;
			op_or:
				reg_state	=	ExecOr_1;
 			op_load:
				reg_state	=	ExecLoad_1;
 			op_store:
				reg_state	=	ExecStore_1;
 			op_jump:
				reg_state	=	ExecJump;
			op_mull:
				reg_state	=	ExecMull_1;
 			op_jumpz:begin
				if (zflag & op_jumpz==reg_state)
					reg_state	=	ExecJump;
				if (~zflag& op_jumpz==reg_state)
					reg_state	=	Fetch_1;
				end
			default:	reg_state	=	Decode;
		endcase
		end
	end
	ExecAdd_1:
	begin
		reg_state	=	ExecAdd_2;
		MemRW 	= 	1'b0;
		loadMDR = 	1'b1;
	end
	ExecOr_1:
	begin
		reg_state	=	ExecOr_2;
		MemRW	=	1'b0;
		loadMDR	=	1'b1;
	end
	ExecLoad_1:
	begin
		reg_state	=	ExecLoad_2;
		MemRW	=	1'b0;
		loadMDR	=	1'b1;
	end
	ExecStore_1:
	begin
		reg_state	=	Fetch_1;
		MemRW	=	1'b1;
	end
	ExecJump:
	begin
		reg_state	=	Fetch_1;
		muxPC	=	1'b1;
		loadPC	=	1'b1;
	end
	ExecAdd_2:
	begin
		reg_state	=	Fetch_1;
		loadACC	=	1'b1;
		muxACC	=	1'b0;
		opALU	=	1'b1;
	end
	ExecOr_2:
	begin
		reg_state	=	Fetch_1;
		loadACC	=	1'b1;
		muxACC	=	1'b0;
		opALU	=	1'b0;
	end
	ExecLoad_2:
	begin
		reg_state	=	Fetch_1;
		loadACC	=	1'b1;
		muxACC	=	1'b1;
	end
	ExecMull_1:
	begin
		reg_state	= 	ExecMull_2;
		mullACC	=	1'b1;
	end
	ExecMull_2:
	begin
	if (mullDone)
		reg_state=Fetch_1;
	end
	endcase
	
end
endmodule