/******************************************************************
* Description
*	Tb for RISCV 
* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Jesus MArtin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	27/02/2021

******************************************************************/

module RISCV_TB;
reg clk = 0;
reg rst = 1;
//wire[31:0] /*tx_data_w,*/tx_w/*,clean_rx_w*/;
RISC_V_Single_Cycle
DUT
(

	.clk(clk),
	.reset(rst)
	//.rx_ready(32'd1),
	//.rx_data(32'd15),
	//.tx_data(tx_data_w),
	//.clean_rx(clean_rx_w),
	//.tx(tx_w)

);
/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#5 rst = 0;
	#5 rst = 1;
end


endmodule