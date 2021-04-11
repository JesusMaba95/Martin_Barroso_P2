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
	output [(DATA_WIDTH-1):0]ID_Address,
	output [(DATA_WIDTH-1):0]WriteData_out,
	output ID_MemWrite,
	output Tx_MemWrite,
	output Tx_data_Memwrite,
	output Clean_rx_Memwrite,
	
	input [(DATA_WIDTH-1):0]ID_ReadData,
	input [(DATA_WIDTH-1):0]Rx_ReadData,
	input [(DATA_WIDTH-1):0]Rx_ready_ReadData
	
	/*
	//GPIO Interface
	//output [(DATA_WIDTH-1):0]GPIO_Address,
	output [(DATA_WIDTH-1):0]GPIO_WriteData,
	output GPIO_MemWrite,
	input [(DATA_WIDTH-1):0]GPIO_ReadData
	*/
	
);
//localparam GPIO_IN_ADDR   = 32'h10010028;
//localparam GPIO_OUT_ADDR  = 32'h10010024;
localparam TX_ADDR          = 32'h10010024;
localparam TX_DATA_ADDR     = 32'h10010028;
localparam RX_READY_ADDR    = 32'h1001002C;
localparam RX_DATA_ADDR     = 32'h10010030;
localparam CLEAN_RX_ADDR    = 32'h10010034;


reg IdMem;
reg tx;
reg tx_data;
reg rx_ready;
reg rx_data;
reg clean_rx;
reg [31:0]ReadData_r;

always@(*) begin
  IdMem = ( (Address != TX_ADDR) & (Address != TX_DATA_ADDR) & (Address != RX_READY_ADDR) & (Address != RX_DATA_ADDR) & (Address != CLEAN_RX_ADDR) ) ? 1'b1 : 1'b0;
  tx = (Address == TX_ADDR) ? 1'b1 : 1'b0;
  tx_data =  (Address == TX_DATA_ADDR) ? 1'b1 : 1'b0;
  rx_ready = (Address == RX_READY_ADDR) ? 1'b1 : 1'b0;
  rx_data = (Address == RX_DATA_ADDR) ? 1'b1 : 1'b0;
  clean_rx = (Address == CLEAN_RX_ADDR) ? 1'b1 : 1'b0;
  if(IdMem)
	  ReadData_r = ID_ReadData;
  else if(rx_ready)
     ReadData_r = Rx_ready_ReadData;
  else if (rx_data)
	  ReadData_r = Rx_ReadData;
  else
     ReadData_r = ID_ReadData;
end
//ID_MEM
assign  ID_Address     = (IdMem) ? Address : 32'h0000_0000;
assign  WriteData_out      = WriteData_in ;
assign  ID_MemWrite    = (IdMem) ? MemWrite    : 1'b0;
//TX_ADDR
assign Tx_MemWrite = (tx) ? MemWrite : 1'b0;
//Tx_DATA
assign Tx_data_Memwrite = (tx_data) ? MemWrite: 1'b0;
//CLEAN_RX
assign Clean_rx_Memwrite = (clean_rx) ? MemWrite: 1'b0;
assign ReadData = ReadData_r;

//assign  GPIO_WriteData = WriteData;
//assign  GPIO_MemWrite  = (GPIO_or_IdMem)  ? MemWrite    : 1'b0;



endmodule 