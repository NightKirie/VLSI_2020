module MEM_WB_reg (
    input clk,
    input rst,
    input wb_sel_in,
    input reg_w_in,
    input [31:0] rd_data_in,
    input [31:0] rb_data_in,
    input [4:0] wr_addr_in,
    output logic wb_sel_out,
    output logic reg_w_out,
    output logic [31:0] rd_data_out,
    output logic [31:0] rb_data_out,
    output logic [31:0] wr_addr_out
);

always_ff @(posedge clk, posedge rst) begin
    if(rst) begin
        wb_sel_out <= 0;
        reg_w_out <= 0;
        rd_data_out <= 32'd0;
        rb_data_out <= 32'd0;
        wr_addr_out <= 32'd0;
    end
    else begin
        wb_sel_out <= wb_sel_in;
        reg_w_out <= reg_w_in;
        rd_data_out <= rd_data_in;
        rb_data_out <= rb_data_in;
        wr_addr_out <= wr_addr_in;
    end
end
    
endmodule