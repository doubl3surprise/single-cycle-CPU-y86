`include "define.v"
module fetch (input wire [63:0] pc_i, 
	output wire [3:0] icode_o, ifun_o, ra_o, rb_o, 
	output wire [63:0] valc_o, valp_o,
	output wire instr_valid_o, mem_error_o);
	
	reg [7:0] ins_mem [1023:0];
	// initaial instruction memory
	integer i;
	initial begin
		//irmovq $0x8 %r8
		ins_mem[0] = 8'h30; ins_mem[1] = 8'hf8; ins_mem[2] = 8'h08;
		ins_mem[3] = 8'h00; ins_mem[4] = 8'h00; ins_mem[5] = 8'h00;
		ins_mem[6] = 8'h00; ins_mem[7] = 8'h00; ins_mem[8] = 8'h00;
		ins_mem[9] = 8'h00;
		//irmovq $0x21 %rbx
		ins_mem[10] = 8'h30; ins_mem[11] = 8'hf3; ins_mem[12] = 8'h15;
		ins_mem[13] = 8'h00; ins_mem[14] = 8'h00; ins_mem[15] = 8'h00;
		ins_mem[16] = 8'h00; ins_mem[17] = 8'h00; ins_mem[18] = 8'h00;
		ins_mem[19] = 8'h00;
		//halt
		ins_mem[20] = 8'h00;
		//nop
		ins_mem[21] = 8'h10;
		//rrmovq
		ins_mem[22] = 8'h20; ins_mem[23] = 8'h13;
		//rmmovq
		ins_mem[24] = 8'h40; ins_mem[25] = 8'h2d; ins_mem[26] = 8'h15;
		ins_mem[27] = 8'h00; ins_mem[28] = 8'h00; ins_mem[29] = 8'h00;
		ins_mem[30] = 8'h00; ins_mem[31] = 8'h00; ins_mem[32] = 8'h00;
		ins_mem[33] = 8'h00;
		//mrmovq
		ins_mem[34] = 8'h50; ins_mem[35] = 8'h2d; ins_mem[36] = 8'h15;
		ins_mem[37] = 8'h00; ins_mem[38] = 8'h00; ins_mem[39] = 8'h00;
		ins_mem[40] = 8'h00; ins_mem[41] = 8'h00; ins_mem[42] = 8'h00;
		ins_mem[43] = 8'h00;
		//opq / add %r9 %r7
		ins_mem[44] = 8'h60; ins_mem[45] = 8'h97;
		//opq / sub %r8 %r10
		ins_mem[46] = 8'h61; ins_mem[47] = 8'h97;
		//opq / and %r14 %rax
		ins_mem[48] = 8'h62; ins_mem[49] = 8'he1;
		//opq / xor %r13 %r12
		ins_mem[50] = 8'h63; ins_mem[51] = 8'hdb;
		//jxx / jmp 71
		ins_mem[52] = 8'h70; ins_mem[53] = 8'h11; ins_mem[54] = 8'h01;
		ins_mem[55] = 8'h00; ins_mem[56] = 8'h01; ins_mem[57] = 8'h00;
		ins_mem[58] = 8'h00; ins_mem[59] = 8'h00; ins_mem[60] = 8'h00;
		//call 1
		ins_mem[61] = 8'h80; ins_mem[62] = 8'h01; ins_mem[63] = 8'h00;
		ins_mem[64] = 8'h00; ins_mem[65] = 8'h00; ins_mem[66] = 8'h00;
		ins_mem[67] = 8'h00; ins_mem[68] = 8'h00; ins_mem[69] = 8'h00;
		//ret 
		ins_mem[70] = 8'h90;
		//pushq %rax
		ins_mem[71] = 8'ha0; ins_mem[72] = 8'h1f;
		//popq %rdx
		ins_mem[73] = 8'hb0; ins_mem[74] = 8'h2f; 

		for(i = 75; i < 1024; i = i + 1) begin
			ins_mem[i] = 8'hcc;
		end
	end
	// split instruction
	wire [79:0] nw_instr;
	wire valid_reg, valid_valc;
	
	assign nw_instr = {ins_mem[pc_i + 9],
		ins_mem[pc_i + 8], ins_mem[pc_i + 7],
		ins_mem[pc_i + 6], ins_mem[pc_i + 5],
		ins_mem[pc_i + 4], ins_mem[pc_i + 3],
		ins_mem[pc_i + 2], ins_mem[pc_i + 1],
		ins_mem[pc_i + 0]};
	assign mem_error_o = (pc_i >= 1023);
	assign instr_valid_o = (nw_instr[7:4] <= 4'hb);
	assign icode_o = nw_instr[7:4];
	assign ifun_o = nw_instr[3:0];
	
	assign valid_reg = (icode_o == `IRMOVQ) | (icode_o == `RMMOVQ) 
		| (icode_o == `MRMOVQ) | (icode_o == `OPQ)| (icode_o == `CMOVXX) 
		| (icode_o == `PUSHQ) | (icode_o == `POPQ);
	assign valid_valc = ((icode_o == `IRMOVQ) | (icode_o == `RMMOVQ) 
		|(icode_o == `MRMOVQ) | (icode_o == `JXX) | (icode_o == `CALL));
	
	assign ra_o = valid_reg ? nw_instr[15:12] : 4'hf;
	assign rb_o = valid_reg ? nw_instr[11:8] : 4'hf;
	assign valc_o = valid_valc ? (valid_reg ? nw_instr[79:16] : nw_instr[71:8]) : 64'd0;
	assign valp_o = pc_i + 1 + valid_reg + valid_valc * 8;

endmodule

