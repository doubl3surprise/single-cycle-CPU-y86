`include "define.v"
module pc_update(input clk_i,
	input [3:0] icode_i,
	input cnd_i,
	input [63:0] valc_i,
	input [63:0] valm_i,
	input reg [63:0] valp_i,
	output reg [63:0] nw_pc_o);
	always@ (posedge clk_i) begin
		case (icode_i)
			`JXX: begin
				nw_pc_o = (cnd_i) ? valc_i : valp_i;
			end
			`CALL: begin
				nw_pc_o = valc_i;
			end
			`RET: begin
				nw_pc_o = valm_i;
			end
			default: begin
				nw_pc_o = valp_i;
			end
		endcase
	end
endmodule