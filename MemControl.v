module MemControl
#(
	parameter DATA_WIDTH=32
)
(


	//CORE Interface
	input [(DATA_WIDTH-1):0] Address,
	input [(DATA_WIDTH-1):0] WriteData_in,
	input MemWrite,

	output [(DATA_WIDTH-1):0] ReadData,
	
	//ID MEM Interface
	output [(DATA_WIDTH-1):0]RAM_Address,
	output [(DATA_WIDTH-1):0]WriteData_out,
	output RAM_MemWrite,
	output Tx_MemWrite,
	output Tx_data_Memwrite,
	output Clean_rx_Memwrite,
	
	input [(DATA_WIDTH-1):0]RAM_ReadData,
	input [(DATA_WIDTH-1):0]Rx_ReadData,
	input [(DATA_WIDTH-1):0]Rx_ready_ReadData
	

	
);

localparam TX_ADDR          = 32'h10010024;
localparam TX_DATA_ADDR     = 32'h10010028;
localparam RX_READY_ADDR    = 32'h1001002C;
localparam RX_DATA_ADDR     = 32'h10010030;
localparam CLEAN_RX_ADDR    = 32'h10010034;


reg RamMem;
reg tx;
reg tx_data;
reg rx_ready;
reg rx_data;
reg clean_rx;
reg [31:0]ReadData_r;

always@(*) begin
  RamMem = ( (Address != TX_ADDR) & (Address != TX_DATA_ADDR) & (Address != RX_READY_ADDR) & (Address != RX_DATA_ADDR) & (Address != CLEAN_RX_ADDR) ) ? 1'b1 : 1'b0;
  tx = (Address == TX_ADDR) ? 1'b1 : 1'b0;
  tx_data =  (Address == TX_DATA_ADDR) ? 1'b1 : 1'b0;
  rx_ready = (Address == RX_READY_ADDR) ? 1'b1 : 1'b0;
  rx_data = (Address == RX_DATA_ADDR) ? 1'b1 : 1'b0;
  clean_rx = (Address == CLEAN_RX_ADDR) ? 1'b1 : 1'b0;
  if(RamMem)
	  ReadData_r = RAM_ReadData;
  else if(rx_ready)
     ReadData_r = Rx_ready_ReadData;
  else if (rx_data)
	  ReadData_r = Rx_ReadData;
  else
     ReadData_r = RAM_ReadData;
end
//ID_MEM
assign  RAM_Address     = (RamMem) ? Address : 32'h0000_0000;
assign  WriteData_out      = WriteData_in ;
assign  RAM_MemWrite    = (RamMem) ? MemWrite    : 1'b0;
//TX_ADDR
assign Tx_MemWrite = (tx) ? MemWrite : 1'b0;
//Tx_DATA
assign Tx_data_Memwrite = (tx_data) ? MemWrite: 1'b0;
//CLEAN_RX
assign Clean_rx_Memwrite = (clean_rx) ? MemWrite: 1'b0;
assign ReadData = ReadData_r;



endmodule 