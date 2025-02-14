`timescale 1ns / 1ps

module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow
    );
    reg[32:0] result;           //多一位用于存储carry
    wire signed [31:0] a1,b1;
    assign a1=a;
    assign b1=b;
    always@(*)
    begin
        casex(aluc)
        4'b0000://Addu
            begin
                result<=a+b;
            end
        4'b0010://Add
            begin
                result<=a1+b1;
            end
        4'b0001://Subu
            begin
                 result<=a-b;
            end
        4'b0011://Sub
            begin
                result<=a1-b1;
            end
        4'b0100://And
            begin
                 result<=a&b;
            end
        4'b0101://Or
            begin
                result<=a|b;
            end
        4'b0110://Xor
            begin
                result<=a^b;
            end
        4'b0111://Nor
            begin
                result<=~(a|b);
            end
        4'b100x://Lui
            begin
                 result<={b[15:0],16'b0};
            end
        4'b1011://Slt
            begin
                result<=(a1<b1)?1:0;
            end
        4'b1010://Sltu
            begin
                 result<=(a<b)?1:0;
            end
        4'b1100://Sra
            begin
                result<=b1>>>a1;
            end
        4'b111x:// Sll/Sla
            begin
                result<=b<<a;
            end
        4'b1101://Srl
            begin
                result<=b>>a;
            end
        default:
            ;
    endcase
    end

assign r = result[31:0];
assign zero = (r == 32'b0) ? 1 : 0;
assign carry = (aluc==4'b1010) ? (a<b) : 
               ((aluc==4'b1100) ? ((a==0)?0:b[a-1]):
               ((aluc==4'b1101) ? ((a==0)?0:b1[a-1]): result[32]));
assign negative = (aluc==4'b1011) ? (a1<b1) : r[31];
assign overflow = (aluc==4'b0010) ? (a1[31]==b1[31])&(r[31]^a1[31]) :
                  (aluc==4'b0011) ? (a1[31]^b1[31])&(r[31]^a1[31]) : 1'b0;
endmodule