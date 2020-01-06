//////////////////////////
// Datapath module
//
//////////////////////
module datapath(
           clk,
           rst,
           muxPC,	
           muxMAR,
           muxACC,
           loadMAR,
           loadPC,
           loadACC,
           loadMDR,
           loadIR,
           opALU,
           zflag,
           opcode,
           MemAddr,
           MemD,
           MemQ,
		   mullACC,
		   mullDone
			);

          input clk;
          input  rst;
          input  muxPC;
          input  muxMAR;
          input  muxACC;
          input  loadMAR;
          input  loadPC;
          input  loadACC;
          input  loadMDR;
          input  loadIR;
          input  opALU; //ALU selection
		  input  mullACC;
		  
          output   zflag;
		  output mullDone;
          output   [7:0]opcode;
          output   [7:0]MemAddr;
          output   [15:0]MemD;
          input   [15:0]MemQ;

reg  [7:0]PC_next;
wire  [15:0]IR_next;  
reg  [15:0]ACC_next;  
wire  [15:0]MDR_next;  
reg  [7:0]MAR_next;  
reg zflag_next;

wire  [7:0]PC_reg;
wire  [15:0]IR_reg;  
wire  [15:0]ACC_reg;  
wire  [15:0]MDR_reg;  
wire  [7:0]MAR_reg;  
wire zflag;
wire [15:0] ACC_mulled;

wire  [15:0]ALU_out;

multiplier m1(ACC_reg [7:0], 8'b010, ACC_mulled, mullACC, clk, mullDone);
assign zflag=zflag_next;
  //defines behavior of Program counter
//only changes if load program counter variable is true
// sets the next program counter as either the branch address (IR_reg), or increments the PC by 1
//overwrites this with 0 on reset signal.
always@(posedge clk & loadPC) begin
	PC_next = muxPC?(IR_reg):(PC_reg+1'b1);
	if (rst) PC_next=0;
end

//IR Implementation
//if loadIR is positive at the positive clock edge, 
//we load the dmr register into ir
assign	IR_next =loadIR?MDR_reg:IR_reg;
	
//ACC implementation
//only change if load ACC is true
//the next acc is either the MDR register, or the ALU output.
always@(posedge clk)
begin
	if(loadACC)
		ACC_next <= muxACC?MDR_reg:ALU_out;
	else if (mullACC)
		ACC_next <= ACC_mulled;//----------------------------------------------------------------------------
end

always@(posedge rst)
		ACC_next<=1'b0;
//MDR_next implementation
assign MDR_next=rst?16'b0:loadMDR?MemQ:MDR_reg;
//MAR_Next implementation
//if loadMAR is true on a clock edge
//our next mar value gets either the pc reg, or the jump location
always@(posedge clk & loadMAR)begin
	MAR_next = muxMAR?PC_reg:IR_reg[15:8];
	if (rst)
	MAR_next = 8'b0;
	end
	
//zflag next implementation
//sets to true if acc is equal to 0
//else it's false
always@(posedge clk)begin
	if (ACC_reg==0) zflag_next=1'b1;
	else zflag_next=1'b0;
	if (rst==1)
	zflag_next=1'b0;
	end
	
//one instance of ALU
alu data_alu(MDR_reg, ACC_reg, opALU, ALU_out);

assign opcode = IR_reg [7:0];//----------------------------------------------------------------------------------------------------------------------
assign MemAddr = MAR_reg;
assign MemD = ACC_reg;

// one instance of register.
registers update_all(
           clk,
           rst,
           PC_reg, 
           PC_next,
           IR_reg,  
           IR_next,  
           ACC_reg,  
           ACC_next,  
           MDR_reg,  
           MDR_next,  
           MAR_reg,  
           MAR_next,  
           zflag_reg,
           zflag_next
		   );

endmodule
