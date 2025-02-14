`timescale 1ns / 1ps
/*做出修改，地址线位数再说*/
module DMEM(
    input clk,
    input ena,              //高电平有效
    input wena,             //高电平有效
    input rena,             //高电平有效
    input LW_FLAG,          //load word
    input SW_FLAG,          //save word
    input LB_FLAG,          //load byte(signed)
    input LBU_FLAG,         //load byte
    input LH_FLAG,          //load half_word(signed)
    input LHU_FLAG,         //load half_word
    input SB_FLAG,          //save byte
    input SH_FLAG,          //save half_word
    input [11:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    reg [31:0]store[1023:0];
    always@(posedge clk)
    begin
       if(ena) begin
            if(wena) begin
                if(SW_FLAG) begin
                    store[addr[11:2]] <= data_in;
                end
                else if(SH_FLAG) begin
                    case(addr[1])
                        1'b0: store[addr[11:2]][15:0]   <=data_in[15:0];
                        1'b1: store[addr[11:2]][31:16]  <=data_in[15:0];
                     endcase
                end
                else if(SB_FLAG) begin
                    case(addr[1:0])
                        2'b00: store[addr[11:2]][7:0]   <=data_in[7:0];
                        2'b01: store[addr[11:2]][15:8]  <=data_in[7:0];
                        2'b10: store[addr[11:2]][23:16] <=data_in[7:0];
                        2'b11: store[addr[11:2]][31:24] <=data_in[7:0];
                    endcase
                end
                else;
            end
            else if(rena) begin
                if(LW_FLAG) begin
                    data_out <= store[addr[11:2]];
                end
                else if(LH_FLAG||LHU_FLAG) begin
                    case(addr[1])
                        1'b0: data_out <= LH_FLAG ? {{16{store[addr[11:2]][15]}},store[addr[11:2]][15:0]} : {16'b0,store[addr[11:2]][15:0]};
                        1'b1: data_out <= LH_FLAG ? {{16{store[addr[11:2]][31]}},store[addr[11:2]][31:16]} : {16'b0,store[addr[11:2]][31:16]};
                    endcase
                end
                else if(LB_FLAG||LBU_FLAG) begin
                    case(addr[1:0])
                        2'b00: data_out <= LB_FLAG ? {{24{store[addr[11:2]][7]}},store[addr[11:2]][7:0]} : {24'b0,store[addr[11:2]][7:0]};
                        2'b01: data_out <= LB_FLAG ? {{24{store[addr[11:2]][15]}},store[addr[11:2]][15:8]} : {24'b0,store[addr[11:2]][15:8]};
                        2'b10: data_out <= LB_FLAG ? {{24{store[addr[11:2]][23]}},store[addr[11:2]][23:16]} : {24'b0,store[addr[11:2]][23:16]};
                        2'b11: data_out <= LB_FLAG ? {{24{store[addr[11:2]][31]}},store[addr[11:2]][31:24]} : {24'b0,store[addr[11:2]][31:24]};
                    endcase                   
                end
                else;
            end
       end
    end
endmodule
