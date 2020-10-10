module Mux_3_1 (
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [1:0] sel,
    output logic [31:0] out
);

always_comb begin
    case (sel)
        2'b00:
            out = in1;
        2'b01:
            out = in2;
        2'b10:
            out = in3;
        default: 
            out = 32'd0;
    endcase
end
endmodule

module Mux_2_1 (
    input [31:0] in1,
    input [31:0] in2,
    input sel,
    output logic [31:0] out
);

always_comb begin
    case (sel)
        1'b0:
            out = in1;
        1'b1:
            out = in2;
    endcase
end 
endmodule

module Mux_7_7 (
    input in1,
    input in2,
    input in3,
    input in4,
    input in5,
    input in6,
    input in7,
    input sel,
    output logic out1,
    output logic out2,
    output logic out3,
    output logic out4,
    output logic out5,
    output logic out6,
    output logic out7
);

always_comb begin
    case(sel)
        1'b0: begin
            out1 = in1;
            out2 = in2;
            out3 = in3;
            out4 = in4;
            out5 = in5;
            out6 = in6;
            out7 = in7;
        end
        1'b1: begin
            out1 = 1'd0;
            out2 = 1'd0;
            out3 = 1'd0;
            out4 = 1'd0;
            out5 = 1'd0;
            out6 = 1'd0;
            out7 = 1'd0;
        end
    endcase
end 
endmodule
    
