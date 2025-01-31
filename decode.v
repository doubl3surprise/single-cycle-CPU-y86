`include "define.v"
module decode(input wire clk_i, rst_n_i,
	input [3:0] icode_i, ra_i, rb_i,
	input wire [63:0] reg_vale_i, reg_valm_i,
	input wire cnd_i,
	output [63:0] vala_o, valb_o);
	reg [63:0] reg_file [14:0];
	reg [3:0] srca, srcb, dste, dstm;
	// initial register file
	initial begin
		reg_file[0] = 64'd0;
		reg_file[1] = 64'd1;
		reg_file[2] = 64'd2;
		reg_file[3] = 64'd3;
		reg_file[4] = 64'd512;
		reg_file[5] = 64'd5;
		reg_file[6] = 64'd6;
		reg_file[7] = 64'd7;
		reg_file[8] = 64'd8;
		reg_file[9] = 64'd9;
		reg_file[10] = 64'd10;
		reg_file[11] = 64'd11;
		reg_file[12] = 64'd12;
		reg_file[13] = 64'd13;
		reg_file[14] = 64'd14;
		reg_file[15] = 64'd15;
	end
	// calculate srcA, srcB, dstE, dstM
	always@ (*) begin
		case (icode_i)
			`HALT: begin
				srca = 4'hf;
				srcb = 4'hf;
				dste = 4'hf;
				dstm = 4'hf;
			end
			`NOP: begin
				srca = 4'hf;
				srcb = 4'hf;
				dste = 4'hf;
				dstm = 4'hf;
			end
			`CMOVXX: begin
				srca = ra_i;
				srcb = rb_i;
				dste = rb_i;
				dstm = 4'hf;
			end
			`IRMOVQ: begin
				srca = 4'hf;
				srcb = rb_i;
				dste = rb_i;
				dstm = 4'hf;
			end
			`RMMOVQ: begin
				srca = ra_i;
				srcb = rb_i;
				dste = 4'hf;
				dstm = 4'hf;
			end
			`MRMOVQ: begin
				srca = ra_i;
				srcb = rb_i;
				dste = rb_i;
				dstm = 4'hf;
			end
			`OPQ: begin
				srca = ra_i;
				srcb = rb_i;
				dste = rb_i;
				dstm = 4'hf;
			end
			`JXX: begin
				srca = 4'hf;
				srcb = 4'hf;
				dste = 4'hf;
				dstm = 4'hf;
			end
			`CALL: begin
				srca = 4'hf;
				srcb = 4'h4;
				dste = 4'h4;
				dstm = 4'hf;
			end
			`RET: begin
				srca = 4'h4;
				srcb = 4'h4;
				dste = 4'h4;
				dstm = 4'hf;
			end
			`PUSHQ: begin
				srca = ra_i;
				srcb = 4'h4;
				dste = 4'h4;
				dstm = 4'hf;
			end
			`POPQ: begin
				srca = 4'h4;
				srcb = 4'h4;
				dste = 4'h4;
				dstm = 4'hf;
			end
			default: begin
				srca = 4'hf;
				srcb = 4'hf;
				dste = 4'hf;
				dstm = 4'hf;
			end
		endcase
	end
	// calculate valA, valB
	assign vala_o = (srca == 4'hf) ? 64'd0 : reg_file[srca];
	assign valb_o = (srcb == 4'hf) ? 64'd0 : reg_file[srcb];
	/*
	always@ (posedge clk_i) begin
		if(dste != 4'hf) begin
			reg_file[dste] <= vale_i;
		end
		if(dstm != 4'hf) begin
			reg_file[dstm] <= valm_i;
		end
	end
	*/
	//restart all register 0
	always@ (posedge clk_i) begin
		if(rst_n_i) begin
			reg_file[0] = 64'd0;
			reg_file[1] = 64'd0;
			reg_file[2] = 64'd0;
			reg_file[3] = 64'd0;
			reg_file[4] = 64'd0;
			reg_file[5] = 64'd0;
			reg_file[6] = 64'd0;
			reg_file[7] = 64'd0;
			reg_file[8] = 64'd0;
			reg_file[9] = 64'd0;
			reg_file[10] = 64'd0;
			reg_file[11] = 64'd0;
			reg_file[12] = 64'd0;
			reg_file[13] = 64'd0;
			reg_file[14] = 64'd0;
		end
	end
endmodule