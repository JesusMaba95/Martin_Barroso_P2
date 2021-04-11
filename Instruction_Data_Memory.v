module Instruction_Data_Memory
#(
	parameter INSTRUCTION_MEMORY_DEPTH=32,
	parameter DATA_MEMORY_DEPTH=32,
	parameter DATA_WIDTH=32
)
(
	input [(DATA_WIDTH-1):0] Address,
	input [(DATA_WIDTH-1):0] WriteData,
	input MemWrite,
	input clk,
	output [(DATA_WIDTH-1):0] ReadData
);

wire [(DATA_WIDTH-1):0] wRead_Data_Mux;
wire [(DATA_WIDTH-1):0] wRead_Instruction_Mux;


ProgramMemory
#(
	.MEMORY_DEPTH(37),
	.DATA_WIDTH(DATA_WIDTH)
)
Instruction_Memory
(
	//.Address(Address),
	//.Instruction(wRead_Instruction_Mux)
);
DataMemory
#(
	.DATA_WIDTH(DATA_WIDTH),
	.MEMORY_DEPTH(DATA_MEMORY_DEPTH)
)
Data_Memory_i
(
	.WriteData(WriteData),
	.Address(Address),
	.MemWrite(MemWrite),
	.MemRead(1'b1),
	.clk(clk),
	.ReadData(wRead_Data_Mux)
);

assign ReadData = Address[22] ? wRead_Instruction_Mux : wRead_Data_Mux;

endmodule 