module Register (
    input clk,
    input rst,
    input [4:0] rr1_addr,
    input [4:0] rr2_addr,
    input [4:0] wr_addr,
    input [31:0] wd,
    input reg_w, 
    output logic [31:0] rr1_data,
    output logic [31:0] rr2_data
);

logic [31:0] reg_data [0:31];

assign rr1_data[31:0] = (wr_addr == rr1_addr && wr_addr != 5'd0 && reg_w) ? wd : reg_data[rr1_addr];
assign rr2_data[31:0] = (wr_addr == rr2_addr && wr_addr != 5'd0 && reg_w) ? wd : reg_data[rr2_addr];

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 32; i = i + 1) begin
            reg_data[i] <= 32'd0;
        end
    end
    else if (reg_w) begin
        /* keep $0 always be zero */
        if(wr_addr != 5'd0)
            reg_data[wr_addr] <= wd;
    end
end

    
endmodule