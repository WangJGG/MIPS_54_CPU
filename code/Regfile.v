`timescale 1ns / 1ps
module Regfile(                 
    input  clk,                 //�½�����Ч��ǰ���������ڶ�
    input  rst, 
    input  ena,                          
    input  rf_w,                //д�룬�ߵ�ƽ��Ч
    input  [4:0] RdC,           //Rd��ַ
    input  [4:0] RtC,           //Rt��ַ
    input  [4:0] RsC,           //Rs��ַ
    input  [31:0] Rd_in,        //Rd
    output [31:0] Rs_out,       //Rs
    output [31:0] Rt_out        //Rt
    );

reg [31:0] array_reg [31:0];    //�Ĵ�����
/*�첽��ȡ */
assign Rs_out = ena ? array_reg[RsC] : 32'bz;
assign Rt_out = ena ? array_reg[RtC] : 32'bz; 

/* ͬ��д�� */
always @(negedge clk or posedge rst)  //��λ�ź������ػ�ʱ����������Ч
begin
    if(rst && ena)    //��λ
    begin
        array_reg[0]  <= 32'h0;
        array_reg[1]  <= 32'h0;
        array_reg[2]  <= 32'h0;
        array_reg[3]  <= 32'h0;
        array_reg[4]  <= 32'h0;
        array_reg[5]  <= 32'h0;
        array_reg[6]  <= 32'h0;
        array_reg[7]  <= 32'h0;
        array_reg[8]  <= 32'h0;
        array_reg[9]  <= 32'h0;
        array_reg[10] <= 32'h0;
        array_reg[11] <= 32'h0;
        array_reg[12] <= 32'h0;
        array_reg[13] <= 32'h0;
        array_reg[14] <= 32'h0;
        array_reg[15] <= 32'h0;
        array_reg[16] <= 32'h0;
        array_reg[17] <= 32'h0;
        array_reg[18] <= 32'h0;
        array_reg[19] <= 32'h0;
        array_reg[20] <= 32'h0;
        array_reg[21] <= 32'h0;
        array_reg[22] <= 32'h0;
        array_reg[23] <= 32'h0;
        array_reg[24] <= 32'h0;
        array_reg[25] <= 32'h0;
        array_reg[26] <= 32'h0;
        array_reg[27] <= 32'h0;
        array_reg[28] <= 32'h0;
        array_reg[29] <= 32'h0;
        array_reg[30] <= 32'h0;
        array_reg[31] <= 32'h0;
    end
    else if(ena && rf_w && (RdC != 5'h0)) //д�루0�żĴ�����0���������޸ģ�
        array_reg[RdC] <= Rd_in;
    else;
end

endmodule