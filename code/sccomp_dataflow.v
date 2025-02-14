`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst, //ָ��
    output [31:0] pc    //ָ���ַ
    );
    /*CPU�ź�*/
    wire [31:0] DM_addr_t,DM_data_w;
    /*DMEM�ź�*/
    wire DM_R,DM_W,CS;
    wire [31:0]DM_data,DM_addr;
    assign DM_addr=DM_addr_t - 32'h10010000;//��ַӳ�䣬ƥ��Mars
    wire LW,LB,LBU,LH,LHU,SW,SH,SB;
    /*IMEM�ź�*/
    wire [31:0]IM_addr;
    assign IM_addr= pc - 32'h00400000;//��ַӳ�䣬ƥ��Mars
    /*CPUʵ����*/
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
    /*DMEMʵ����*/
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
    /*IMEMʵ����*/
    IMEM imem(
        .addr_in(IM_addr[12:2]),//���ֱ�ַ
        .data_out(inst)
    );
endmodule
