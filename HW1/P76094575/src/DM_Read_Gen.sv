module DM_Read_Gen (
    input [2:0] funct3,
    input [31:0] pc,
    input [31:0] data,
    input mem_r,
    output logic [31:0] read_data
);

always_comb begin
    if(mem_r) begin
        /* LB */
        if(funct3 == 3'b000) begin
            case (pc[1:0])
                2'b00: begin
                    read_data = {{24{data[7]}}, data[7:0]};
                end
                2'b01: begin
                    read_data = {{24{data[15]}}, data[15:8]};
                end
                2'b10: begin
                    read_data = {{24{data[23]}}, data[23:16]};
                end
                2'b11: begin
                    read_data = {{24{data[31]}}, data[31:24]};
                end 
            endcase
        end
        /* LW */
        else begin
            read_data = data;
        end
    end
    else begin
        read_data = 32'd0;
    end
end
    
endmodule