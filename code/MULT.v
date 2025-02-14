`timescale 1ns / 1ps

module MULT(
    input clk,
    input reset,
    input start,
    input [31:0] a,
    input [31:0] b,
    output [63:0] res,
    output busy
    );
    reg busy_t;
    assign busy = busy_t;
    wire [31:0] a_re;
    wire sign;
    assign sign=a[31];
    assign a_re = ~a+1;
    reg [63:0] store[0:31]; 
    reg [63:0]tmp;
    reg [63:0]add_2[0:15];  //2个部分积的和
    reg [63:0]add_4[0:7];   //4个部分积的和
    reg [63:0]add_8[0:3];   //8个部分积的和
    reg [63:0]add_16[0:1];  //16个部分积的和
    reg[2:0] cnt;
    always@(negedge clk or posedge reset)
    begin
        if(reset)begin
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
            busy_t <= 3'b0;
            cnt <= 3'b0;
        end
        else if(start) begin
            busy_t <= 1'b1;
            cnt <= 3'b0; 
        end
        else begin
        if((cnt!=3'b110)&busy_t) begin//累加未到六次
            store[0]  <= b[0]!=1'b0  ? ({b[0],1'b0}==2'b10 ?{{32{(a_re[31]&a[31]?~sign:a_re[31])}},a_re}:{{32{a[31]}},a})        : 64'b0;
            store[1]  <= b[1]!=b[0]  ? ({b[1],b[0]}==2'b10 ?{{31{a_re[31]&a[31]?~sign:a_re[31]}},a_re,1'b0}:{{31{a[31]}},a,1'b0})  : 64'b0;
            store[2]  <= b[2]!=b[1]  ? ({b[2],b[1]}==2'b10 ?{{30{a_re[31]&a[31]?~sign:a_re[31]}},a_re,2'b0}:{{30{a[31]}},a,2'b0})  : 64'b0;
            store[3]  <= b[3]!=b[2]  ? ({b[3],b[2]}==2'b10 ?{{29{a_re[31]&a[31]?~sign:a_re[31]}},a_re,3'b0}:{{29{a[31]}},a,3'b0})  : 64'b0;
            store[4]  <= b[4]!=b[3]  ? ({b[4],b[3]}==2'b10 ?{{28{a_re[31]&a[31]?~sign:a_re[31]}},a_re,4'b0}:{{28{a[31]}},a,4'b0})  : 64'b0;
            store[5]  <= b[5]!=b[4]  ? ({b[5],b[4]}==2'b10 ?{{27{a_re[31]&a[31]?~sign:a_re[31]}},a_re,5'b0}:{{27{a[31]}},a,5'b0})  : 64'b0;
            store[6]  <= b[6]!=b[5]  ? ({b[6],b[5]}==2'b10 ?{{26{a_re[31]&a[31]?~sign:a_re[31]}},a_re,6'b0}:{{26{a[31]}},a,6'b0})  : 64'b0;
            store[7]  <= b[7]!=b[6]  ? ({b[7],b[6]}==2'b10 ?{{25{a_re[31]&a[31]?~sign:a_re[31]}},a_re,7'b0}:{{25{a[31]}},a,7'b0})  : 64'b0;
            store[8]  <= b[8]!=b[7]  ? ({b[8],b[7]}==2'b10 ?{{24{a_re[31]&a[31]?~sign:a_re[31]}},a_re,8'b0}:{{24{a[31]}},a,8'b0})  : 64'b0;
            store[9]  <= b[9]!=b[8]  ? ({b[9],b[8]}==2'b10 ?{{23{a_re[31]&a[31]?~sign:a_re[31]}},a_re,9'b0}:{{23{a[31]}},a,9'b0})  : 64'b0;
            store[10] <= b[10]!=b[9] ? ({b[10],b[9]}==2'b10 ?{{22{a_re[31]&a[31]?~sign:a_re[31]}},a_re,10'b0}:{{22{a[31]}},a,10'b0}) : 64'b0;
            store[11] <= b[11]!=b[10] ? ({b[11],b[10]}==2'b10 ?{{21{a_re[31]&a[31]?~sign:a_re[31]}},a_re,11'b0}:{{21{a[31]}},a,11'b0}) : 64'b0;
            store[12] <= b[12]!=b[11] ? ({b[12],b[11]}==2'b10 ?{{20{a_re[31]&a[31]?~sign:a_re[31]}},a_re,12'b0}:{{20{a[31]}},a,12'b0}) : 64'b0;
            store[13] <= b[13]!=b[12] ? ({b[13],b[12]}==2'b10 ?{{19{a_re[31]&a[31]?~sign:a_re[31]}},a_re,13'b0}:{{19{a[31]}},a,13'b0}) : 64'b0;
            store[14] <= b[14]!=b[13] ? ({b[14],b[13]}==2'b10 ?{{18{a_re[31]&a[31]?~sign:a_re[31]}},a_re,14'b0}:{{18{a[31]}},a,14'b0}) : 64'b0;
            store[15] <= b[15]!=b[14] ? ({b[15],b[14]}==2'b10 ?{{17{a_re[31]&a[31]?~sign:a_re[31]}},a_re,15'b0}:{{17{a[31]}},a,15'b0}) : 64'b0;
            store[16] <= b[16]!=b[15] ? ({b[16],b[15]}==2'b10 ?{{16{a_re[31]&a[31]?~sign:a_re[31]}},a_re,16'b0}:{{16{a[31]}},a,16'b0}) : 64'b0;
            store[17] <= b[17]!=b[16] ? ({b[17],b[16]}==2'b10 ?{{15{a_re[31]&a[31]?~sign:a_re[31]}},a_re,17'b0}:{{15{a[31]}},a,17'b0}) : 64'b0;
            store[18] <= b[18]!=b[17] ? ({b[18],b[17]}==2'b10 ?{{14{a_re[31]&a[31]?~sign:a_re[31]}},a_re,18'b0}:{{14{a[31]}},a,18'b0}) : 64'b0;
            store[19] <= b[19]!=b[18] ? ({b[19],b[18]}==2'b10 ?{{13{a_re[31]&a[31]?~sign:a_re[31]}},a_re,19'b0}:{{13{a[31]}},a,19'b0}) : 64'b0;
            store[20] <= b[20]!=b[19] ? ({b[20],b[19]}==2'b10 ?{{12{a_re[31]&a[31]?~sign:a_re[31]}},a_re,20'b0}:{{12{a[31]}},a,20'b0}) : 64'b0;
            store[21] <= b[21]!=b[20] ? ({b[21],b[20]}==2'b10 ?{{11{a_re[31]&a[31]?~sign:a_re[31]}},a_re,21'b0}:{{11{a[31]}},a,21'b0}) : 64'b0;
            store[22] <= b[22]!=b[21] ? ({b[22],b[21]}==2'b10 ?{{10{a_re[31]&a[31]?~sign:a_re[31]}},a_re,22'b0}:{{10{a[31]}},a,22'b0}): 64'b0;
            store[23] <= b[23]!=b[22] ? ({b[23],b[22]}==2'b10 ?{{9{a_re[31]&a[31]?~sign:a_re[31]}},a_re,23'b0}:{{9{a[31]}},a,23'b0})  : 64'b0;
            store[24] <= b[24]!=b[23] ? ({b[24],b[23]}==2'b10 ?{{8{a_re[31]&a[31]?~sign:a_re[31]}},a_re,24'b0}:{{8{a[31]}},a,24'b0})  : 64'b0;
            store[25] <= b[25]!=b[24] ? ({b[25],b[24]}==2'b10 ?{{7{a_re[31]&a[31]?~sign:a_re[31]}},a_re,25'b0}:{{7{a[31]}},a,25'b0})  : 64'b0;
            store[26] <= b[26]!=b[25] ? ({b[26],b[25]}==2'b10 ?{{6{a_re[31]&a[31]?~sign:a_re[31]}},a_re,26'b0}:{{6{a[31]}},a,26'b0})  : 64'b0;
            store[27] <= b[27]!=b[26] ? ({b[27],b[26]}==2'b10 ?{{5{a_re[31]&a[31]?~sign:a_re[31]}},a_re,27'b0}:{{5{a[31]}},a,27'b0})  : 64'b0;
            store[28] <= b[28]!=b[27] ? ({b[28],b[27]}==2'b10 ?{{4{a_re[31]&a[31]?~sign:a_re[31]}},a_re,28'b0}:{{4{a[31]}},a,28'b0})  : 64'b0;
            store[29] <= b[29]!=b[28] ? ({b[29],b[28]}==2'b10 ?{{3{a_re[31]&a[31]?~sign:a_re[31]}},a_re,29'b0}:{{3{a[31]}},a,29'b0})  : 64'b0;
            store[30] <= b[30]!=b[29] ? ({b[30],b[29]}==2'b10 ?{{2{a_re[31]&a[31]?~sign:a_re[31]}},a_re,30'b0}:{{2{a[31]}},a,30'b0})  : 64'b0;
            store[31] <= b[31]!=b[30] ? ({b[31],b[30]}==2'b10 ?{{1{a_re[31]&a[31]?~sign:a_re[31]}},a_re,31'b0}:{{1{a[31]}},a,31'b0})  : 64'b0;
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
            busy_t <= 1'b1;
        end
        else if(cnt == 3'b110) begin//累加了六次，结束
            cnt <= 0;
            busy_t <= 0;
        end
        else;    
        end
    end
    assign res = tmp;
endmodule
