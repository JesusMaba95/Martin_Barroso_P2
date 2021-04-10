/******************************************************************
* Description
*	32 bits Imm Generator for RISCV
* Version:
*	1.0
* Author:
*	Jesus Martin Barroso
* email:
*	jesus.martin@iteso.mx
* Date:
*	20/02/2021
******************************************************************/
module ImmGen
(   
	input [24:0]  in,
	input [2:0]ImmSel,
   output[31:0] imm
);
localparam I = 3'b000;
localparam S = 3'b001;
localparam B = 3'b010;
localparam J = 3'b011;
localparam U = 3'b100;
reg [31:0] imm_r;

   
   always @ (*)
     begin
		case (ImmSel)
		  I: 
			imm_r = {{21{in[24]}},in[23:18],in[17:14],in[13]};
	     S: 
			imm_r = {{21{in[24]}},in[23:18],in[4:1],in[0]};
		  B: 
			imm_r = {{20{in[24]}},in[0],in[23:18],in[4:1],1'b0};
 		  U: 
			imm_r = {in[24],in[23:18],in[17:14],in[13],in[12:5],12'b0};
		  J:
			imm_r = {{12{in[24]}},in[12:5],in[13],in[23:18],in[17:14],1'b0};
		default:
			imm_r = {{21{in[24]}},in[23:18],in[17:14],in[13]};
		endcase // case(control)
     end
	  assign imm = imm_r;
endmodule
