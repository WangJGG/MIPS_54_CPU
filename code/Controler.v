`timescale 1ns / 1ps

module Controler(
    input clk,
    input rst,
    /*R type*/
    input ADD_FLAG,            //ADD   
    input ADDU_FLAG,           //ADDU  
    input SUB_FLAG,            //SUB   
    input SUBU_FLAG,           //SUBU  
    input AND_FLAG,            //AND   
    input OR_FLAG,             //OR     
    input XOR_FLAG,            //XOR   
    input NOR_FLAG,            //NOR   
    input SLT_FLAG,            //SLT   
    input SLTU_FLAG,           //SLTU  
    input SLL_FLAG,            //SLL   
    input SRL_FLAG,            //SRL   
    input SRA_FLAG,            //SRA   
    input SLLV_FLAG,           //SLLV  
    input SRLV_FLAG,           //SRLV  
    input SRAV_FLAG,           //SRAV  
    input JR_FLAG,             //JR    
    /*I type*/
    input ADDI_FLAG,           //ADDI  
    input ADDIU_FLAG,          //ADDIU 
    input ANDI_FLAG,           //ANDI  
    input ORI_FLAG,            //ORI   
    input XORI_FLAG,           //XORI  
    input LUI_FLAG,            //LUI   
    input LW_FLAG,             //LW    
    input SW_FLAG,             //SW    
    input BEQ_FLAG,            //BEQ   
    input BNE_FLAG,            //BNE   
    input SLTI_FLAG,           //SLTI  
    input SLTIU_FLAG,          //SLTIU 
    /*J type*/
    input J_FLAG,              //J     
    input JAL_FLAG,            //JAL 
    /*Extend type*/
    input DIV_FLAG,            //DIV
    input DIVU_FLAG,           //DIVU
    input MULT_FLAG,           //MULT
    input MULTU_FLAG,          //MULTU
    input BGEZ_FLAG,           //BGEZ
    input JALR_FLAG,           //JALR
    input LBU_FLAG,            //LBU
    input LHU_FLAG,            //LHU
    input LB_FLAG,             //LB
    input LH_FLAG,             //LH
    input SB_FLAG,             //SB
    input SH_FLAG,             //SH
    input BREAK_FLAG,          //BREAK
    input SYSCALL_FLAG,        //SYSCALL
    input ERET_FLAG,           //ERET
    input TEQ_FLAG,            //TEQ
    input MFHI_FLAG,           //MFHI
    input MFLO_FLAG,           //MFLO
    input MTHI_FLAG,           //MTHI
    input MTLO_FLAG,           //MTLO
    input MFC0_FLAG,           //MFC0
    input MTC0_FLAG,           //MTC0
    input CLZ_FLAG,             //CLZ
    /*alu控制信号*/ 
    input Zero,
    input Negative,
    /*MUL和DIV的busy信号*/
    input MULT_busy,
    input MULTU_busy,
    input DIV_busy,
    input DIVU_busy,
    /*MUX*/
    output [1:0] M1,
    output [2:0] M2,
    output [2:0] M3,
    output M4,
    output [2:0] M5,
    output [1:0] M6,
    output M7,
    output [2:0] M8,
    output [2:0] M9,
    output [1:0] M10,
    /*PC*/
    output PCin,
    output PCout,
    /*aluc*/
    output [3:0] aluc,
    /*Regfiles*/
    output RF_W,                //Regfiles写控制
    /*DMEM*/
    output CS,                  //片选信号
    output DM_R,                //DMEM读控制
    output DM_W,                //DMEM写控制
    /*latch*/
    output Zin,
    output Zout,
    output Yin,
    output Yout,
    /*HI_LO*/
    output HI_W,
    output LO_W,
    /*MUL和DIV*/
    output MULT_start,
    output MULTU_start,
    output DIV_start,
    output DIVU_start,
    /*CP0*/
    output MFC0,
    output MTC0,
    output ERET,
    output EXCEPTION,
    //output INTR   没有用到
    /*STATE*/
    output reg [2:0] state
    );
    parameter 
    T0 = 3'b000,
    T1 = 3'b001,
    T2 = 3'b011,
    T3 = 3'b010,
    T4 = 3'b110,
    T5 = 3'b111;
    wire t3_t1,t4_t5,stay_t4;
    assign t3_t1 = JR_FLAG || MFLO_FLAG|| MFHI_FLAG|| MTLO_FLAG || MTHI_FLAG || MTC0_FLAG || MFC0_FLAG || 
                   (BEQ_FLAG & !Zero) || (BNE_FLAG & Zero) || (BGEZ_FLAG & Negative) || ERET_FLAG || (TEQ_FLAG & !Zero);
    assign t4_t5 = (BEQ_FLAG) || (BNE_FLAG) || (BGEZ_FLAG) || (TEQ_FLAG) || LW_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG;
    assign stay_t4 = (MULT_FLAG & MULT_busy)||(MULTU_FLAG & MULTU_busy) || (DIV_FLAG & DIV_busy) || (DIVU_FLAG & DIVU_busy);
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            state <= T0;
        end
        else begin
            case(state)
                T0:begin
                    state <= T1;
                end
                T1:begin
                    state <= T2;
                end
                T2:begin
                    state <= T3;
                end
                T3:begin
                    if(t3_t1) begin//三个机器周期的情况
                        state <= T1;
                    end
                    else begin
                        state <= T4;
                    end
                end
                T4:begin
                    if(t4_t5) begin//需要五个周期的情况
                        state <= T5;
                    end
                    else if(stay_t4) begin//需要等待的情况
                        state <= T4;
                    end
                    else begin//大部分指令的情况
                        state <= T1;
                    end
                end
                T5:begin
                    state <= T1;
                end
            endcase
        end
    end
    
    
    /*DMEM*/
    assign CS      = (LW_FLAG || SW_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG || SB_FLAG || SH_FLAG) && (state==T4);
    assign DM_R    = (LW_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG ||LHU_FLAG) && (state==T4);
    assign DM_W    = (SW_FLAG || SB_FLAG || SH_FLAG) && (state==T4);
    /*ALU*/
    assign aluc[3] = (SLT_FLAG || SLTU_FLAG || SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG ||
                     SRAV_FLAG || LUI_FLAG || SLTI_FLAG || SLTIU_FLAG) && (state == T3);
    assign aluc[2] = (AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || 
                      SRLV_FLAG || SRAV_FLAG || ANDI_FLAG || ORI_FLAG || XORI_FLAG) && (state == T3);
    assign aluc[1] = (state == T1) || ((ADD_FLAG || SUB_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG || SLL_FLAG || SLLV_FLAG || 
                      ADDI_FLAG || XORI_FLAG || LW_FLAG || SW_FLAG || SLTI_FLAG || SLTIU_FLAG || BGEZ_FLAG || JAL_FLAG || LB_FLAG || LBU_FLAG ||
                      LH_FLAG || LHU_FLAG || SB_FLAG || SH_FLAG )&&(state == T3)) || 
                      ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG) && (state == T4));
    assign aluc[0] = ((SUB_FLAG || SUBU_FLAG || OR_FLAG || NOR_FLAG || SLT_FLAG || SRL_FLAG || SRLV_FLAG || ORI_FLAG ||
                      BEQ_FLAG || BNE_FLAG || SLTI_FLAG || BGEZ_FLAG || TEQ_FLAG)&&(state == T3));
    /*RF*/
    assign RF_W    = ((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                      SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG || ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG|| XORI_FLAG ||
                      LUI_FLAG || SLTI_FLAG || SLTIU_FLAG || JAL_FLAG || CLZ_FLAG)&&(state == T4))||
                      ((MFLO_FLAG || MFHI_FLAG || MFC0_FLAG || JALR_FLAG)&&(state == T3)) ||
                      ((LW_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG) && (state == T5));
    /*PC*/
    assign PCin  =  (state == T2) || ((JR_FLAG || ERET_FLAG) && (state==T3)) || ((J_FLAG || JAL_FLAG || JALR_FLAG || BREAK_FLAG || SYSCALL_FLAG)&&(state == T4)) ||
                    ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG || TEQ_FLAG)&&(state == T5));
    assign PCout = (state == T1) ||((JALR_FLAG || BREAK_FLAG || SYSCALL_FLAG)&&(state == T3))||((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG || TEQ_FLAG) && (state == T4));
    
    /*Latch*/
    assign Zin = (state == T1) || (!(JR_FLAG || J_FLAG || MULT_FLAG ||  MULTU_FLAG || DIV_FLAG || DIVU_FLAG || MFLO_FLAG || MFHI_FLAG ||
                  MTLO_FLAG || MTHI_FLAG || MFC0_FLAG || MTC0_FLAG || JALR_FLAG || BREAK_FLAG || SYSCALL_FLAG || ERET_FLAG || TEQ_FLAG) && (state == T3))||
                  ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG) && (state == T4));
    assign Zout= (state == T2) || ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG) && (state == T5))||
                 ((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                   SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG || ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG|| XORI_FLAG ||
                   LUI_FLAG || LW_FLAG || SW_FLAG || SLTI_FLAG || SLTIU_FLAG ||  JAL_FLAG || CLZ_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG ||
                   SB_FLAG || SH_FLAG) && (state == T4));
    assign Yin = ((J_FLAG || JAL_FLAG)&&(state == T3)); 
    assign Yout= ((J_FLAG || JAL_FLAG)&&(state == T4)); 
    
    /*HI_LO*/
    assign HI_W = ((MULT_FLAG || MULTU_FLAG || DIV_FLAG || DIVU_FLAG)&&(state == T4))||((MTHI_FLAG)&&(state == T3));
    assign LO_W = ((MULT_FLAG || MULTU_FLAG || DIV_FLAG || DIVU_FLAG)&&(state == T4))||((MTLO_FLAG)&&(state == T3));
    
    /*CP0*/
    assign MFC0 = (MFC0_FLAG && (state == T3));
    assign MTC0 = (MTC0_FLAG && (state == T3));
    assign ERET = (ERET_FLAG && (state == T3));
    assign EXCEPTION = ((BREAK_FLAG || SYSCALL_FLAG)&&(state==T3))||((TEQ_FLAG)&&(state==T4));

    /*MUX/DIV*/
    assign MULT_start = (MULT_FLAG && (state == T3));
    assign MULTU_start = (MULTU_FLAG && (state == T3));
    assign DIV_start = (DIV_FLAG && (state == T3));
    assign DIVU_start = (DIVU_FLAG && (state == T3));
    
    /*MUX*/
    assign M1[1]=((SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG)&&(state==T3));
    assign M1[0]=((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                   ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG || XORI_FLAG || LUI_FLAG || LW_FLAG || SW_FLAG || BEQ_FLAG || BNE_FLAG ||
                   SLTI_FLAG || SLTIU_FLAG || BGEZ_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG || SB_FLAG || SH_FLAG || TEQ_FLAG)&&(state == T3));
    
    assign M2[2]=(state == T1) || ((JAL_FLAG || BGEZ_FLAG) && (state == T3));
    assign M2[1]=((ANDI_FLAG || ORI_FLAG || XORI_FLAG || LUI_FLAG) && (state == T3)) || ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG)&&(state == T4));
    assign M2[0]=((ADDI_FLAG || ADDIU_FLAG || LW_FLAG || SW_FLAG || SLTI_FLAG || SLTIU_FLAG || BGEZ_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG ||
                   LHU_FLAG || SB_FLAG || SH_FLAG)&&(state == T3)) || ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG)&&(state == T4));
    
    assign M3[2]=(ERET_FLAG && (state == T3));
    assign M3[1]=(state == T2) || ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG || TEQ_FLAG)&&(state == T5)) || ((BREAK_FLAG || SYSCALL_FLAG)&&(state == T4));
    assign M3[0]=((J_FLAG || JAL_FLAG || BREAK_FLAG || SYSCALL_FLAG) && (state == T4))||(TEQ_FLAG && (state == T5));
    
    assign M4   = (state == T1) || 
                  ((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                   SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG || ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG|| XORI_FLAG ||
                   LUI_FLAG || LW_FLAG || SW_FLAG || BEQ_FLAG || BNE_FLAG || SLTI_FLAG || SLTIU_FLAG || JAL_FLAG || BGEZ_FLAG || LB_FLAG || LBU_FLAG ||
                   LH_FLAG || LHU_FLAG || SB_FLAG || SH_FLAG || TEQ_FLAG) && (state == T3))||
                   ((BEQ_FLAG || BNE_FLAG || BGEZ_FLAG) && (state == T4));
    assign M5[2]=((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                   SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG || ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG||
                   XORI_FLAG || LUI_FLAG || SLTI_FLAG || SLTIU_FLAG || JAL_FLAG || CLZ_FLAG ) && (state == T4)) || ( (LW_FLAG || LB_FLAG || LBU_FLAG 
                   || LH_FLAG || LHU_FLAG) && (state == T5));
    assign M5[1]=((MFLO_FLAG || MFHI_FLAG) && (state == T3));
    assign M5[0]=((ADD_FLAG || ADDU_FLAG || SUB_FLAG || SUBU_FLAG || AND_FLAG || OR_FLAG || XOR_FLAG || NOR_FLAG || SLT_FLAG || SLTU_FLAG ||
                   SLL_FLAG || SRL_FLAG || SRA_FLAG || SLLV_FLAG || SRLV_FLAG || SRAV_FLAG || ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG||
                   XORI_FLAG || LUI_FLAG || SLTI_FLAG || SLTIU_FLAG || JAL_FLAG || CLZ_FLAG) && (state == T4)) || (( MFHI_FLAG || MFC0_FLAG) && (state == T3));
    
    assign M6[1]=((JAL_FLAG) && (state == T4));
    assign M6[0]=((ADDI_FLAG || ADDIU_FLAG || ANDI_FLAG || ORI_FLAG || XORI_FLAG || LUI_FLAG || SW_FLAG ||
                  SLTI_FLAG || SLTIU_FLAG || SB_FLAG || SH_FLAG) && (state == T4))||
                  ((LW_FLAG || LB_FLAG || LBU_FLAG || LH_FLAG || LHU_FLAG) && (state == T5)) ||
                  ( MFC0_FLAG && (state == T3));
    
    assign M7   =((SLLV_FLAG || SRLV_FLAG ||SRAV_FLAG) && (state == T3));
    
    assign M8[2]=(DIVU_FLAG && (state == T4));
    assign M8[1]=((MULTU_FLAG || DIV_FLAG) && (state == T4));
    assign M8[0]=((MULT_FLAG || DIV_FLAG) && (state == T4));
    
    assign M9[2]=(DIVU_FLAG && (state == T4));
    assign M9[1]=((MULTU_FLAG || DIV_FLAG) && (state == T4));
    assign M9[0]=((MULT_FLAG || DIV_FLAG) && (state == T4));
    
    assign M10[1]=(TEQ_FLAG && (state == T4));
    assign M10[0]=(SYSCALL_FLAG && (state == T3));
endmodule
