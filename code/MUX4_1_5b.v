`timescale 1ns / 1ps

module MUX4_1_5b(
    input [1:0]  S,
    input [4:0] D0,
    input [4:0] D1,
    input [4:0] D2,
    input [4:0] D3,
    output reg [4:0]oZ
    );
    always @(*) begin
        case (S)
            2'b00: begin oZ <= D0; end
            2'b01: begin oZ <= D1; end
            2'b10: begin oZ <= D2; end
            2'b11: begin oZ <= D3; end 
            default: ;
        endcase
    end
endmodule
