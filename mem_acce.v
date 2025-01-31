`include "define.v"
module mem_acce(input clk_i,
	input [3:0] icode_i, 
	input [63:0] vala_i, 
	input [63:0] vale_i, 
	input [63:0] valp_i,
	output [63:0] valm_o,
	output wire dmem_error_o);
	reg [63:0] m_addr, m_data, mr, mw;
	reg [7:0] mem[1023:0];
	integer i;
	initial begin
		mem[0] = 8'h00; mem[1] = 8'h01; mem[2] = 8'h02;
		mem[3] = 8'h03; mem[4] = 8'h04; mem[5] = 8'h05;
		mem[6] = 8'h06; mem[7] = 8'h07; mem[8] = 8'h08;
		mem[9] = 8'h09; mem[10] = 8'h0a; mem[11] = 8'h0b;
		mem[12] = 8'h0c; mem[13] = 8'h0d; mem[14] = 8'h0e;
		mem[15] = 8'h0f; mem[16] = 8'h10; mem[17] = 8'h11;
		mem[18] = 8'h12; mem[19] = 8'h13; mem[20] = 8'h14;
		mem[21] = 8'h15; mem[22] = 8'h16; mem[23] = 8'h17;
		mem[24] = 8'h18; mem[25] = 8'h19; mem[26] = 8'h1a;
		mem[27] = 8'h1b; mem[28] = 8'h1c; mem[29] = 8'h1d;
		for(i = 30; i < 1024; i = i + 1) begin
			mem[i] = 8'd0;
		end
	end
	// calculate read permission, write permission, memory_address
	always@ (*) begin
		case (icode_i)
			`HALT: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`NOP: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`CMOVXX: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`IRMOVQ: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`RMMOVQ: begin
				mr <= 1'b0; mw <= 1'b1;
				m_addr <= vale_i; m_data <= vala_i;
			end
			`MRMOVQ: begin
				mr <= 1'b1; mw <= 1'b0;
				m_addr <= vale_i; m_data <= 64'd0;
			end
			`OPQ: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`JXX: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'd0; m_data <= 64'd0;
			end
			`CALL: begin
				mr <= 1'b0; mw <= 1'b1;
				m_addr = vale_i; m_data = valp_i;
			end
			`RET: begin
				mr <= 1'b1; mw <= 1'b0;
				m_addr <= vala_i; m_data <= 64'd0;
			end
			`PUSHQ: begin
				mr <= 1'b0; mw <= 1'b1;
				m_addr <= vale_i; m_data <= vala_i;
			end
			`POPQ: begin
				mr <= 1'b1; mw <= 1'b0;
				m_addr <= vala_i; m_data <= 64'd0;
			end
			default: begin
				mr <= 1'b0; mw <= 1'b0;
				m_addr <= 64'b0; m_data <= 64'b0;
			end
		endcase
	end
	// read and write memory
	assign dmem_error_o = (m_addr > 1023) ? 1 : 0;
	always@ (posedge clk_i) begin
		if(mw) begin
			{mem[7 + m_addr], mem[6 + m_addr], mem[5 + m_addr], 
			mem[4 + m_addr], mem[3 + m_addr], mem[2 + m_addr], 
			mem[1 + m_addr], mem[m_addr]} <= m_data;
		end
	end
	assign valm_o = (mr) ? {mem[7 + m_addr], mem[6 + m_addr], mem[5 + m_addr], 
		mem[4 + m_addr], mem[3 + m_addr], mem[2 + m_addr], 
		mem[1 + m_addr], mem[m_addr]} : 64'd0;
	
endmodule