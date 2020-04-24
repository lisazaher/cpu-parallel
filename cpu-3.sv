module datapathddd(clk, reset, i_pc_rddata, o_ldst_addr, o_ldst_wrdata, i_ldst_rddata, o_tb_regs, o_pc_addr,
				//fetch
				ld_pc, pc_in_sel, pc_addr_sel,
				//decode
				ld_rx, ld_ry, ld_pc_dc, ld_ir_dc,
				//execute
				sel_alu_a, sel_alu_b, addsub, ld_alu_r, ld_nz, ld_pc_ex, ld_ir_ex, 
				r_alu_n, r_alu_z, r_jump, s_jump,
				//fetch
				ld_pc_ac, ld_ir_ac, wr_en, sel_datain,
				//cntrl
				r_ir_dc, r_ir_ex, r_ir_ac);
	/* ---------------------------------------------------- SIGNALS ---------------------------------------------------- */
	/*INPUTS*/
	input clk, reset;
	input [15:0] i_pc_rddata, i_ldst_rddata;

	//fetch signals
	input ld_pc;
	input [1:0] pc_in_sel, pc_addr_sel;

	//decode signals
	input ld_rx, ld_ry, ld_pc_dc, ld_ir_dc;

	//execute
	input [1:0] sel_alu_a, sel_alu_b;
	input addsub, ld_alu_r, ld_nz, ld_pc_ex, ld_ir_ex, r_jump, s_jump;

	//access
	input ld_pc_ac, ld_ir_ac;

	//access
	input wr_en;
	input [2:0] sel_datain;

	/*OUTPUTS*/
	output [15:0] o_pc_addr, o_ldst_addr, o_ldst_wrdata;
	output logic [15:0] r_ir_dc, r_ir_ex, r_ir_ac;
	output [7:0][15:0] o_tb_regs;
	output logic r_alu_n, r_alu_z;
	
	
	/* ---------------------------------------------------- INTERNAL ---------------------------------------------------- */	
	//registers
	logic [15:0] r_pc, r_pc_dc, r_pc_ex, r_pc_ac, r_rf_rx, r_rf_ry, r_alu_r;
	

	//wires
	logic [15:0] w_pc_r, w_pc_nxt, w_pc_addr, rf_datax, rf_datay, data_in, datax, datay, alu_a, alu_b, alu_r, w_ir_dc, data_delay;
	logic [15:0] w_jmp_sext, w_jmp_sext_nxt, w_rx_nxt;
	logic [2:0] rx, ry, w_r;
	logic alu_n, alu_z, ld_rx_case2, ld_ry_case2, ld_rx_delay, ld_ry_delay, ld_rx_no_delay, ld_ry_no_delay;
	logic [2:0] true_sel_alu_a, true_sel_alu_b;
	
	assign ld_rx_case2 = (w_ir_dc[7:5] == r_ir_ac[7:5] && r_ir_dc != 16'b0 && r_ir_ac != 16'b0);
	assign ld_ry_case2 = (w_ir_dc[10:8] == r_ir_ac[7:5] && r_ir_dc != 16'b0 && r_ir_ac != 16'b0);
	assign ld_rx_no_delay = (r_ir_dc[7:5] == r_ir_ac[7:5] && r_ir_dc != 16'b0 && r_ir_ac != 16'b0 && r_ir_dc[4] == 1'b0);
	assign ld_ry_no_delay = (r_ir_dc[10:8] == r_ir_ac[7:5] && r_ir_dc != 16'b0 && r_ir_ac != 16'b0 && r_ir_dc[4] == 1'b0);

	/*MODULE INSTANT*/
	regfile rf(.clk(clk), .reset(reset), .wr_en(wr_en), .rx(rx), .ry(ry), .w_r(w_r), 
				.data_in(data_in), .datax(rf_datax), .datay(rf_datay), .regs(o_tb_regs));

	/* CLOCKED REGISTERS */
	always_ff @(posedge clk, posedge reset) begin
		if(reset) begin
			r_pc <= 16'b0;
			r_ir_dc <= 16'b0;
			r_pc_dc <= 16'b0; 
			r_ir_ex <= 16'b0;
			r_pc_ex <= 16'b0; 
			r_ir_ac <= 16'b0; 
			r_pc_ac <= 16'b0;
			r_rf_rx <= 16'b0; 
			r_rf_ry <= 16'b0;
			r_alu_r <= 16'b0;
			r_alu_n <= 1'b0;
			r_alu_z <= 1'b0;
		end
		else begin
			ld_rx_delay <= ld_rx_case2;
			ld_ry_delay <= ld_ry_case2;
			data_delay <= data_in;
			//fetch
			if (ld_pc) r_pc <= w_pc_r;
			//decode
			if (ld_pc_dc) r_pc_dc <= r_pc; //pc_add?
			if (ld_ir_dc) r_ir_dc <= w_ir_dc;
			if (ld_rx) begin
				if (ld_rx_no_delay) r_rf_rx <= data_in;
				else if (ld_rx_delay) r_rf_rx <= data_delay;
				else r_rf_rx <= rf_datax; //reading files
			end
			if (ld_ry) begin
				if (ld_ry_no_delay) r_rf_ry <= data_in;
				else if (ld_ry_delay) r_rf_ry <= data_delay; 
				else r_rf_ry <= rf_datay;
			end
			//execute
			if (ld_alu_r) r_alu_r <= alu_r;
			if (ld_nz) begin
				r_alu_n <= alu_n;
				r_alu_z <= alu_z;
			end
			if (ld_pc_ex) r_pc_ex <= r_pc_dc;
			if (ld_ir_ex) r_ir_ex <= r_ir_dc;
			//access
			if (ld_pc_ac) r_pc_ac <= r_pc_ex;
			if (ld_ir_ac) r_ir_ac <= r_ir_ex;
			
			if (r_jump || s_jump) begin
				r_pc_ex <= 16'b0;
				r_ir_ex <= 16'b0;
				r_pc_dc <= 16'b0;
				r_ir_dc <= 16'b0;
			end
		end
	end


	/* COMB LOGIC */

	//fetch
	assign w_pc_nxt = r_pc + 2'b10; //+2
	assign w_rx_nxt = r_rf_rx + 2'b10;
	assign w_jmp_sext = r_pc + 2*{{4{r_ir_ex[15]}}, r_ir_ex[15:5]} - 3'b110;
	assign w_jmp_sext_nxt = w_jmp_sext + 2'b10;
	//assign w_pc_call_r = (pc_in_sel == 2'b1 && r_ir_ac[4] == 1'b0)? r_rf_rx: 2*{{4{r_ir_ac[15]}}, r_ir_ac[15:5]}; ; //callr and call
	

	always_comb begin
		case (pc_in_sel)
		0: w_pc_r = w_pc_nxt;        //not j or call
		1: w_pc_r = w_rx_nxt; //r value
		2: w_pc_r = w_jmp_sext_nxt; //sext value
		default: w_pc_r = '0;
		endcase
		case (pc_addr_sel)
			0: w_pc_addr = r_pc;
			1: w_pc_addr = r_rf_rx;
			2: w_pc_addr = w_jmp_sext;
			default w_pc_addr = 0;
		endcase
  	end

  	//decode
  	assign w_ir_dc = i_pc_rddata;
  	assign rx = w_ir_dc[7:5];
  	assign ry = w_ir_dc[10:8];

  	//execute
	
	/*assign true_sel_alu_a = (r_ir_ex != 16'b0 && r_ir_ac != 16'b0 && r_ir_ex[4] == 1'b0 && r_ir_ac[7:5] == r_ir_ex[7:5] || r_ir_ac[7:5] == r_ir_ex[10:8]) ? 2'b11 : sel_alu_a; //part 2 case
	assign true_sel_alu_b = (r_ir_ex != 16'b0 && r_ir_ac != 16'b0 && r_ir_ex[4] == 1'b0 && r_ir_ac[10:8] == r_ir_ex[10:8] || r_ir_ac[10:8] == r_ir_ex[7:5] ) ? 2'b11 : sel_alu_b; //part 2 case
  	*/
	always_comb begin
		/*if (r_ir_ex != 16'b0 && r_ir_ac != 16'b0 && r_ir_ex[3] == 1'b1) begin //branch instr
			if (r_ir_ac[7:5] == r_ir_ex[7:5]) true_sel_alu_b = 2'b100; //b instr
			else true_sel_alu_a = sel_alu_b;
		end
		else*/
		if (r_ir_ex != 16'b0 && r_ir_ac != 16'b0 && r_ir_ex[4] == 1'b0) begin //ir instr is loaded and decode is not an i inst (mvi, addi, subi, cmpi)
			if (r_ir_ac[7:5] == r_ir_ex[10:8]) true_sel_alu_b = 3'b11; //ry of ex and rx of ac 
			else if (r_ir_ac[7:5] == r_ir_ex[7:5] && r_ir_ex[3] == 1'b1) true_sel_alu_b = 3'b100;//b inst 
			else true_sel_alu_b = sel_alu_b;
			
			if (r_ir_ac[7:5] == r_ir_ex[7:5]) true_sel_alu_a = 3'b11; //rx of ex and rx of ac
			else true_sel_alu_a = sel_alu_a;
		end
		else if (r_ir_ex != 16'b0 && r_ir_ac != 16'b0 && r_ir_ex[4] == 1'b1) begin //imm instr
			if (r_ir_ac[7:5] == r_ir_ex[7:5]) true_sel_alu_a = 3'b11; //rx of ex and rx of ac imm
			else true_sel_alu_a = sel_alu_a;
		end
		else begin
			true_sel_alu_a = sel_alu_a;
			true_sel_alu_b = sel_alu_b;
		end
  		case(true_sel_alu_a)
			2'b0: alu_a = r_rf_rx;
			2'b1: alu_a = 16'b0;
			2'b11: alu_a = data_in; //part 2
			default: alu_a = 16'b0;
		endcase
		case(true_sel_alu_b)
			2'b0: alu_b = r_rf_ry;
			2'b1: alu_b = {{8{r_ir_ex[15]}}, r_ir_ex[15:8]}; //sextimm8 from ir {{8{imm8[7]}}, imm8};
			2'b10: alu_b = {r_ir_ex[15:8], 8'b0}; //mvhi from ir
			2'b11: alu_b = data_in; //part2
			3'b100: alu_b = r_rf_rx;
			default: alu_b = 16'b0;
		endcase

		//ALU
		if (true_sel_alu_b == 3'b10) alu_r = alu_a[7:0] + alu_b;
		else alu_r = (addsub) ? alu_a - alu_b : alu_a + alu_b;
  	end

	assign alu_n = alu_r[15];
	assign alu_z = (alu_r == 16'b0);

	//access
	assign w_r = (r_ir_ac[3:0] ==  4'b1100) ? 3'b111 : r_ir_ac[7:5]; //call, callr (sel w_r = 7)
	
	always_comb begin
		case(sel_datain)
			1: data_in = r_alu_r;
			2: data_in = i_ldst_rddata;
			3: data_in = r_pc_ac; //call, callr --> write pc to r7
			4: data_in = r_alu_r;
			default : data_in = 0;
		endcase
	end
	/* ---------------------------------------------------- EXTERNAL ---------------------------------------------------- */
	//output logic
	//fetch
	assign o_pc_addr = w_pc_addr;
	
	//execute
	assign o_ldst_addr = r_rf_ry;
	assign o_ldst_wrdata = r_rf_rx;

endmodule