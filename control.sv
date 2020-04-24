//instantiate all control modules heresse
module control(clk, reset, ir_dc, ir_ex, ir_ac, o_ldst_rd, o_ldst_wr, 
            //fetch
            ld_pc, o_pc_rd, pc_in_sel, pc_addr_sel, ld_pc_dc, ld_ir_dc,
            //decode
            ld_rx, ld_ry, ld_pc_ex, ld_ir_ex,
            //execute
            sel_alu_a, sel_alu_b, addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, alu_n, alu_z, r_jump, s_jump,
            //acess
            wr_en, sel_datain);

    input clk, reset, alu_n, alu_z;
    input [15:0] ir_ex, ir_dc, ir_ac;
    output logic ld_pc, o_pc_rd, ld_pc_dc, ld_ir_dc, ld_rx, ld_ry, ld_pc_ex, ld_ir_ex, addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, wr_en;
	output logic o_ldst_rd, o_ldst_wr, r_jump, s_jump;
    output logic [1:0] pc_in_sel, pc_addr_sel, sel_alu_a, sel_alu_b;
	output logic [2:0]	sel_datain;

    fetch f(clk, reset, r_jump, s_jump, ld_pc, o_pc_rd, pc_in_sel, pc_addr_sel, ld_pc_dc, ld_ir_dc);

    decode dc(.clk(clk), .reset(reset), .instr(ir_dc[4:0]), .ld_rx(ld_rx), .ld_ry(ld_ry), 
			.ld_pc_ex(ld_pc_ex), .ld_ir_ex(ld_ir_ex), .r_jump(r_jump), .s_jump(s_jump));

    execute ex(.clk(clk), .reset(reset), .alu_n(alu_n), .alu_z(alu_z),
			.instr(ir_ex[4:0]), .sel_alu_a(sel_alu_a), .o_ldst_rd(o_ldst_rd), .o_ldst_wr(o_ldst_wr),
            .sel_alu_b(sel_alu_b), .addsub(addsub), .ld_alu_r(ld_alu_r), .ld_nz(ld_nz), .ld_pc_ac(ld_pc_ac), .ld_ir_ac(ld_ir_ac),
			.r_jump(r_jump), .s_jump(s_jump));

    access ac(.clk(clk), .reset(reset), .instr(ir_ac[4:0]), .wr_en(wr_en), .sel_datain(sel_datain));
endmodule