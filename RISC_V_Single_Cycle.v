/******************************************************************
* Description
*	RISCV TOP MODULE
* Author:
*	Jesus MArtin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	10/04/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter MEMORY_DEPTH = 32,
	parameter PC_INCREMENT = 4,
	parameter DATA_WIDTH = 32
)
(
	input clk,
	input reset
);
wire [(DATA_WIDTH-1):0]ReadData_w;
wire [(DATA_WIDTH-1):0]Address_w;
wire [(DATA_WIDTH-1):0]WriteData_w;
wire MemWrite_w;




CORE
#(
	.MEMORY_DEPTH(32),
	.PC_INCREMENT(4),
	.DATA_WIDTH(32)
)
Core_i
(
	.clk(clk),
	.reset(reset),
	.ReadData(ReadData_w),
	.MemWrite(MemWrite_w),
	.Address(Address_w),
	.WriteData(WriteData_w)
);


DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(32)
)
DATA_MEM
(
	.WriteData(WriteData_w),
	.Address(Address_w),
	.MemWrite(MemWrite_w),
	.MemRead(1'b1),
	.clk(clk),
	.ReadData(ReadData_w)
);


endmodule