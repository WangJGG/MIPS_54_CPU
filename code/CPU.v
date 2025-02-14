`timescale 1ns / 1ps

module CPU(
    input clk,
    input rst,
    input [31:0] instr,         //读到的指令
    input [31:0] DM_data_in,    //读取到的DMEM的数据
    output CS,                  //DMEM片选信号
    output DM_W,                //DMEM写信号
    output DM_R,                //DMEM读信号
    output reg [31:0] PC_out,       //指令地址
    output [31:0] DM_addr,      //DMEM地址
    output [31:0] DM_data_w,     //DMEM写入的内容 
    output LW,
    output SW,
    output LB,
    output LBU,
    output LH,
    output LHU,
    output SB,
    output SH
    );
    /*指令标识标识与控制信号*/
    /*指令标识*/
    wire ADD_FLAG,ADDU_FLAG,SUB_FLAG,SUBU_FLAG,AND_FLAG,OR_FLAG,XOR_FLAG,NOR_FLAG,SLT_FLAG,SLTU_FLAG,
         SLL_FLAG,SRL_FLAG,SRA_FLAG,SLLV_FLAG,SRAV_FLAG,JR_FLAG,ADDI_FLAG,ADDIU_FLAG,ANDI_FLAG,ORI_FLAG,XORI_FLAG,
         LUI_FLAG,LW_FLAG,SW_FLAG,BEQ_FLAG,BNE_FLAG,SLTI_FLAG,SLTIU_FLAG,J_FLAG,JAL_FLAG,DIV_FLAG,DIVU_FLAG,
         MULT_FLAG,MULTU_FLAG,BGEZ_FLAG,JALR_FLAG,LB_FLAG,LBU_FLAG,LH_FLAG,LHU_FLAG,SB_FLAG,SH_FLAG,BREAK_FLAG,
         SYSCALL_FLAG,ERET_FLAG,MFC0_FLAG,MTC0_FLAG,MFHI_FLAG,MFLO_FLAG,MTHI_FLAG,MTLO_FLAG,CLZ_FLAG,TEQ_FLAG;
    /*控制信号*/
    wire PCin,PCout;
    wire [3:0] aluc;
    wire Zero,Negative,C,O;
    wire RF_W;
    wire Zin,Zout,Yin,Yout;
    wire HI_W,LO_W;
    wire DIV_Start,DIVU_Start,MULTU_Start,MULT_Start;
    wire DIV_Busy,DIVU_Busy,MULTU_Busy,MULT_Busy;
    wire MFC0,MTC0,ERET,EXCEPTION;
    wire [2:0] state;
    /*MUX选择信号*/
    wire M4,M7;
    wire [1:0] M1,M6,M10;
    wire [2:0] M2,M3,M5,M8,M9;

    /*指令移码器*/
    decoder DECODER(
        .op(instr[31:26]),
        .func(instr[5:0]),
        .rs(instr[25:21]),
        /*R type*/
        .ADD_FLAG(ADD_FLAG),            //ADD   
        .ADDU_FLAG(ADDU_FLAG),           //ADDU  
        .SUB_FLAG(SUB_FLAG),            //SUB   
        .SUBU_FLAG(SUBU_FLAG),           //SUBU  
        .AND_FLAG(AND_FLAG),            //AND   
        .OR_FLAG(OR_FLAG),             //OR     
        .XOR_FLAG(XOR_FLAG),            //XOR   
        .NOR_FLAG(NOR_FLAG),            //NOR   
        .SLT_FLAG(SLT_FLAG),            //SLT   
        .SLTU_FLAG(SLTU_FLAG),           //SLTU  
        .SLL_FLAG(SLL_FLAG),            //SLL   
        .SRL_FLAG(SRL_FLAG),            //SRL   
        .SRA_FLAG(SRA_FLAG),            //SRA   
        .SLLV_FLAG(SLLV_FLAG),           //SLLV  
        .SRLV_FLAG(SRLV_FLAG),           //SRLV  
        .SRAV_FLAG(SRAV_FLAG),           //SRAV  
        .JR_FLAG(JR_FLAG),             //JR    
        /*I type*/
        .ADDI_FLAG(ADDI_FLAG),           //ADDI  
        .ADDIU_FLAG(ADDIU_FLAG),          //ADDIU 
        .ANDI_FLAG(ANDI_FLAG),           //ANDI  
        .ORI_FLAG(ORI_FLAG),            //ORI   
        .XORI_FLAG(XORI_FLAG),           //XORI  
        .LUI_FLAG(LUI_FLAG),            //LUI   
        .LW_FLAG(LW_FLAG),             //LW    
        .SW_FLAG(SW_FLAG),             //SW    
        .BEQ_FLAG(BEQ_FLAG),            //BEQ   
        .BNE_FLAG(BNE_FLAG),            //BNE   
        .SLTI_FLAG(SLTI_FLAG),           //SLTI  
        .SLTIU_FLAG(SLTIU_FLAG),          //SLTIU 
        /*J type*/
        .J_FLAG(J_FLAG),              //J     
        .JAL_FLAG(JAL_FLAG),            //JAL
        /*Extend type*/
        .DIV_FLAG(DIV_FLAG),            //DIV
        .DIVU_FLAG(DIVU_FLAG),           //DIVU
        .MULT_FLAG(MULT_FLAG),           //MULT
        .MULTU_FLAG(MULTU_FLAG),          //MULTU
        .BGEZ_FLAG(BGEZ_FLAG),           //BGEZ
        .JALR_FLAG(JALR_FLAG),           //JALR
        .LBU_FLAG(LBU_FLAG),            //LBU
        .LHU_FLAG(LHU_FLAG),            //LHU
        .LB_FLAG(LB_FLAG),             //LB
        .LH_FLAG(LH_FLAG),             //LH
        .SB_FLAG(SB_FLAG),             //SB
        .SH_FLAG(SH_FLAG),             //SH
        .BREAK_FLAG(BREAK_FLAG),          //BREAK
        .SYSCALL_FLAG(SYSCALL_FLAG),        //SYSCALL
        .ERET_FLAG(ERET_FLAG),           //ERET
        .TEQ_FLAG(TEQ_FLAG),            //TEQ
        .MFHI_FLAG(MFHI_FLAG),           //MFHI
        .MFLO_FLAG(MFLO_FLAG),           //MFLO
        .MTHI_FLAG(MTHI_FLAG),           //MTHI
        .MTLO_FLAG(MTLO_FLAG),           //MTLO
        .MFC0_FLAG(MFC0_FLAG),           //MFC0
        .MTC0_FLAG(MTC0_FLAG),           //MTC0
        .CLZ_FLAG(CLZ_FLAG)            //CLZ
    );

    /*控制器*/
    Controler controler(
        .clk(clk),
        .rst(rst),
        /*R type*/
        .ADD_FLAG(ADD_FLAG),            //ADD   
        .ADDU_FLAG(ADDU_FLAG),          //ADDU  
        .SUB_FLAG(SUB_FLAG),            //SUB   
        .SUBU_FLAG(SUBU_FLAG),          //SUBU  
        .AND_FLAG(AND_FLAG),            //AND   
        .OR_FLAG(OR_FLAG),              //OR     
        .XOR_FLAG(XOR_FLAG),            //XOR   
        .NOR_FLAG(NOR_FLAG),            //NOR   
        .SLT_FLAG(SLT_FLAG),            //SLT   
        .SLTU_FLAG(SLTU_FLAG),          //SLTU  
        .SLL_FLAG(SLL_FLAG),            //SLL   
        .SRL_FLAG(SRL_FLAG),            //SRL   
        .SRA_FLAG(SRA_FLAG),            //SRA   
        .SLLV_FLAG(SLLV_FLAG),          //SLLV  
        .SRLV_FLAG(SRLV_FLAG),          //SRLV  
        .SRAV_FLAG(SRAV_FLAG),          //SRAV  
        .JR_FLAG(JR_FLAG),              //JR    
        /*I type*/
        .ADDI_FLAG(ADDI_FLAG),          //ADDI  
        .ADDIU_FLAG(ADDIU_FLAG),        //ADDIU 
        .ANDI_FLAG(ANDI_FLAG),          //ANDI  
        .ORI_FLAG(ORI_FLAG),            //ORI   
        .XORI_FLAG(XORI_FLAG),          //XORI  
        .LUI_FLAG(LUI_FLAG),            //LUI    
        .LW_FLAG(LW_FLAG),              //LW    
        .SW_FLAG(SW_FLAG),              //SW    
        .BEQ_FLAG(BEQ_FLAG),            //BEQ   
        .BNE_FLAG(BNE_FLAG),            //BNE   
        .SLTI_FLAG(SLTI_FLAG),          //SLTI  
        .SLTIU_FLAG(SLTIU_FLAG),        //SLTIU 
        /*J type*/
        .J_FLAG(J_FLAG),                //J     
        .JAL_FLAG(JAL_FLAG),            //JAL 
        /*Extend type*/
        .DIV_FLAG(DIV_FLAG),            //DIV
        .DIVU_FLAG(DIVU_FLAG),          //DIVU
        .MULT_FLAG(MULT_FLAG),          //MULT
        .MULTU_FLAG(MULTU_FLAG),        //MULTU
        .BGEZ_FLAG(BGEZ_FLAG),          //BGEZ
        .JALR_FLAG(JALR_FLAG),          //JALR
        .LBU_FLAG(LBU_FLAG),            //LBU
        .LHU_FLAG(LHU_FLAG),            //LHU
        .LB_FLAG(LB_FLAG),              //LB
        .LH_FLAG(LH_FLAG),              //LH
        .SB_FLAG(SB_FLAG),              //SB
        .SH_FLAG(SH_FLAG),              //SH
        .BREAK_FLAG(BREAK_FLAG),        //BREAK
        .SYSCALL_FLAG(SYSCALL_FLAG),    //SYSCALL
        .ERET_FLAG(ERET_FLAG),          //ERET
        .TEQ_FLAG(TEQ_FLAG),            //TEQ
        .MFHI_FLAG(MFHI_FLAG),          //MFHI
        .MFLO_FLAG(MFLO_FLAG),          //MFLO
        .MTHI_FLAG(MTHI_FLAG),          //MTHI
        .MTLO_FLAG(MTLO_FLAG),          //MTLO
        .MFC0_FLAG(MFC0_FLAG),          //MFC0
        .MTC0_FLAG(MTC0_FLAG),          //MTC0
        .CLZ_FLAG(CLZ_FLAG),            //CLZ
        /*alu控制信号*/ 
        .Zero(Zero),
        .Negative(Negative),
        /*MUL和DIV的Busy信号*/
        .MULT_busy(MULT_Busy),
        .MULTU_busy(MULTU_Busy),
        .DIV_busy(DIV_Busy),
        .DIVU_busy(DIVU_Busy),
        /*MUX*/
        .M1(M1),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .M6(M6),
        .M7(M7),
        .M8(M8),
        .M9(M9),
        .M10(M10),
        /*PC*/
        .PCin(PCin),
        .PCout(PCout),
        /*aluc*/
        .aluc(aluc),
        /*Regfiles*/
        .RF_W(RF_W),                //Regfiles写控制
        /*DMEM*/
        .CS(CS),                    //片选信号
        .DM_R(DM_R),                //DMEM读控制
        .DM_W(DM_W),                //DMEM写控制
        /*Latch*/
        .Zin(Zin),
        .Zout(Zout),
        .Yin(Yin),
        .Yout(Yout),
        /*HI_LO*/
        .HI_W(HI_W),
        .LO_W(LO_W),
        /*MUL和DIV*/
        .MULT_start(MULT_Start),
        .MULTU_start(MULTU_Start),
        .DIV_start(DIV_Start),
        .DIVU_start(DIVU_Start),
        /*CP0*/
        .MFC0(MFC0),
        .MTC0(MTC0),
        .ERET(ERET),
        .EXCEPTION(EXCEPTION),
        .state(state)    
    );
    assign LW = LW_FLAG;
    assign SW = SW_FLAG;
    assign LB = LB_FLAG;
    assign LBU = LBU_FLAG;
    assign LH = LH_FLAG;
    assign LHU = LHU_FLAG;
    assign SB = SB_FLAG;
    assign SH = SH_FLAG;
    /*寄存器地址和操作数*/
    wire [4:0]RdC,RtC,RsC,SA;
    wire [15:0]imm_disp;
    wire [25:0]targer;
    /*R type*/
    assign RdC = instr[15:11];
    assign RtC = instr[20:16];
    assign RsC = instr[25:21];
    assign SA  = instr[10:6];
    /*I type*/
    assign imm_disp = instr[15:0];
    /*J type*/
    assign  targer  = instr[25:0];
    /*数据扩展与拼接信号*/
    wire [31:0] Ext5,Ext16,Ext16_signed,Ext18_signed,Cat; //Ext18为符号扩展
    /*MUX信号*/
    wire [31:0] MUX1,MUX2,MUX3,MUX4,MUX5,MUX8,MUX9;
    wire [4:0] MUX6,MUX7,MUX10;
    /*Latch*/
    wire [31:0]Y_r,Z_r;
    /*Regfiles输出*/
    wire [31:0] Rs, Rt;
    /*HI_LO输出*/
    wire [31:0] HI_out,LO_out;
    /*ALU输出*/
    wire [31:0] ALU_out;
    /*MULT和MULTU输出*/
    wire [63:0] MULT_out,MULTU_out;
    /*DIV和DIVU输出*/
    wire [31:0] DIV_R,DIV_Q,DIVU_R,DIVU_Q;
    /*CLZ输出*/
    wire [31:0] CLZ_out;
    /*CP0输出*/
    wire [31:0] EPC_OUT,DATA_OUT,STATUS;
    /*PC输出*/
    wire [31:0] PC_tmp;
    /*数据拓展连接*/
    assign Ext5  = {27'b0,MUX7};
    assign Ext16 = {16'b0,imm_disp};
    assign Ext16_signed = {{16{imm_disp[15]}},imm_disp};
    assign Ext18_signed = {{14{imm_disp[15]}},imm_disp,2'b0};
    assign Cat   = {PC_tmp[31:28],targer,2'b0};

    /*临时的一些连线*/
    /*MUX连接*/
    MUX4_1 mux1(
        .S(M1),
        .D0(PC_tmp),
        .D1(Rs),
        .D2(Ext5),
        .D3(32'b0),
        .oZ(MUX1)
    );
    MUX8_1 mux2(
        .S(M2),
        .D0(Rt),
        .D1(Ext16_signed),
        .D2(Ext16),
        .D3(Ext18_signed),
        .D4(32'd4),
        .D5(32'd0),
        .D6(32'b0),
        .D7(32'b0),
        .oZ(MUX2)
    ),
    mux3(
        .S(M3),
        .D0(Rs),
        .D1(Y_r),
        .D2(Z_r),
        .D3(32'h00400004),
        .D4(EPC_OUT),
        .D5(32'b0),
        .D6(32'b0),
        .D7(32'b0),
        .oZ(MUX3)
    ),
    mux5(
        .S(M5),
        .D0(PC_tmp),
        .D1(DATA_OUT),
        .D2(LO_out),
        .D3(HI_out),
        .D4(DM_data_in),
        .D5(Z_r),
        .D6(32'b0),
        .D7(32'b0),
        .oZ(MUX5)
    ),
    mux8(
        .S(M8),
        .D0(Rs),
        .D1(MULT_out[63:32]),
        .D2(MULTU_out[63:32]),
        .D3(DIV_R),
        .D4(DIVU_R),
        .D5(32'b0),
        .D6(32'b0),
        .D7(32'b0),
        .oZ(MUX8)
    ),
    mux9(
        .S(M9),
        .D0(Rs),
        .D1(MULT_out[31:0]),
        .D2(MULTU_out[31:0]),
        .D3(DIV_Q),
        .D4(DIVU_Q),
        .D5(32'b0),
        .D6(32'b0),
        .D7(32'b0),
        .oZ(MUX9)
    );
    MUX4_1_5b mux6(
        .S(M6),
        .D0(RdC),
        .D1(RtC),
        .D2(5'b11111),
        .D3(5'b00000),
        .oZ(MUX6)
    ),
    mux10(
        .S(M10),
        .D0(5'b01001),//break
        .D1(5'b01000),//syscall
        .D2(5'b01101),//eret
        .D3(5'b00000),
        .oZ(MUX10)
    );

    assign MUX4 = M4 ? ALU_out : CLZ_out;
    assign MUX7 = M7 ? Rs[4:0] : SA;

    /*Lacth连接*/
    latch LZ(
        .clk(clk),
        .in(Zin),
        .out(Zout),
        .data_in(MUX4),
        .data_out(Z_r)
    ),
    LY(
       .clk(clk),
       .in(Yin),
       .out(Yout),
       .data_in(Cat),
       .data_out(Y_r)
    );
    /*PC实例化*/
    PC PCreg(
        .clk(clk),
        .rst(rst),
        .PCin(PCin),
        .PCout(PCout),
        .data_in(MUX3),
        .data_out(PC_tmp)
    );
    always@(posedge clk) begin
        if(state == 3'b001) begin
            PC_out <= PC_tmp;
        end
    end
  
    /*Regfile实例化*/
    Regfile cpu_ref(
        clk,            //.clk
        rst,            //.rst
        1'b1,           //.ena
        RF_W,           //.rf_w
        MUX6,           //.RdC
        RtC,            //.RtC
        RsC,            //.RsC
        MUX5,           //.Rd_in
        Rs,             //.Rs_out
        Rt              //.Rt_out
    );

    /*ALU实例化*/
    ALU alu(
        .a          (MUX1),
        .b          (MUX2),
        .aluc       (aluc),
        .r          (ALU_out),
        .zero       (Zero),
        .carry      (C),
        .negative   (Negative),
        .overflow   (O)
    );

    /*DMEM信号*/
    assign DM_addr   = Z_r;
    assign DM_data_w = Rt;

    /*HI_LO实例化*/
    HI_LO hi_lo(
        .clk(clk),
        .ena(1'b1),
        .rst(rst),
        .HI_in(MUX8),
        .LO_in(MUX9),
        .HI_w(HI_W),
        .LO_w(LO_W),
        .HI_out(HI_out),
        .LO_out(LO_out)
    );

    /*乘除法器实例化*/
    MULT mult(
        .clk(clk),
        .reset(rst),
        .start(MULT_Start),
        .a(Rs),
        .b(Rt),
        .res(MULT_out),
        .busy(MULT_Busy)
    );
    MULTU multu(
        .clk(clk),
        .reset(rst),
        .start(MULTU_Start),
        .a(Rs),
        .b(Rt),
        .res(MULTU_out),
        .busy(MULTU_Busy)
    );
    DIV div(
     .dividend(Rs),
     .divisor(Rt),
     .start(DIV_Start),
     .clock(clk),
     .reset(rst),
     .q(DIV_Q),
     .r(DIV_R),
     .busy(DIV_Busy)
    );
    DIVU divu(
        .dividend(Rs),
        .divisor(Rt),
        .start(DIVU_Start),
        .clock(clk),
        .reset(rst),
        .q(DIVU_Q),
        .r(DIVU_R),
        .busy(DIVU_Busy)
    );

    /*CLZ实例化*/
    CLZ clz(
        .CLZ_in(Rs),
        .res(CLZ_out)
    );

    wire INTR;
    /*CP0实例化*/
    CP0 cp0(
        .clk(clk),
        .rst(rst),
        .MFC0(MFC0),
        .MTC0(MTC0),
        .EXCEPTION(EXCEPTION),
        .ERET(ERET),
        .intr(INTR),
        .pc(PC_tmp),
        .Rd(RdC),
        .wdata(Rt),
        .cause(MUX10),
        .rdata(DATA_OUT),
        .status(STATUS),
        .exc_addr(EPC_OUT)
    );

endmodule
