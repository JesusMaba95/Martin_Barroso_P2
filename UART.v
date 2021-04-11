module UART
(	// Input Ports
	input clk,
	input reset,
	input rx_pin,
	input tx_start,
	input [7:0]tx_data,
	input clear_rx,
	//output ports
	output [7:0]rx_data,
	output rx_data_ready,
	output tx_pin
);
wire [7:0]rx_data_w;
wire tx_start_w;
wire rx_data_ready_w;
wire rx_data_ready_out_w;
wire clk_9600hz;
wire clk_38400hz;
wire clean_ready_en;

assign clean_ready_en = (clear_rx | rx_data_ready_w);
assign rx_data_ready_out_w = clear_rx ? ~(clear_rx): rx_data_ready_w ;
/*
uart_rx_top rx
(
  .clk(clk_38400hz),
  .rst_n(reset),
  .i_Rx_Serial(rx_pin), //data serial 
  .o_Rx_Byte(rx_data_wire), //data
  .o_Rx_DV(data_ready)// data ready INTR
)*/

uart_rx
 #(.
 CLKS_PER_BIT(4)
 )
UART_RX  
  (
   .i_Clock(clk_38400hz),
   .i_Rx_Serial(rx_pin),
   .o_Rx_Byte(rx_data_w),
   .o_Rx_DV  (rx_data_ready_w)
);


uart_tx_top tx
(
  .clk(clk_9600hz),
  .rst_n(reset),
  .i_Tx_DV(tx_start),//start
  .i_Tx_Byte(tx_data),//data input [7:0] 
  //.o_Tx_Active(),
  .o_Tx_Serial(tx_pin)
  //.o_Tx_Done(tx_done)
);

Clocks_Uart	Clocks_Uart_inst (
	.areset ( !reset ),
	.inclk0 ( clk ),
	.c0 ( clk_9600hz ),
	.c1 ( clk_38400hz )
	);
	
Register
#( 
	.N(8)
)
 Rx_data
(
  .clk(clk_38400hz),
  .reset(reset),
  .enable(rx_data_ready_w),
  .DataInput(rx_data_w),
  .DataOutput(rx_data)
  
);
Register
#( 
	.N(1)
)
 Rx_data_ready
(
  .clk(clk_38400hz),
  .reset(reset),
  .enable(clean_ready_en),
  .DataInput(/*clean_ready_en*/rx_data_ready_out_w),
  .DataOutput(rx_data_ready)
  
);

endmodule