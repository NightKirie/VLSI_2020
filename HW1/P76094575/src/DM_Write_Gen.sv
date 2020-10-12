module DM_Write_Gen (
    input [2:0] funct3,
    input [31:0] alu,
    input [31:0] data,
    input mem_w,
    output logic [3:0] write_en,
    output logic [31:0] write_data
);

always_comb begin
    if(mem_w) begin
        /* SB */
        if(funct3 == 3'b000) begin
            case (alu[1:0])
                2'b00: begin
                    write_en = 4'b1110;
                    write_data = {24'd0, data[7:0]};
                end
                2'b01: begin
                    write_en = 4'b1101;
                    write_data = {16'd0, data[7:0], 8'd0};
                end
                2'b10: begin
                    write_en = 4'b1011;
                    write_data = {8'd0, data[7:0], 16'd0};
                end
                2'b11: begin
                    write_en = 4'b0111;
                    write_data = {data[7:0], 24'd0};
                end 
            endcase
        end
        else begin
            write_en = 4'd0;
            write_data = data;
        end
        /* SW */
    end
    else begin
        write_en = 4'b1111;
        write_data = 32'd0;
    end
end
    
endmodule