`timescale 1ns / 1ps

module decoder(
    input [5:0] op,
    input [5:0] func,
    input [4:0] rs,
    /*R type*/
    output ADD_FLAG,            //ADD   
    output ADDU_FLAG,           //ADDU  
    output SUB_FLAG,            //SUB   
    output SUBU_FLAG,           //SUBU  
    output AND_FLAG,            //AND   
    output OR_FLAG,             //OR     
    output XOR_FLAG,            //XOR   
    output NOR_FLAG,            //NOR   
    output SLT_FLAG,            //SLT   
    output SLTU_FLAG,           //SLTU  
    output SLL_FLAG,            //SLL   
    output SRL_FLAG,            //SRL   
    output SRA_FLAG,            //SRA   
    output SLLV_FLAG,           //SLLV  
    output SRLV_FLAG,           //SRLV  
    output SRAV_FLAG,           //SRAV  
    output JR_FLAG,             //JR    
    /*I type*/
    output ADDI_FLAG,           //ADDI  
    output ADDIU_FLAG,          //ADDIU 
    output ANDI_FLAG,           //ANDI  
    output ORI_FLAG,            //ORI   
    output XORI_FLAG,           //XORI  
    output LUI_FLAG,            //LUI   
    output LW_FLAG,             //LW    
    output SW_FLAG,             //SW    
    output BEQ_FLAG,            //BEQ   
    output BNE_FLAG,            //BNE   
    output SLTI_FLAG,           //SLTI  
    output SLTIU_FLAG,          //SLTIU 
    /*J type*/
    output J_FLAG,              //J     
    output JAL_FLAG,            //JAL
    /*Extend type*/
    output DIV_FLAG,            //DIV
    output DIVU_FLAG,           //DIVU
    output MULT_FLAG,           //MULT
    output MULTU_FLAG,          //MULTU
    output BGEZ_FLAG,           //BGEZ
    output JALR_FLAG,           //JALR
    output LBU_FLAG,            //LBU
    output LHU_FLAG,            //LHU
    output LB_FLAG,             //LB
    output LH_FLAG,             //LH
    output SB_FLAG,             //SB
    output SH_FLAG,             //SH
    output BREAK_FLAG,          //BREAK
    output SYSCALL_FLAG,        //SYSCALL
    output ERET_FLAG,           //ERET
    output TEQ_FLAG,            //TEQ
    output MFHI_FLAG,           //MFHI
    output MFLO_FLAG,           //MFLO
    output MTHI_FLAG,           //MTHI
    output MTLO_FLAG,           //MTLO
    output MFC0_FLAG,           //MFC0
    output MTC0_FLAG,           //MTC0
    output CLZ_FLAG             //CLZ
    );
    /*op code*/
    parameter R_EX1    = 6'b000000;
    parameter R_EX2    = 6'b010000;
    parameter ADDI_OP  = 6'b001000;
    parameter ADDIU_OP = 6'b001001;
    parameter ANDI_OP  = 6'b001100;
    parameter ORI_OP   = 6'b001101;
    parameter XORI_OP  = 6'b001110;
    parameter LUI_OP   = 6'b001111;
    parameter LW_OP    = 6'b100011;
    parameter SW_OP    = 6'b101011;
    parameter BEQ_OP   = 6'b000100;
    parameter BNE_OP   = 6'b000101;
    parameter SLTI_OP  = 6'b001010;
    parameter SLTIU_OP = 6'b001011;
    parameter J_OP     = 6'b000010;
    parameter JAL_OP   = 6'b000011;
    parameter LBU_OP   = 6'b100100;
    parameter LHU_OP   = 6'b100101;
    parameter LB_OP    = 6'b100000;
    parameter LH_OP    = 6'b100001;
    parameter SB_OP    = 6'b101000;
    parameter SH_OP    = 6'b101001;
    parameter BGEZ_OP  = 6'b000001;
    parameter CLZ_OP   = 6'b011100;
    /*func code*/
    parameter ADD_FUNC  = 6'b100000;
    parameter ADDU_FUNC = 6'b100001;
    parameter SUB_FUNC  = 6'b100010;
    parameter SUBU_FUNC = 6'b100011;
    parameter AND_FUNC  = 6'b100100;
    parameter OR_FUNC   = 6'b100101;
    parameter XOR_FUNC  = 6'b100110;
    parameter NOR_FUNC  = 6'b100111;
    parameter SLT_FUNC  = 6'b101010;
    parameter SLTU_FUNC = 6'b101011;
    parameter SLL_FUNC  = 6'b000000;
    parameter SRL_FUNC  = 6'b000010;
    parameter SRA_FUNC  = 6'b000011;
    parameter SLLV_FUNC = 6'b000100;
    parameter SRLV_FUNC = 6'b000110;
    parameter SRAV_FUNC = 6'b000111;
    parameter JR_FUNC   = 6'b001000;
    parameter JALR_FUNC = 6'b001001;
    parameter DIV_FUNC  = 6'b011010;
    parameter DIVU_FUNC = 6'b011011;
    parameter MULT_FUNC = 6'b011000;
    parameter MULTU_FUNC= 6'b011001;
    parameter BREAK_FUNC= 6'b001101;
    parameter SYSCALL_FUNC= 6'b001100;
    parameter TEQ_FUNC  = 6'b110100;
    parameter MFHI_FUNC = 6'b010000;
    parameter MFLO_FUNC = 6'b010010;
    parameter MTHI_FUNC = 6'b010001;
    parameter MTLO_FUNC = 6'b010011;
    parameter CLZ_FUNC  = 6'b100000;
    parameter ERET_FUNC = 6'b011000;
    /*other*/
    parameter MFC0_EX = 5'b00000;
    parameter MTC0_EX = 5'b00100;
    
    /*DECODE*/
    /*R type*/
    assign ADD_FLAG   = ((op == R_EX1) && (func == ADD_FUNC )) ? 1'b1 : 1'b0;
    assign ADDU_FLAG  = ((op == R_EX1) && (func == ADDU_FUNC)) ? 1'b1 : 1'b0;
    assign SUB_FLAG   = ((op == R_EX1) && (func == SUB_FUNC )) ? 1'b1 : 1'b0;
    assign SUBU_FLAG  = ((op == R_EX1) && (func == SUBU_FUNC)) ? 1'b1 : 1'b0;
    assign AND_FLAG   = ((op == R_EX1) && (func == AND_FUNC )) ? 1'b1 : 1'b0;
    assign OR_FLAG    = ((op == R_EX1) && (func == OR_FUNC  )) ? 1'b1 : 1'b0;
    assign XOR_FLAG   = ((op == R_EX1) && (func == XOR_FUNC )) ? 1'b1 : 1'b0;
    assign NOR_FLAG   = ((op == R_EX1) && (func == NOR_FUNC )) ? 1'b1 : 1'b0;
    assign SLT_FLAG   = ((op == R_EX1) && (func == SLT_FUNC )) ? 1'b1 : 1'b0;
    assign SLTU_FLAG  = ((op == R_EX1) && (func == SLTU_FUNC)) ? 1'b1 : 1'b0;
    assign SLL_FLAG   = ((op == R_EX1) && (func == SLL_FUNC )) ? 1'b1 : 1'b0;
    assign SRL_FLAG   = ((op == R_EX1) && (func == SRL_FUNC )) ? 1'b1 : 1'b0;
    assign SRA_FLAG   = ((op == R_EX1) && (func == SRA_FUNC )) ? 1'b1 : 1'b0;
    assign SLLV_FLAG  = ((op == R_EX1) && (func == SLLV_FUNC)) ? 1'b1 : 1'b0;
    assign SRLV_FLAG  = ((op == R_EX1) && (func == SRLV_FUNC)) ? 1'b1 : 1'b0;
    assign SRAV_FLAG  = ((op == R_EX1) && (func == SRAV_FUNC)) ? 1'b1 : 1'b0;
    assign JR_FLAG    = ((op == R_EX1) && (func == JR_FUNC  )) ? 1'b1 : 1'b0;
    /*I type*/
    assign ADDI_FLAG  = (op == ADDI_OP ) ? 1'b1 : 1'b0;
    assign ADDIU_FLAG = (op == ADDIU_OP) ? 1'b1 : 1'b0;
    assign ANDI_FLAG  = (op == ANDI_OP ) ? 1'b1 : 1'b0;
    assign ORI_FLAG   = (op == ORI_OP  ) ? 1'b1 : 1'b0;
    assign XORI_FLAG  = (op == XORI_OP ) ? 1'b1 : 1'b0;
    assign LUI_FLAG   = (op == LUI_OP  ) ? 1'b1 : 1'b0;
    assign LW_FLAG    = (op == LW_OP   ) ? 1'b1 : 1'b0;
    assign SW_FLAG    = (op == SW_OP   ) ? 1'b1 : 1'b0;
    assign BEQ_FLAG   = (op == BEQ_OP  ) ? 1'b1 : 1'b0;
    assign BNE_FLAG   = (op == BNE_OP  ) ? 1'b1 : 1'b0;
    assign SLTI_FLAG  = (op == SLTI_OP ) ? 1'b1 : 1'b0;
    assign SLTIU_FLAG = (op == SLTIU_OP) ? 1'b1 : 1'b0;
    /*J type*/
    assign J_FLAG     = (op == J_OP    ) ? 1'b1 : 1'b0;
    assign JAL_FLAG   = (op == JAL_OP  ) ? 1'b1 : 1'b0;
    /*Extend type*/
    assign DIV_FLAG    = ((op == R_EX1) && (func == DIV_FUNC    )) ? 1'b1 : 1'b0;
    assign DIVU_FLAG   = ((op == R_EX1) && (func == DIVU_FUNC   )) ? 1'b1 : 1'b0;
    assign MULT_FLAG   = ((op == R_EX1) && (func == MULT_FUNC   )) ? 1'b1 : 1'b0;
    assign MULTU_FLAG  = ((op == R_EX1) && (func == MULTU_FUNC  )) ? 1'b1 : 1'b0;
    assign JALR_FLAG   = ((op == R_EX1) && (func == JALR_FUNC   )) ? 1'b1 : 1'b0;
    assign BREAK_FLAG  = ((op == R_EX1) && (func == BREAK_FUNC  )) ? 1'b1 : 1'b0;
    assign SYSCALL_FLAG= ((op == R_EX1) && (func == SYSCALL_FUNC)) ? 1'b1 : 1'b0;
    assign TEQ_FLAG    = ((op == R_EX1) && (func == TEQ_FUNC    )) ? 1'b1 : 1'b0;
    assign MFHI_FLAG   = ((op == R_EX1) && (func == MFHI_FUNC   )) ? 1'b1 : 1'b0;
    assign MFLO_FLAG   = ((op == R_EX1) && (func == MFLO_FUNC   )) ? 1'b1 : 1'b0;
    assign MTHI_FLAG   = ((op == R_EX1) && (func == MTHI_FUNC   )) ? 1'b1 : 1'b0;
    assign MTLO_FLAG   = ((op == R_EX1) && (func == MTLO_FUNC   )) ? 1'b1 : 1'b0;
    assign ERET_FLAG   = ((op == R_EX2) && (func == ERET_FUNC   )) ? 1'b1 : 1'b0;
    assign MTC0_FLAG   = ((op == R_EX2) && (func == MTC0_EX) && (rs == MTC0_EX)) ? 1'b1 : 1'b0;
    assign MFC0_FLAG   = ((op == R_EX2) && (func == MFC0_EX) && (rs == MFC0_EX)) ? 1'b1 : 1'b0;
    assign CLZ_FLAG    = ((op == CLZ_OP) && (func == CLZ_FUNC   )) ? 1'b1 : 1'b0;
    assign LBU_FLAG    = (op == LBU_OP ) ? 1'b1 : 1'b0;
    assign LHU_FLAG    = (op == LHU_OP ) ? 1'b1 : 1'b0;
    assign LB_FLAG     = (op == LB_OP  ) ? 1'b1 : 1'b0;
    assign LH_FLAG     = (op == LH_OP  ) ? 1'b1 : 1'b0;
    assign SB_FLAG     = (op == SB_OP  ) ? 1'b1 : 1'b0;
    assign SH_FLAG     = (op == SH_OP  ) ? 1'b1 : 1'b0;
    assign BGEZ_FLAG   = (op == BGEZ_OP) ? 1'b1 : 1'b0;
endmodule
