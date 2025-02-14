`timescale 1ns / 1ps

module MULTU(
    input clk,
    input reset,
    input start,
    input [31:0] a,
    input [31:0] b,
    output [63:0] res,
    output reg busy
    );
    reg [63:0] store[0:31];
    reg [63:0]tmp;
    reg [63:0]add_2[0:15];  //2个部分积的和
    reg [63:0]add_4[0:7];   //4个部分积的和
    reg [63:0]add_8[0:3];   //8个部分积的和
    reg [63:0]add_16[0:1];  //16个部分积的和
    reg [2:0] cnt;
    always@(posedge clk or posedge reset)
    begin
        if(reset)begin
            cnt <= 3'b0;
            tmp <= 0;
            store[0] <= 0;
            store[1] <= 0;
            store[2] <= 0;
            store[3] <= 0;
            store[4] <= 0;
            store[5] <= 0;
            store[6] <= 0;
            store[7] <= 0;
            store[8] <= 0;
            store[9] <= 0;
            store[10] <= 0;
            store[11] <= 0;
            store[12] <= 0;
            store[13] <= 0;
            store[14] <= 0;
            store[15] <= 0;
            store[16] <= 0;
            store[17] <= 0;
            store[18] <= 0;
            store[19] <= 0;
            store[20] <= 0;
            store[21] <= 0;
            store[22] <= 0;
            store[23] <= 0;
            store[24] <= 0;
            store[25] <= 0;
            store[26] <= 0;
            store[27] <= 0;
            store[28] <= 0;
            store[29] <= 0;
            store[30] <= 0;
            store[31] <= 0;
            add_2[0] <= 0;
            add_2[1] <= 0;
            add_2[2] <= 0;
            add_2[3] <= 0;
            add_2[4] <= 0;
            add_2[5] <= 0;
            add_2[6] <= 0;
            add_2[7] <= 0;
            add_2[8] <= 0;
            add_2[9] <= 0;
            add_2[10] <= 0;
            add_2[11] <= 0;
            add_2[12] <= 0;
            add_2[13] <= 0;
            add_2[14] <= 0;
            add_2[15] <= 0;
            add_4[0] <= 0;
            add_4[1] <= 0;
            add_4[2] <= 0;
            add_4[3] <= 0;
            add_4[4] <= 0;
            add_4[5] <= 0;
            add_4[6] <= 0;
            add_4[7] <= 0;
            add_8[0] <= 0;
            add_8[1] <= 0;
            add_8[2] <= 0;
            add_8[3] <= 0;
            add_16[0] <= 0;
            add_16[1] <= 0;
            busy <= 0;
        end
        else if(start) begin
            cnt <= 3'b0;
            busy <= 1'b1;
        end
        else begin
        if(cnt!=3'b110 & busy) begin//累加次数未到六次
            store[0]  <= b[0]  ? {32'b0, a}        : 64'b0;
            store[1]  <= b[1]  ? {31'b0, a, 1'b0}  : 64'b0;
            store[2]  <= b[2]  ? {30'b0, a, 2'b0}  : 64'b0;
            store[3]  <= b[3]  ? {29'b0, a, 3'b0}  : 64'b0;
            store[4]  <= b[4]  ? {28'b0, a, 4'b0}  : 64'b0;
            store[5]  <= b[5]  ? {27'b0, a, 5'b0}  : 64'b0;
            store[6]  <= b[6]  ? {26'b0, a, 6'b0}  : 64'b0;
            store[7]  <= b[7]  ? {25'b0, a, 7'b0}  : 64'b0;
            store[8]  <= b[8]  ? {24'b0, a, 8'b0}  : 64'b0;
            store[9]  <= b[9]  ? {23'b0, a, 9'b0}  : 64'b0;
            store[10] <= b[10] ? {22'b0, a, 10'b0} : 64'b0;
            store[11] <= b[11] ? {21'b0, a, 11'b0} : 64'b0;
            store[12] <= b[12] ? {20'b0, a, 12'b0} : 64'b0;
            store[13] <= b[13] ? {19'b0, a, 13'b0} : 64'b0;
            store[14] <= b[14] ? {18'b0, a, 14'b0} : 64'b0;
            store[15] <= b[15] ? {17'b0, a, 15'b0} : 64'b0;
            store[16] <= b[16] ? {16'b0, a, 16'b0} : 64'b0;
            store[17] <= b[17] ? {15'b0, a, 17'b0} : 64'b0;
            store[18] <= b[18] ? {14'b0, a, 18'b0} : 64'b0;
            store[19] <= b[19] ? {13'b0, a, 19'b0} : 64'b0;
            store[20] <= b[20] ? {12'b0, a, 20'b0} : 64'b0;
            store[21] <= b[21] ? {11'b0, a, 21'b0} : 64'b0;
            store[22] <= b[22] ? {10'b0, a, 22'b0} : 64'b0;
            store[23] <= b[23] ? {9'b0, a, 23'b0}  : 64'b0;
            store[24] <= b[24] ? {8'b0, a, 24'b0}  : 64'b0;
            store[25] <= b[25] ? {7'b0, a, 25'b0}  : 64'b0;
            store[26] <= b[26] ? {6'b0, a, 26'b0}  : 64'b0;
            store[27] <= b[27] ? {5'b0, a, 27'b0}  : 64'b0;
            store[28] <= b[28] ? {4'b0, a, 28'b0}  : 64'b0;
            store[29] <= b[29] ? {3'b0, a, 29'b0}  : 64'b0;
            store[30] <= b[30] ? {2'b0, a, 30'b0}  : 64'b0;
            store[31] <= b[31] ? {1'b0, a, 31'b0}  : 64'b0;
            add_2[0]  <= store[0]  + store[1];
            add_2[1]  <= store[2]  + store[3];
            add_2[2]  <= store[4]  + store[5];
            add_2[3]  <= store[6]  + store[7];
            add_2[4]  <= store[8]  + store[9];
            add_2[5]  <= store[10] + store[11];
            add_2[6]  <= store[12] + store[13];
            add_2[7]  <= store[14] + store[15];
            add_2[8]  <= store[16] + store[17];
            add_2[9]  <= store[18] + store[19];
            add_2[10] <= store[20] + store[21];
            add_2[11] <= store[22] + store[23];
            add_2[12] <= store[24] + store[25];
            add_2[13] <= store[26] + store[27];
            add_2[14] <= store[28] + store[29];
            add_2[15] <= store[30] + store[31];
            add_4[0]  <= add_2[0]  + add_2[1];
            add_4[1]  <= add_2[2]  + add_2[3];
            add_4[2]  <= add_2[4]  + add_2[5];
            add_4[3]  <= add_2[6]  + add_2[7];
            add_4[4]  <= add_2[8]  + add_2[9];
            add_4[5]  <= add_2[10] + add_2[11];
            add_4[6]  <= add_2[12] + add_2[13];
            add_4[7]  <= add_2[14] + add_2[15];
            add_8[0]  <= add_4[0]  + add_4[1];
            add_8[1]  <= add_4[2]  + add_4[3];
            add_8[2]  <= add_4[4]  + add_4[5];
            add_8[3]  <= add_4[6]  + add_4[7];
            add_16[0] <= add_8[0]  + add_8[1];
            add_16[1] <= add_8[2]  + add_8[3];
            tmp       <= add_16[0] + add_16[1];
            cnt <= cnt + 1;//记录累加的次数
        end
        else if(cnt == 3'b110) begin//累加次数已经六次，结束
            busy <= 0;
            cnt <= 0;
        end
        end
    end
    assign res = tmp;
endmodule
