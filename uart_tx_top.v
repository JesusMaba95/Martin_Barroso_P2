module uart_tx_top
(
input       clk,
input       rst_n,
input       i_Tx_DV,
input [7:0] i_Tx_Byte, 

output      o_Tx_Active,
output      o_Tx_Serial,
output      o_Tx_Done
);

//wire
wire wone_shot;
// (10000)/(110) = 91
// (9600)/(9600) = 1
uart_tx
 #(.
 CLKS_PER_BIT(1)
 )
UART_TX  
  (
   .clk(clk),
   .Tx_Start(wone_shot),
   .Tx_Byte(i_Tx_Byte), 
	
   .Tx_Active(o_Tx_Active),
   .Tx_Serial(o_Tx_Serial),
   .Tx_Done(o_Tx_Done)
);

One_Shot One_shot_button
(
	// Input Ports
	.clk(clk),
	.reset(rst_n),
	.Start(i_Tx_DV),

	// Output Ports
	.Shot(wone_shot)
);


endmodule