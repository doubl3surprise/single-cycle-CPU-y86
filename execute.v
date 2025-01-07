`include "define.v"
module execute(input wire clk_i, rst_n_i, 
	input wire [3:0] icode_i, ifun_i,
	input wire signed [63:0] vala_i, valb_i, valc_i,
	output reg signed [63:0] vale_o,
	output wire cnd_o);
	wire [3:0] alu_fun;
	wire set_cc;
	reg zf, of, sf;
	reg [63:0] alua, alub;
	// vala and valb are only relation to valE;
	always@ (*) begin 
		case (icode_i)
			`HALT: begin
				alua = 0; alub = 0;
			end
			`NOP: begin
				alua = 0; alub = 0;
			end
			`IRMOVQ: begin
				alua = valc_i; alub = 0;
			end
			`RMMOVQ: begin
				alua = valc_i; alub = valb_i;
			end
			`MRMOVQ: begin
				alua = valc_i; alub = valb_i;
			end
			`OPQ: begin
				alua = vala_i; alub = valb_i;
			end
			`JXX: begin
				alua = 0; alub = 0;
			end
			`CMOVXX: begin
				alua = vala_i; alub = 0;
			end
			`CALL: begin
				alua = -8; alub = valb_i;
			end
			`RET: begin
				alua = 8; alub = valb_i;
			end
			`PUSHQ: begin
				alua = valb_i; alub = -8;
			end
			`POPQ: begin
				alua = valb_i; alub = 8;
			end
			default: begin
				alua = 0; alub = 0;
			end
		endcase
	end
	//calculate valE
	assign alu_fun = (icode_i == `OPQ) ? ifun_i : `ALUADD;
	always@ (*) begin
		case (alu_fun)
			`ALUADD: vale_o = alua + alub;
			`ALUSUB: vale_o = alua - alub;
			`ALUAND: vale_o = alua & alub;
			`ALUXOR: vale_o = alua ^ alub;
		endcase
	end
	//set condition
	initial begin
		{of, sf, zf} = 3'b001;
	end
	assign set_cc = (icode_i == `OPQ) ? 1 : 0;
			
	always@ (posedge clk_i) begin
		if(~rst_n_i) begin
			{of, sf, zf} = 3'b001;
		end
		else if(icode_i == `OPQ) begin
			of <= ((alu_fun == `ALUADD && (alua[63] != vale_o[63]) && (alub[63] != vale_o[63])) 
				|| ((alu_fun == `ALUSUB) && (alua[63] != alub[63]) && (alub[63] != vale_o[63])))
				? 1 : 0;
			sf <= vale_o[63];
			zf = (vale_o == 0) ? 1 : 0;
		end
	end
	assign cnd_o = 
		(ifun_i == `C_YES) | 
		(ifun_i == `C_LE & ((sf ^ of) | zf)) | 
		(ifun_i == `C_L & (sf ^ of)) | 
		(ifun_i == `C_E & zf) |
		(ifun_i == `C_NE & ~zf) |
		(ifun_i == `C_GE & ~(sf ^ of)) |
		(ifun_i == `C_G & (~(sf ^ of) & ~zf));
			
endmodule