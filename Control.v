/******************************************************************
* Description
*	This is a code for FSM _Control of RISCV_MULTICYCLE
*	procesor.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Modified by : 
	* 	Jesus Martin Barroso  ---> RISCV ARCHITECTURE FSM
* Date:
*	20/02/2021
******************************************************************/
module Control
(
	input [6:0] opcode,
	input [2:0] Funct3,
	input [6:0] Funct7,
	input zero,
	//output Pc_or_Rs1, para jal pc, para jalr imm
	output Branch,
	output PcUpdate,
	//output MemRead,
	output [1:0]Result_Source,
	output [3:0]ALUOp,
	output MemWrite,
	output ALUSrcB,
	output ALUSrcA,
	output RegWrite,
	output /*reg*/ [2:0] ImmSrc
	
	//output Jump
);
localparam R_type_ARITH = 7'h33;//ADD,SUB,AND,OR,SLL,SLT,SLTU,XOR,SRL,SRA
localparam I_type_ARITH = 7'h13;//ADDI,SLLI,SLTI,SLTIU,XORI,SRLI,SRALI,ORI,ANDI
localparam I_type_LW    = 7'h03;//LW
localparam I_type_JALR  = 7'h67;//JALR
localparam S_type_SW    = 7'h23;//SW
localparam J_type       = 7'h6f;//JAL
localparam B_type       = 7'h63;//BEQ,BNE
localparam U_type       = 7'h17;//AUIPC


reg [10:0] ControlValues;
reg [3:0] AluOp_r;
reg branch_r;

always@(opcode,Funct3,Funct7,zero) begin
	case(opcode)												
		R_type_ARITH:         ControlValues= 11'b0_1_XXX_0_0_01_0_0;
		I_type_ARITH:         ControlValues= 11'b0_1_000_1_0_01_0_0;
		I_type_LW:            ControlValues= 11'b0_1_000_1_0_10_0_0;
		I_type_JALR:          ControlValues= 11'b0_0_000_1_1_XX_0_0;
		S_type_SW:            ControlValues= 11'b0_0_001_1_1_XX_0_0;
		J_type:               ControlValues= 11'b0_1_011_X_0_00_0_1;
		B_type:               ControlValues= 11'b0_0_010_0_0_XX_1_0;
		U_type:               ControlValues= 11'b1_1_100_1_0_01_0_0;

		
		
		default:
			ControlValues= 11'b0000000000;
	endcase
	if(opcode == B_type) begin
		if (Funct3 == 3'b000)begin
		  branch_r = zero;
		end else if (Funct3 == 3'b001) begin
		  branch_r = !zero;
		end else begin
		  branch_r = 1'b0;
		end
	end else begin
	  branch_r = 1'b0;
	end
	
	if(opcode == R_type_ARITH) begin
		case(Funct7)
			7'b0000000: // ADD
				AluOp_r = 3'b010;
			7'b0000001: // MUL
			   AluOp_r = 3'b111;
			7'b0100000: // sub
			   AluOp_r = 3'b011;
			default:
				AluOp_r = 3'b010;
		endcase
	end else if (opcode == I_type_ARITH) begin
		case(Funct3)
			3'b000:
				AluOp_r   = 3'b010;
			3'b001:
				AluOp_r   = 3'b100;
			3'b010:
				AluOp_r   = 3'b110;
			3'b101:
				AluOp_r   = 3'b101;
			default:
				AluOp_r   = 3'b010;
		endcase	
	end else begin
	  AluOp_r = 3'b010;
	end
end

assign ALUSrcA       = ControlValues[10];	
assign RegWrite      = ControlValues[9];
assign ImmSrc        = ControlValues[8:6];
assign ALUSrcB        = ControlValues[5];
assign MemWrite      = ControlValues[4];
assign Result_Source = ControlValues[3:2];
assign PcUpdate      = ControlValues[0];
assign Branch        = branch_r;
assign ALUOp         = AluOp_r;

endmodule


