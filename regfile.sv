module regfile(clk, reset, wr_en, rx, ry, w_r, data_in, datax, datay, regs);
    //signals
    input clk, reset, wr_en;
    input [2:0] rx, ry, w_r;
    input [15:0] data_in;
    output logic [15:0] datax, datay;
    output logic [7:0][15:0] regs;

    //write logic
    always_ff @(posedge clk, posedge reset) begin
        datax <= regs[rx];
		datay <= regs[ry];
		
		if (reset) begin
            regs[0] <= 0;
            regs[1] <= 0;
            regs[2] <= 0;
            regs[3] <= 0;
            regs[4] <= 0;
            regs[5] <= 0;
            regs[6] <= 0;
            regs[7] <= 0;
        end

        else if (wr_en) begin
            case(w_r)
                3'b0: regs[0] <= data_in;
                3'b1: regs[1] <= data_in;
                3'b10: regs[2] <= data_in;
                3'b11: regs[3] <= data_in;
                3'b100: regs[4] <= data_in;
                3'b101: regs[5] <= data_in;
                3'b110: regs[6] <= data_in;
                3'b111: regs[7] <= data_in;
            endcase
        end
        else regs <= regs;
    end

    //read logic
    //clock cycle behind, clock datax and datay
    /*assign datax = regs[rx];
    assign datay = regs[ry];*/
    /*always_comb begin
        case(rx)
            3'b0: datax <= regs[0];
            3'b1: datax <= regs[1];
            3'b10: datax <= regs[2];
            3'b11: datax <= regs[3];
            3'b100: datax <= regs[4];
            3'b101: datax <= regs[5];
            3'b110: datax <= regs[6];
            3'b111: datax <= regs[7];
        endcase
        case(ry)
            3'b0: datay <= regs[0];
            3'b1: datay <= regs[1];
            3'b10: datay <= regs[2];
            3'b11: datay <= regs[3];
            3'b100: datay <= regs[4];
            3'b101: datay <= regs[5];
            3'b110: datay <= regs[6];
            3'b111: datay <= regs[7];
        endcase
    end*/

endmodule