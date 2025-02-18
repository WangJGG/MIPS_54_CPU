`timescale 1ns / 1ps

module DIV(
    input [31:0] dividend,
    input [31:0] divisor,
    input start,
    input clock,
    input reset,
    output [31:0] q,
    output [31:0] r,
    output reg busy
    );
    wire ready;
    reg [5:0] count;
    reg [31:0] reg_q,reg_r,reg_b;
    reg busy2,r_sign;
    reg dividend_sign,divisor_sign;
    wire [31:0] tmp_r,tmp_q;
    assign ready=~busy & busy2;     //运算结束时是有效的
    wire [32:0] sub_add = r_sign ? ({reg_r,tmp_q[31]}+{1'b0,reg_b}):({reg_r,tmp_q[31]}-{1'b0,reg_b});//加减法器
    assign tmp_r = r_sign ? reg_r+reg_b : reg_r;
    assign r = tmp_r[31]==dividend_sign?tmp_r:~tmp_r+1'b1;
    assign tmp_q = reg_q;
    assign q = divisor_sign==dividend_sign?tmp_q:~tmp_q+1'b1;
    always @ (posedge clock or posedge reset) begin
        if(reset) begin
            count <= 5'b0;
            busy <= 0;
            busy2 <= 0;
        end
        else begin
            busy2<=busy;
            if(start) begin
                reg_r <= 'b0;
                reg_q <= dividend[31]?~dividend+1'b1:dividend;
                reg_b <= divisor[31]?~divisor+1'b1:divisor;
                r_sign <= 0;
                dividend_sign <= dividend[31];
                divisor_sign <= divisor[31];
                count <= 5'b0;
                busy <= 1;                
            end
            else if(busy) begin
                reg_r <= sub_add[31:0];
                r_sign <= sub_add[32];
                reg_q <= {reg_q[30:0],~sub_add[32]};//根据加减法器结果（相当于是上一次的运算结果）的正负判断商补1/0，
                count <= count + 5'b1;
                if(count == 5'b11111) busy <= 0;
            end
        end
    end
endmodule
