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

wire [(DATA_WIDTH-1):0]pc_out_w;
wire [(DATA_WIDTH-1):0]new_pc;
wire [(DATA_WIDTH-1):0]pc_plus_4_w;
wire [(DATA_WIDTH-1):0]instruction_w;
wire [(DATA_WIDTH-1):0]ReadData1_w;
wire [(DATA_WIDTH-1):0]ReadData2_w;
wire [(DATA_WIDTH-1):0]ALUResult_w;
wire [(DATA_WIDTH-1):0]imm_w;
wire [(DATA_WIDTH-1):0]AluSrcB_w;
wire [(DATA_WIDTH-1):0]Data_mem_out_w;
wire [(DATA_WIDTH-1):0]WriteData_w;
wire [(DATA_WIDTH-1):0]pc_branch_w;
PC_Register
ProgramCounter
(
	//.clk(clk),
	//.reset(reset),
	//.enable(),
	.NewPC(new_pc),
	.PCValue(pc_out_w)
);

Adder32bits
PC_Adder_Plus_4
(
	.Data0(pc_out_w),
	.Data1(PC_INCREMENT),
	.Result(pc_plus_4_w)
);

Mux_2_1 Pc_mux
(
	//.sel(),
	.In0(pc_plus_4_w),
	.In1(pc_branch_w),
	.Output(new_pc)

);

ProgramMemory
#(
	.MEMORY_DEPTH(37)
)
ROMProgramMemory
(
	.Address(pc_out_w),
	.Instruction(instruction_w)
);

RegisterFile
Register_File
(
	//.clk(clk),
	//.reset(reset),
	//.RegWrite(),
	.WriteRegister(instruction_w[11:7]),
	.ReadRegister1(instruction_w[19:15]),
	.ReadRegister2(instruction_w[24:20]),
	.WriteData(WriteData_w),
	.ReadData1(ReadData1_w),
	.ReadData2(ReadData2_w)

);

ALU
ALU_i 
(
	//.ALUOperation(),
	.A(ReadData1_w),
	.B(AluSrcB_w),
	//.Zero(),
	.ALUResult(ALUResult_w)
);

ImmGen ImmGen_i 
(   
	.in(instruction_w[31:7]),
	//.ImmSel(ImmSel_w),
   .imm(imm_w)
);

Adder32bits
Branch_Adder
(
	.Data0(pc_out_w),
	.Data1(imm_w),
	.Result(pc_branch_w)
);

Mux_2_1 Mux_AdrSrc
(
	//.sel(),
	.In0(ReadData2_w),
	.In1(imm_w),
	.Output(AluSrcB_w)

);


DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(32)
)
DATA_MEM
(
	.WriteData(ReadData2_w),
	.Address(ALUResult_w),
	//.MemWrite(),
	//.MemRead(),
	//.clk(clk),
	.ReadData(Data_mem_out_w)
);

Mux_2_1 WriteData_mux
(
	//.sel(),
	.In0(ALUResult_w),
	.In1(Data_mem_out_w),
	.Output(WriteData_w)

);

endmodule