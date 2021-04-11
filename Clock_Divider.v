/********************************************************
*Nombre del Modulo: Clock_Divider
*Descripcion:
*	Divisor de frecuencia
*Autor: Jesus Martin Barroso
*Entradas:
*	clk  1hz
*  rst
*  en
*Salidas:
*	clk_out 
*Version: 1.0
*Fecha: 30/09/2020
*Comentarios:
*	Con parametros width == 1 y divisor ==1 clk_out= 0.5(clk_in)hz
*
********************************************************/
 module Clock_Divider
#(
	parameter width = 26, divisor = 25000000
	
)
(
	// Input Ports
	input clk_in,
	input rst,
	input en,
	// Output Ports
	output reg clk_out
);
reg [width-1:0] counter;

always@(posedge clk_in or negedge rst) begin
	if(rst == 1'b0) begin
		clk_out <= 1'b0;
		counter <= {width{1'b0}};
		
	end else begin
		if(en)begin
			if(counter == (divisor-1'b1)) begin
				counter <= {width{1'b0}};
				clk_out <= ~clk_out;
			end else begin
				counter <= counter + 1'b1;
			end
		end
	end
end

endmodule
