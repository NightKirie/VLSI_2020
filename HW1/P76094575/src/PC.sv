module PC (
    input clk,
    input rst,
    input PC_stall,
    input [31:0] pc_in,
    output logic [31:0] pc_out
);

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        pc_out <= 32'd0;
    end
    else begin
        if(PC_stall)
            pc_out <= pc_in - 32'd4;
        else
            pc_out <= pc_in;
    end
end

endmodule