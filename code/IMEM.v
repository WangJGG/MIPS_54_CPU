`timescale 1ns / 1ps
module IMEM(
    input [10:0] addr_in,    //地址
    output [31:0] data_out   //指令数据
    ); 

dist_mem_gen_0 imem(    //实例化IP核
    .a(addr_in),    
    .spo(data_out)
    );
    
endmodule