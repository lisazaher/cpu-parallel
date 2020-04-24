module fetch(clk, reset, r_jump, s_jump, ld_pc, o_pc_rd, pc_in_sel, pc_addr_sel, ld_pc_dc, ld_ir_dc);
	//inputs
	input clk, reset, r_jump, s_jump;
	//outputs
	output logic ld_pc, o_pc_rd, ld_pc_dc, ld_ir_dc;
	output logic [1:0] pc_addr_sel, pc_in_sel;


	always_comb begin
		ld_pc = 1'b0;
		o_pc_rd = 1'b0;
		pc_in_sel = 2'b0;
		pc_addr_sel = 2'b0;
		ld_pc_dc = 1'b0; 
		ld_ir_dc = 1'b0;

		if (!r_jump && !s_jump) begin  //not a j or call instr
			ld_pc = 1'b1;
			o_pc_rd = 1'b1;
			ld_pc_dc = 1'b1; 
			ld_ir_dc = 1'b1;
		end
		else if (r_jump && !s_jump) begin //register value
			ld_pc = 1'b1;
			o_pc_rd = 1'b1;
			pc_addr_sel = 2'b1;
			pc_in_sel = 2'b1;
		end
		else if (!r_jump && s_jump) begin //should be s_ext imm11
			ld_pc = 1'b1;
			o_pc_rd = 1'b1;
			pc_addr_sel = 2'b10;
			pc_in_sel = 2'b10;
		end
	end
endmodule