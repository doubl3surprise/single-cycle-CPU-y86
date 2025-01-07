module write_back(input [3:0] icode_i,
	input [63:0] vale_i, valm_i,
	input instr_valid_i, imem_error_i, dmem_error_i,
	output [63:0] reg_vale_o, reg_valm_o,
	output stat_o);
	assign reg_vale_o = vale_i;
	assign reg_valm_o = valm_i;
	
	assign stat_o = instr_valid_i & ~imem_error_i & ~dmem_error_i;
endmodule