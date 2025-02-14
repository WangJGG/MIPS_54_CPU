`timescale 1ns / 1ps

module HI_LO(
    input clk,        //ʱ���ź�
    input ena,        //ʹ���ź�
    input rst,        //��λ�ź�
    input [31:0] HI_in,
    input [31:0] LO_in,
    input HI_w,       //HIд��Ч
    input LO_w,       //LOд��Ч
    output [31:0] HI_out,
    output [31:0] LO_out
    );

reg [31:0] HI;      //��32λ��
reg [31:0] LO;      //��32λ��

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
