`timescale 1ns / 1ps

module MUX8_1(
    input [2:0]  S,
    input [31:0] D0,
    input [31:0] D1,
    input [31:0] D2,
    input [31:0] D3,
    input [31:0] D4,
    input [31:0] D5,
    input [31:0] D6,
    input [31:0] D7,
    output reg [31:0]oZ
    );
    always @(*) begin
            case (S)
                3'b000: begin oZ <= D0; end
                3'b001: begin oZ <= D1; end
                3'b010: begin oZ <= D2; end
                3'b011: begin oZ <= D3; end 
                3'b100: begin oZ <= D4; end 
                3'b101: begin oZ <= D5; end 
                3'b110: begin oZ <= D6; end 
                3'b111: begin oZ <= D7; end 
                default: ;
            endcase
        end
endmodule
