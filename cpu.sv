module cpu
(
	input clk,
	input reset,
	
	output [15:0] o_pc_addr,
	output o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output [15:0] o_ldst_addr,
	output o_ldst_rd,
	output o_ldst_wr,
	input [15:0] i_ldst_rddata,
	output [15:0] o_ldst_wrdata,
	
	output [7:0][15:0] o_tb_regs
);

	logic [15:0] ir_ex, ir_dc, ir_ac;
	logic ld_pc, ld_rx, ld_ry, ld_pc_ex, ld_ir_ex, addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, wr_en, ld_pc_dc, ld_ir_dc;
	logic alu_n, alu_z, r_jump, s_jump;
	logic [1:0] pc_in_sel, pc_addr_sel, sel_alu_a, sel_alu_b;
	logic [2:0] sel_datain;

	datapath dp(.clk(clk), .reset(reset), .i_pc_rddata(i_pc_rddata), .o_ldst_addr(o_ldst_addr), .o_ldst_wrdata(o_ldst_wrdata), .o_pc_addr(o_pc_addr),
				.i_ldst_rddata(i_ldst_rddata), .o_tb_regs(o_tb_regs),
				//fetch
				.ld_pc(ld_pc), .pc_in_sel(pc_in_sel), .pc_addr_sel(pc_addr_sel),
				//decode
				.ld_rx(ld_rx), .ld_ry(ld_ry), .ld_pc_dc(ld_pc_dc), .ld_ir_dc(ld_ir_dc),
				//execute
				.sel_alu_a(sel_alu_a), .sel_alu_b(sel_alu_b), .addsub(addsub), 
				.ld_alu_r(ld_alu_r), .ld_nz(ld_nz), .ld_pc_ex(ld_pc_ex), .ld_ir_ex(ld_ir_ex),
				.r_alu_n(alu_n), .r_alu_z(alu_z), .r_jump(r_jump), .s_jump(s_jump),
				//fetch
				.ld_pc_ac(ld_pc_ac), .ld_ir_ac(ld_ir_ac), .wr_en(wr_en), .sel_datain(sel_datain),
				//cntrl
				.r_ir_dc(ir_dc), .r_ir_ex(ir_ex), .r_ir_ac(ir_ac));

	control cp(.clk(clk), .reset(reset), .ir_dc(ir_dc), .ir_ex(ir_ex), .ir_ac(ir_ac), .o_ldst_rd(o_ldst_rd), .o_ldst_wr(o_ldst_wr),
            //fetch
            .ld_pc(ld_pc), .o_pc_rd(o_pc_rd), .pc_in_sel(pc_in_sel), .pc_addr_sel(pc_addr_sel), .ld_pc_dc(ld_pc_dc), .ld_ir_dc(ld_ir_dc),
            //decode
            .ld_rx(ld_rx), .ld_ry(ld_ry), .ld_pc_ex(ld_pc_ex), .ld_ir_ex(ld_ir_ex),
            //execute
            .sel_alu_a(sel_alu_a), .sel_alu_b(sel_alu_b), .addsub(addsub), 
			.ld_alu_r(ld_alu_r), .ld_nz(ld_nz), .ld_pc_ac(ld_pc_ac), .ld_ir_ac(ld_ir_ac),
			.alu_n(alu_n), .alu_z(alu_z), .r_jump(r_jump), .s_jump(s_jump),
            //acess
            .wr_en(wr_en), .sel_datain(sel_datain));

	
endmodule