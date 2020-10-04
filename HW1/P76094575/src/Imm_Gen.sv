module Imm_Gen (
    input imm_sel,
    input [31:0] imm_in,
    output [31:0] imm_out;
);

always_comb begin
   if (imm_sel) begin
       /* I-type */
       if (imm_in[6:0] == 7'b0000011 || imm_in[6:0] == 7'b0000011 || imm_in[6:0] == 7'b1100111) begin
           /* SLLI, SRLI, SRAI */
           if (imm[14:12] == 3'b001 && 3'b101) begin
               imm_out = {27'd0, imm_out[4:0]};
           end
           /* sign-extension */
           else begin
               imm_out = {20{imm_in[31]}, imm_in[31:20]};
           end
       end
       /* S-type */
       else if (imm_in[6:0] == 7'b0100011) begin
           imm_out = {20{imm_in[31]}, imm_in[31:25], imm_in[11:7]};
       end
       /* B-type */
       else if (imm_in[6:0] == 7'b1100011) begin
           imm_out = {19'd0, imm_in[31], imm_in[7], imm_in[30:25], imm_in[11:8], 1'd0};
       end
       /* U-type */
       else if (imm_in[6:0] == 7'b0010111 || imm_in[6:0] == 7'b0110111) begin
           imm_out = {imm_in[31:12], 12'd0};
       end
       /* J-type */
       else if (imm_in[6:0] == 7'b1101111) begin
           imm_out = {20{imm_in[31]}, imm_in[19:12], imm_in[20], imm_in[30:21], 1'd0};
       end
       else begin
           imm_out = 32'd0;
       end
   end
   else begin
       imm_out = 32'd0;
   end 
end
endmodule