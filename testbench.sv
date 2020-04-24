module testbench();

	// Create a 100MHz clock
	logic clk;
	initial clk = '0;
	always #5 clk = ~clk;

	// Create the reset signal 
	logic reset;


	// Declare the bus signals, using the CPU's names for them
	logic [15:0] o_pc_addr;
	logic o_pc_rd;
	logic [15:0] i_pc_rddata;
	logic [15:0] o_ldst_addr;
	logic o_ldst_rd;
	logic o_ldst_wr;
	logic [15:0] i_ldst_rddata;
	logic [15:0] o_ldst_wrdata;
	logic [7:0][15:0] o_tb_regs;
	
	logic [15:0] ir_ex, ir_dc, ir_ac;
	logic ld_pc, ld_rx, ld_ry, ld_pc_ex, ld_ir_ex, addsub, ld_alu_r, ld_nz, ld_pc_ac, ld_ir_ac, wr_en, ld_pc_dc, ld_ir_dc;
	logic [1:0] pc_in_sel, pc_addr_sel, sel_alu_a, sel_alu_b, sel_datain;

	datapath dp(.clk(clk), .reset(reset), .i_pc_rddata(i_pc_rddata), .o_ldst_addr(o_ldst_addr), .o_ldst_wrdata(o_ldst_wrdata), .o_pc_addr(o_pc_addr),
				.i_ldst_rddata(i_ldst_rddata), .o_tb_regs(o_tb_regs),
				//fetch
				.ld_pc(ld_pc), .pc_in_sel(pc_in_sel), .pc_addr_sel(pc_addr_sel),
				//decode
				.ld_rx(ld_rx), .ld_ry(ld_ry), .ld_pc_dc(ld_pc_dc), .ld_ir_dc(ld_ir_dc),
				//execute
				.sel_alu_a(sel_alu_a), .sel_alu_b(sel_alu_b), .addsub(addsub), 
				.ld_alu_r(ld_alu_r), .ld_nz(ld_nz), .ld_pc_ex(ld_pc_ex), .ld_ir_ex(ld_ir_ex),
				//fetch
				.ld_pc_ac(ld_pc_ac), .ld_ir_ac(ld_ir_ac), .wr_en(wr_en), .sel_datain(sel_datain),
				//cntrl
				.r_ir_dc(ir_dc), .r_ir_ex(ir_ex), .r_ir_ac(ir_ac));
				
	initial begin
		reset = 1;
		#5;
		
		reset = 0;
		#5;
		
		
		
		$stop();
	end
endmodule