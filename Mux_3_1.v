/******************************************************************
* Description
*	Mux 3 to 1
* Version:
*	1.0
* Author:
*	Jesus Martin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	20/02/2021
******************************************************************/
module Mux_3_1
#(
	parameter NBits=32
)
(
	input [1:0]sel,
	input [NBits-1:0] In0,
	input [NBits-1:0] In1,
	input [NBits-1:0] In2,
	
	output reg [NBits-1:0] Output

);

   	always@(*) begin
		case(sel)
			2'b00: Output = In0;
			2'b01: Output = In1;
			2'b10: Output = In2;
			default: Output = In0;
		endcase
	end
	
endmodule