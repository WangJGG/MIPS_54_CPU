`timescale 1ns / 1ps

module CLZ(
    input [31:0] CLZ_in,   
    output reg [31:0] res
    );

always @(*) begin
    if (CLZ_in[31] == 1'b1)                          res <= 0;
    else if(CLZ_in[30] == 1'b1 && CLZ_in[31] == 0)   res <= 1;
    else if(CLZ_in[29] == 1'b1 && CLZ_in[31:30] == 0)res <= 2;
    else if(CLZ_in[28] == 1'b1 && CLZ_in[31:29] == 0)res <= 3;
    else if(CLZ_in[27] == 1'b1 && CLZ_in[31:28] == 0)res <= 4;
    else if(CLZ_in[26] == 1'b1 && CLZ_in[31:27] == 0)res <= 5;
    else if(CLZ_in[25] == 1'b1 && CLZ_in[31:26] == 0)res <= 6;
    else if(CLZ_in[24] == 1'b1 && CLZ_in[31:25] == 0)res <= 7;
    else if(CLZ_in[23] == 1'b1 && CLZ_in[31:24] == 0)res <= 8;
    else if(CLZ_in[22] == 1'b1 && CLZ_in[31:23] == 0)res <= 9;
    else if(CLZ_in[21] == 1'b1 && CLZ_in[31:22] == 0)res <= 10;
    else if(CLZ_in[20] == 1'b1 && CLZ_in[31:21] == 0)res <= 11;
    else if(CLZ_in[19] == 1'b1 && CLZ_in[31:20] == 0)res <= 12;
    else if(CLZ_in[18] == 1'b1 && CLZ_in[31:19] == 0)res <= 13;
    else if(CLZ_in[17] == 1'b1 && CLZ_in[31:18] == 0)res <= 14;
    else if(CLZ_in[16] == 1'b1 && CLZ_in[31:17] == 0)res <= 15;
    else if(CLZ_in[15] == 1'b1 && CLZ_in[31:16] == 0)res <= 16;
    else if(CLZ_in[14] == 1'b1 && CLZ_in[31:15] == 0)res <= 17;
    else if(CLZ_in[13] == 1'b1 && CLZ_in[31:14] == 0)res <= 18;
    else if(CLZ_in[12] == 1'b1 && CLZ_in[31:13] == 0)res <= 19;
    else if(CLZ_in[11] == 1'b1 && CLZ_in[31:12] == 0)res <= 20;
    else if(CLZ_in[10] == 1'b1 && CLZ_in[31:11] == 0)res <= 21;
    else if(CLZ_in[9] == 1'b1 && CLZ_in[31:10] == 0) res <= 22;
    else if(CLZ_in[8] == 1'b1 && CLZ_in[31: 9] == 0) res <= 23;
    else if(CLZ_in[7] == 1'b1 && CLZ_in[31: 8] == 0) res <= 24;
    else if(CLZ_in[6] == 1'b1 && CLZ_in[31: 7] == 0) res <= 25;
    else if(CLZ_in[5] == 1'b1 && CLZ_in[31: 6] == 0) res <= 26;
    else if(CLZ_in[4] == 1'b1 && CLZ_in[31: 5] == 0) res <= 27;
    else if(CLZ_in[3] == 1'b1 && CLZ_in[31: 4] == 0) res <= 28;
    else if(CLZ_in[2] == 1'b1 && CLZ_in[31: 3] == 0) res <= 29;
    else if(CLZ_in[1] == 1'b1 && CLZ_in[31: 2] == 0) res <= 30;
    else if(CLZ_in[0] == 1'b1 && CLZ_in[31: 1] == 0) res <= 31;
    else if(CLZ_in == 0)                             res <= 32;
end

endmodule