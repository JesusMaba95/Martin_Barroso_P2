/******************************************************************
* Description
*	RISCV CORE MODULE
* Author:
*	Jesus MArtin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	10/04/2021
******************************************************************/

module CORE
#(
	parameter MEMORY_DEPTH = 32,
	parameter PC_INCREMENT = 4,
	parameter DATA_WIDTH = 32
)
(
	input clk,
	input reset,
	input [(DATA_WIDTH-1):0]ReadData,
	output MemWrite,
	output [(DATA_WIDTH-1):0]Address,
	output [(DATA_WIDTH-1):0]WriteData
);

wire [(DATA_WIDTH-1):0]pc_out_w;
wire [(DATA_WIDTH-1):0]new_pc;
wire [(DATA_WIDTH-1):0]pc_plus_4_w;
wire [(DATA_WIDTH-1):0]instruction_w;
wire [(DATA_WIDTH-1):0]ReadData1_w;
wire [(DATA_WIDTH-1):0]ReadData2_w;
wire [(DATA_WIDTH-1):0]ALUResult_w;
wire [(DATA_WIDTH-1):0]imm_w;
wire [(DATA_WIDTH-1):0]SrcA_w;
wire [(DATA_WIDTH-1):0]SrcB_w;
//wire [(DATA_WIDTH-1):0]Data_mem_out_w;
wire [(DATA_WIDTH-1):0]WriteData_w;
wire [(DATA_WIDTH-1):0]pc_branch_w;
wire [(DATA_WIDTH-1):0]Pc_Target_src_w;
wire zero_w;
wire branch_w;
wire PcUpdate_w;
wire [1:0] ResultSrc_w;
wire [3:0] AluOp_w;
//wire MemWrite_w;
wire AluSrcB_w;
wire AluSrcA_w;
wire RegWrite_w;
wire Pc_Target_Sel;
wire [2:0]ImmSel_w;


assign Address = ALUResult_w;
assign WriteData = ReadData2_w;

PC_Register
ProgramCounter
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
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
	.sel(branch_w | PcUpdate_w),
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
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_w),
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
	.ALUOperation(AluOp_w),
	.A(SrcA_w),
	.B(SrcB_w),
	.Zero(zero_w),
	.ALUResult(ALUResult_w)
);

ImmGen ImmGen_i 
(   
	.in(instruction_w[31:7]),
	.ImmSel(ImmSel_w),
   .imm(imm_w)
);

Adder32bits
Branch_Adder
(
	.Data0(Pc_Target_src_w),
	.Data1(imm_w),
	.Result(pc_branch_w)
);

Mux_2_1 Mux_SrcB
(
	.sel(AluSrcB_w),
	.In0(ReadData2_w),
	.In1(imm_w),
	.Output(SrcB_w)

);

Mux_2_1 Mux_SrcA
(
	.sel(AluSrcA_w),
	.In0(ReadData1_w),
	.In1(pc_out_w),
	.Output(SrcA_w)

);

/*
DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(32)
)
DATA_MEM
(
	.WriteData(ReadData2_w),
	.Address(ALUResult_w),--
	.MemWrite(MemWrite_w),--
	.MemRead(1'b1),
	.clk(clk),
	.ReadData(Data_mem_out_w)--
);
*/
Mux_3_1 WriteData_mux
(
	.sel(ResultSrc_w),
	.In2(ReadData),
	.In1(ALUResult_w),
	.In0(pc_plus_4_w),
	.Output(WriteData_w)

);
Control Control_i
(
	.opcode(instruction_w[6:0]),
	.Funct3(instruction_w[14:12]),
	.Funct7(instruction_w[31:25]),
	.zero(zero_w),
	.Branch(branch_w),
	.PcUpdate(PcUpdate_w),
	//output MemRead,
	.Result_Source(ResultSrc_w),
	.ALUOp(AluOp_w),
	.MemWrite(MemWrite),
	.ALUSrcA(AluSrcA_w),
	.ALUSrcB(AluSrcB_w),
	.RegWrite(RegWrite_w),
	.ImmSrc(ImmSel_w),
	.Pc_Target_Src(Pc_Target_Sel)

);

Mux_2_1 PC_Target_Src_i
(
	.sel(Pc_Target_Sel),
	.In0(pc_out_w),
	.In1(ReadData1_w),
	.Output(Pc_Target_src_w)

);

endmodule