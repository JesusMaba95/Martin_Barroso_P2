/******************************************************************
* Description
*	Mux 2 to 1
* Version:
*	1.0
* Author:
*	Jesus Martin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	20/02/2021
******************************************************************/
module Mux_2_1
#(
	parameter NBits=32
)
(
	input sel,
	input [NBits-1:0] In0,
	input [NBits-1:0] In1,
	
	output[NBits-1:0] Output

);

   assign Output = sel ? In1 : In0;

endmodule
