`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst, //指令
    output [31:0] pc    //指令地址
    );
    /*CPU信号*/
    wire [31:0] DM_addr_t,DM_data_w;
    /*DMEM信号*/
    wire DM_R,DM_W,CS;
    wire [31:0]DM_data,DM_addr;
    assign DM_addr=DM_addr_t - 32'h10010000;//地址映射，匹配Mars
    wire LW,LB,LBU,LH,LHU,SW,SH,SB;
    /*IMEM信号*/
    wire [31:0]IM_addr;
    assign IM_addr= pc - 32'h00400000;//地址映射，匹配Mars
    /*CPU实例化*/
    CPU sccpu(
        .clk        (clk_in),
        .rst        (reset),
        .instr      (inst),
        .DM_data_in (DM_data),
        .CS         (CS),
        .DM_W       (DM_W),
        .DM_R       (DM_R),
        .PC_out     (pc),
        .DM_addr    (DM_addr_t),
        .DM_data_w  (DM_data_w),
        .LW         (LW),
        .SW         (SW),
        .LB         (LB),
        .LBU        (LBU),
        .LH         (LH),
        .LHU        (LHU),
        .SB         (SB),
        .SH         (SH)
    );
    /*DMEM实例化*/
    DMEM dmem(
        .clk        (clk_in),
        .ena        (CS),
        .wena       (DM_W),
        .rena       (DM_R),
        .LW_FLAG    (LW),   
        .SW_FLAG    (SW),   
        .LB_FLAG    (LB),   
        .LBU_FLAG   (LBU),  
        .LH_FLAG    (LH),   
        .LHU_FLAG   (LHU),  
        .SB_FLAG    (SB),   
        .SH_FLAG    (SH),   
        .addr       (DM_addr[11:0]),
        .data_in    (DM_data_w),
        .data_out   (DM_data)
    );
    /*IMEM实例化*/
    IMEM imem(
        .addr_in(IM_addr[12:2]),//按字编址
        .data_out(inst)
    );
endmodule
