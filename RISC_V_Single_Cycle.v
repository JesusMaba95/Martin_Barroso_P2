/******************************************************************
* Description
*	RISCV TOP MODULE
* Author:
*	Jesus MArtin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	20/02/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter DATA_WIDTH = 32
)
(
	input clk,
	input reset,
	input rx,
	//output clk_out,
	//output data_ready_out,
	//output clear_rx,
	//output ReadData,
	output tx
);

wire[(DATA_WIDTH-1):0]ReadData_w;
wire[(DATA_WIDTH-1):0]Addres_w;
wire[(DATA_WIDTH-1):0]WriteData_w;
wire Mem_Write_w;

wire[(DATA_WIDTH-1):0]Ctrl2RAM_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2Rx_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2Rx_ready_ReadData_w;
wire[(DATA_WIDTH-1):0]Ctrl2RAM_Addres_w;
wire[(DATA_WIDTH-1):0]CtrlWriteData_w;
wire Ctrl2RAM_Mem_Write_w;
wire Ctrl2Tx_enable_w;
wire Ctrl2Tx_data_enable_w;
wire Ctrl2Clean_rx_enable_w;
wire rx_data_ready_w;
wire[(DATA_WIDTH-1):0]clean_rx_w;
wire clk_1hz;
wire [7:0]rx_data_w;
wire [(DATA_WIDTH-1):0]tx_start_w;
wire [(DATA_WIDTH-1):0]tx_data_w;
	
	
assign clk_out = clk_1hz;
//assign data_ready_out = Ctrl2Rx_ready_ReadData_w[0];
//assign clear_rx = !clean_rx_w[0];
//assign ReadData = ReadData_w[0];
Clock_Divider clk_divider
(
	// Input Ports
	.clk_in(clk),
	.rst(reset),
	.en(1'b1),
	// Output Ports
	.clk_out(clk_1hz)
);

CORE CORE_i
(
	.clk(clk_1hz),
	.reset(reset),
	.ReadData(ReadData_w),
	.Address(Addres_w),
	.WriteData(WriteData_w),
	.MemWrite(Mem_Write_w)
);
MemControl X
(
	. Address(Addres_w),
	.WriteData_in(WriteData_w),
	.MemWrite(Mem_Write_w),
	.ReadData(ReadData_w),
	.RAM_Address(Ctrl2RAM_Addres_w),
	.WriteData_out(CtrlWriteData_w),
	.RAM_MemWrite(Ctrl2RAM_Mem_Write_w),
	.Tx_MemWrite(Ctrl2Tx_enable_w),
	.Tx_data_Memwrite(Ctrl2Tx_data_enable_w),
	.Clean_rx_Memwrite(Ctrl2Clean_rx_enable_w),
	.RAM_ReadData(Ctrl2RAM_ReadData_w),
	.Rx_ReadData(Ctrl2Rx_ReadData_w),
	.Rx_ready_ReadData(Ctrl2Rx_ready_ReadData_w)
);

Register tx_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Tx_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(tx_start_w)
  
);
Register tx_data_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Tx_data_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(tx_data_w)
  
);
Register rx_ready_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(1'b1),
  .DataInput({31'b0000_0000_0000_0000_0000_0000_0000_000,rx_data_ready_w}), 
  .DataOutput(Ctrl2Rx_ready_ReadData_w)
  
);
Register rx_data_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(1'b1),
  .DataInput({24'b0000_0000_0000_0000_0000_0000,rx_data_w}),
  .DataOutput(Ctrl2Rx_ReadData_w)
  
);
Register clean_rx_i
(
  .clk(clk_1hz),
  .reset(reset),
  .enable(Ctrl2Clean_rx_enable_w),
  .DataInput(CtrlWriteData_w),
  .DataOutput(clean_rx_w)
  
);
/*
Instruction_Data_Memory ID_MEM
(
	.Address(Ctrl2RAM_Addres_w),
	.WriteData(CtrlWriteData_w),
	.MemWrite(Ctrl2RAM_Mem_Write_w),
	.clk(clk_1hz),
	.ReadData(Ctrl2RAM_ReadData_w)
);*/
DataMemory
#(
	.DATA_WIDTH(32),
	.MEMORY_DEPTH(32)
)
DATA_MEM
(
	.WriteData(CtrlWriteData_w),
	.Address(Ctrl2RAM_Addres_w),
	.MemWrite(Ctrl2RAM_Mem_Write_w),
	.MemRead(1'b1),
	.clk(clk_1hz),
	.ReadData(Ctrl2RAM_ReadData_w)
);
UART Uart_i
(	// Input Ports
	.clk(clk),
	.reset(reset),
	.rx_pin(rx),
	.tx_start(tx_start_w[0]),
	.tx_data(tx_data_w[7:0]),
	.clear_rx(clean_rx_w[0]),
	.rx_data(rx_data_w),
   .rx_data_ready(rx_data_ready_w),
	.tx_pin(tx)

);
endmodule