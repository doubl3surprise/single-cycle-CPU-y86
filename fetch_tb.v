`timescale 10ps/1ps
`include "define.v"

module fetch_tb;
	reg [63:0] pc;
	wire [63:0] nw_pc;
	wire [3:0] icode, ifun, ra, rb;
	wire [63:0] vala, valb, valc, vale, valm, valp, reg_vale, reg_valm;
	wire instr_vaild, imem_error;
	reg clk, rst;
	wire cnd, dmem_error, stat;
	fetch fetch_tb(.pc_i(pc), 
		.icode_o(icode), 
		.ifun_o(ifun),
		.ra_o(ra), 
		.rb_o(rb), 
		.valc_o(valc), 
		.valp_o(valp),
		.instr_valid_o(instr_valid), 
		.mem_error_o(imem_error));
	
	decode decode_tb(.clk_i(clk),
		.rst_n_i(rst),
		.icode_i(icode),
		.ra_i(ra),
		.rb_i(rb),
		.reg_vale_i(reg_vale),
		.reg_valm_i(reg_valm),
		.cnd_i(cnd),
		.vala_o(vala),
		.valb_o(valb));

	execute execute_tb(.clk_i(clk),
		.rst_n_i(rst),
		.icode_i(icode),
		.ifun_i(ifun),
		.vala_i(vala),
		.valb_i(valb),
		.valc_i(valc),
		.vale_o(vale),
		.cnd_o(cnd));
	
	mem_acce mem_acce_tb(.clk_i(clk),
		.icode_i(icode),
		.vala_i(vala),
		.vale_i(vale),
		.valp_i(valp),
		.valm_o(valm),
		.dmem_error_o(dmem_error));
	
	write_back write_back_tb(.icode_i(icode),
		.vale_i(vale), 
		.valm_i(valm),
		.instr_valid_i(instr_valid),
		.imem_error_i(imem_error),
		.dmem_error_i(dmem_error),
		.reg_vale_o(reg_vale),
		.reg_valm_o(reg_valm),
		.stat_o(stat));

	pc_update pc_update_tb(.clk_i(clk),
		.icode_i(icode),
		.cnd_i(cnd),
		.valc_i(valc),
		.valm_i(valm),
		.valp_i(valp),
		.nw_pc_o(nw_pc));

	/*
	reg terminate;
	initial begin
		pc = 0;
		#10 pc = 10;
		#10 pc = 20;
		#10 pc = 21;
		#10 pc = 22;
		#10 pc = 24;
		#10 pc = 34;
		#10 pc = 44;
		#10 pc = 46;
		#10 pc = 48;
		#10 pc = 50;
		#10 pc = 52;
		#10 pc = 61;
		#10 pc = 70;
		#10 pc = 71;
		#10 pc = 73;
		#10 pc = 256;
		#10 pc = 1024;
		#10 terminate = 1;
	end
	*/
	initial begin
		pc = 0;
		clk = 0;
		rst = 0;
	end
	always #20 clk = ~clk;
	initial begin
		forever @ (posedge clk) #2 pc= nw_pc;
	end
	initial begin
		#500 $stop;
	end
	/*
	always #100 rst = ~rst;
	*/
	initial begin
		// $monitor("PC = %d\t, icode = %h\t, ifun = %h\t, ra = %h\t, rb = %h\t, valc = %h\t, valp = %d\t, instr_valid = %d\t, imem_error = %d\t", pc, icode, ifun, ra, rb, valc, valp, instr_valid, imem_error);
		// $monitor("valA = %h\t, valB = %h\t", vala, valb);
		// $monitor("PC=%d\t, valE=%h\t", pc, vale);
	end
endmodule