`timescale 1ns / 1ps

module HI_LO(
    input clk,        //时钟信号
    input ena,        //使能信号
    input rst,        //复位信号
    input [31:0] HI_in,
    input [31:0] LO_in,
    input HI_w,       //HI写有效
    input LO_w,       //LO写有效
    output [31:0] HI_out,
    output [31:0] LO_out
    );

reg [31:0] HI;      //高32位数
reg [31:0] LO;      //低32位数

assign HI_out = ena ? HI : 32'bz;
assign LO_out = ena ? LO : 32'bz;

always @(posedge rst or negedge clk) begin 
    if (ena && rst) begin
        HI <= 32'd0;
        LO <= 32'd0;
    end
    else if(ena)
    begin
        if(HI_w)
            HI <= HI_in;
        if(LO_w)
            LO <= LO_in;
    end
end

endmodule
