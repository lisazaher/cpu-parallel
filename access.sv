module access(clk, reset, instr, wr_en, sel_datain);
    input clk, reset;
    input [4:0] instr;

    output logic wr_en;
    output logic [2:0] sel_datain;

    always_comb begin
        parameter 
		mv = 5'b0, add = 5'b1, sub = 5'b10, cmp = 5'b11, ld = 5'b100, st = 5'b101, 
		mvi = 5'b10000, addi = 5'b10001, subi = 5'b10010, cmpi = 5'b10011, mvhi = 5'b10110,
		jr = 5'b1000, jzr = 5'b1001, jnr = 5'b1010, callr = 5'b1100, 
		j = 5'b11000, jz = 5'b11001, jn = 5'b11010, call = 5'b11100;
		
		wr_en = 1'b0;
        sel_datain = 2'b0;

        case(instr)
            add, addi, sub, subi, mv, mvi, mvhi: begin
                wr_en = 1'b1;
                sel_datain = 2'b1;
            end
            ld: begin
                wr_en = 1'b1;
                sel_datain = 2'b10;
            end
			call: begin
				wr_en = 1'b1;
				sel_datain =  2'b11;
			end
			callr: begin
				wr_en = 1'b1;
				sel_datain =  3'b100;
			end
            default:;
        endcase
    end
endmodule