module PC (
    input clk,
    input rst,
    input PC_stall,
    input [31:0] pc_in,
    output logic [31:0] pc_out
);

logic stall_after;

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        pc_out <= 32'd0;
        stall_after <= 1'd0;
    end
    // else begin
    //     if(PC_stall) begin
    //         pc_out <= pc_in;
    //         stall_after <= 1'd1;
    //     end 
    //     else if(stall_after) begin
    //         pc_out <= pc_in - 32'd4;
    //         stall_after <= 1'd0; 
    //     end 
    //     else
    //         pc_out <= pc_in;
    // end
    else if(!PC_stall) 
        pc_out <= pc_in;
end

endmodule