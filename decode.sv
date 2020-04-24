module decode(clk, reset, r_jump, s_jump, instr, ld_rx, ld_ry, ld_pc_ex, ld_ir_ex);
    input clk, reset, r_jump, s_jump;
    input [4:0] instr;
    output logic ld_rx, ld_ry, ld_pc_ex, ld_ir_ex;

    always_comb begin
        ld_rx = 0;
        ld_ry = 0; 
        ld_pc_ex = 0; 
        ld_ir_ex = 0;

        if (!r_jump && !s_jump) begin  //not a j or call instr
			ld_rx = 1'b1;
			ld_ry = 1'b1;
            ld_pc_ex = 1'b1;
            ld_ir_ex = 1'b1;
		end
    end
endmodule