`timescale 1ns / 1ps
/*行为描述实现*/
module PC(
    input clk,          //下降沿有效
    input rst,
    input PCin,          //使能信号
    input PCout,
    input [31:0] data_in,
    output [31:0] data_out
    );
    reg [31:0] pc_reg;
   /* initial begin
        pc_reg <= 32'h00400000;//上电初值
    end*/
    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            pc_reg <= 32'h00400000;//初值不是0
        end
        else begin
            if(PCin)
                pc_reg <= data_in;
            else;
        end
    end
    assign data_out =  PCout ? pc_reg : data_out;//pc_reg;//
endmodule
