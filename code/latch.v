`timescale 1ns / 1ps

module latch(
        input clk,
        input in,
        input out,
        input [31:0] data_in,
        output [31:0] data_out
    );
    reg [31:0]data;
    assign data_out = (out) ? data : 32'bz;
    always@(negedge clk) begin
        if(in) begin
            data <= data_in;
        end
        else;
    end
endmodule
