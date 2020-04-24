module execute(clk,reset, instr, sel_alu_a, sel_alu_b, addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, o_ldst_rd, o_ldst_wr, alu_n, alu_z, r_jump, s_jump);
    input clk, reset, alu_n, alu_z;
    input [4:0] instr;
    output logic [1:0] sel_alu_a, sel_alu_b;
    output logic addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, o_ldst_rd, o_ldst_wr, r_jump, s_jump;

    always_comb begin
        parameter 
		mv = 5'b0, add = 5'b1, sub = 5'b10, cmp = 5'b11, ld = 5'b100, st = 5'b101, 
		mvi = 5'b10000, addi = 5'b10001, subi = 5'b10010, cmpi = 5'b10011, mvhi = 5'b10110,
		jr = 5'b1000, jzr = 5'b1001, jnr = 5'b1010, callr = 5'b1100, 
		j = 5'b11000, jz = 5'b11001, jn = 5'b11010, call = 5'b11100;
		
		//these r signals for add rx ry
        sel_alu_b = 2'b0;
        sel_alu_a = 2'b0;
        addsub = 1'b0;
        ld_alu_r = 1'b0;
        ld_nz = 1'b0;
        o_ldst_rd = 1'b0; 
        o_ldst_wr = 1'b0;
        ld_pc_ac = 1'b0;
        ld_ir_ac = 1'b0;
		r_jump = 1'b0;
		s_jump = 1'b0;

        
        case(instr)
            addi: begin
                sel_alu_b = 2'b1;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
			add: begin
				ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
			end
            sub, cmp: begin
                addsub = 1'b1;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            subi, cmpi: begin
                addsub = 1'b1;
                sel_alu_b = 2'b1;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            mv: begin
                sel_alu_a = 2'b1;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            mvi: begin
                sel_alu_a = 2'b1;
                sel_alu_b = 2'b1;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            mvhi: begin
                sel_alu_a = 2'b1;
                sel_alu_b = 2'b10;
                ld_alu_r = 1'b1;
                ld_nz = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            ld: begin
                o_ldst_rd = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
            st: begin
                o_ldst_wr = 1'b1;
                ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
            end
			//uncod jumps
			jr, callr: begin
				r_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
			//cond jump, reg
			jnr: begin
				if (alu_n) r_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
			jzr: begin
				if (alu_z) r_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
			//cond jump, sext
			j, call: begin
				s_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
			jn: begin
				if (alu_n) s_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
			jz: begin
				if (alu_z) s_jump = 1'b1;
				ld_pc_ac = 1'b1;
                ld_ir_ac = 1'b1;
				ld_alu_r = 1'b1;
			end
            default: ;
        endcase
    end
	
endmodule