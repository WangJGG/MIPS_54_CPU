`timescale 1ns / 1ps
/*��Ϊ����ʵ��*/
module PC(
    input clk,          //�½�����Ч
    input rst,
    input PCin,          //ʹ���ź�
    input PCout,
    input [31:0] data_in,
    output [31:0] data_out
    );
    reg [31:0] pc_reg;
   /* initial begin
        pc_reg <= 32'h00400000;//�ϵ��ֵ
    end*/
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            pc_reg <= 32'h00400000;//��ֵ����0
        end
        else begin
            if(PCin)
                pc_reg <= data_in;
            else;
        end
    end
    assign data_out =  PCout ? pc_reg : data_out;//pc_reg;//
endmodule
