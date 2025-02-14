`timescale 1ns / 1ps

module CP0(
        input clk,
        input rst,
        input MFC0,
        input MTC0,
        input EXCEPTION,
        input ERET,
        input intr,
        input [31:0] pc,
        input [4:0] Rd,
        input [31:0] wdata,
        input [4:0] cause,
        output [31:0] rdata,
        output [31:0] status,
        output [31:0] exc_addr
    );
    reg [31:0]CP0_reg[31:0];
    //�����Ĵ�����ַ
    parameter STATUS = 'd12;
    parameter CAUSE = 'd13;
    parameter EPC = 'd14;
    //�쳣���ͺ�
    parameter SYSCALL = 5'b01000;
    parameter BREAK = 5'b01001;
    parameter TEQ = 5'b01101;
    
    assign exc_addr = CP0_reg[EPC];         //�쳣��ʼ��ַ
    assign rdata = MFC0 ? CP0_reg[Rd]:32'hxxxxxxxx;      //��CP0
    assign status = CP0_reg[STATUS];        //״̬�Ĵ���
    
    always @(posedge clk,posedge rst)begin
        if(rst)begin
            CP0_reg[STATUS] <= 32'b11111; //��λΪ�����κ��ж�
            CP0_reg[CAUSE] <= 32'b0;
            CP0_reg[EPC] <= 32'b0;
        end
        else if(MTC0)
            CP0_reg[Rd] <= wdata;
        else if(ERET)
            CP0_reg[STATUS] <= CP0_reg[STATUS] >> 5;            //�жϷ���,Status�Ĵ�������5λ�ָ�
        else if(EXCEPTION||intr)begin               //�����쳣
            CP0_reg[EPC] <= pc;                     //����ϵ�
            CP0_reg[STATUS] <= CP0_reg[STATUS] << 5;//����Ҫʵ���ж�Ƕ�ף����� 5 λ���ж�
            CP0_reg[CAUSE][6:2] <= cause;
        end
        else;
    end
endmodule
