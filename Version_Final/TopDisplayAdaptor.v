
module TopDisplayAdaptor(Clock, CSDisplay);

input CSDisplay, Clock;

wire RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1,
SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, FrameBufferEnable, 
SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1;

wire[3:0] AIPOut, AILOut; 
wire[3:0] PxOut, LineOut;
wire[1:0] VBOut, HBOut;
wire[4:0] pstate;
wire[7:0] Buf0OutR,Buf1OutR;
wire[7:0] Buf0OutG,Buf1OutG;
wire[7:0] Buf0OutB,Buf1OutB,Buf0MuxOut,Buf1MuxOut,FrameIn;
wire[6:0] Addr0,Addr1;
//wire[23:0] BufferIn0,BufferIn1;
wire[7:0]FrameOut;
wire[23:0] WData;
wire[6:0] AddrSM;
wire WESM, RESM,IncAddrSM,ResetAddrSM;


ProgramRegister ProgramReg_MUT(.HBOut(HBOut), .VBOut(VBOut),.AIPOut(AIPOut), .AILOut(AILOut));
pixelcounter Px_counter_MUT(.IncPx(IncPx), .ResetPx(ResetPx), .Clock(Clock), .PxOut(PxOut));
linecounter line_Counter_MUT(.IncLine(IncLine), .ResetLine(ResetLine), .Clock(Clock), .LineOut(LineOut));
DisplayController DisplayController_MUT(.pstate(pstate),.RESM(RESM), .WESM(WESM), .ResetAddrSM(ResetAddrSM),.IncAddrSM(IncAddrSM) ,
					.RE0(RE0), .WE0(WE0), .RE1(RE1), .WE1(WE1), .SelR0(SelR0), .SelG0(SelG0), .SelB0(SelB0), 
					.SelR1(SelR1), .SelG1(SelG1), .SelB1(SelB1),.SelBuf0(SelBuf0), .SelBlank(SelBlank), 
					.SelBuf1(SelBuf1), .IncPx(IncPx), .ResetPx(ResetPx), .IncLine(IncLine),.ResetLine(ResetLine), 
					.FrameBufferEnable(FrameBufferEnable), .SyncVB(SyncVB), .Buf0Empty(Buf0Empty), 
					.Buf1Empty(Buf1Empty), .IncAddr0(IncAddr0),.ResetAddr0(ResetAddr0),.IncAddr1(IncAddr1),
					 .ResetAddr1(ResetAddr1),.PxOut(PxOut), .LineOut(LineOut), .VBOut(VBOut),
					.HBOut(HBOut), .AIPOut(AIPOut), .AILOut(AILOut), .Addr0(Addr0),.Addr1(Addr1),.CSDisplay(CSDisplay), 
					.Clock(Clock));
addrSMcounter aadrSMcounter_MUT(.IncAddrSM(IncAddrSM), .ResetAddrSM(ResetAddrSM),.Clock(Clock),.AddrSM(AddrSM));

SystemMemory  Sysmem_MUT(.RESM(RESM), .WESM(WESM), .AddrSM(AddrSM) ,.WData(WData), .Clock(Clock));
Buffer0 Buffer0_MUT(.Buf0OutR(Buf0OutR), .Buf0OutG(Buf0OutG), .Buf0OutB(Buf0OutB), .Addr0(Addr0), .WE0(WE0), .RE0(RE0),
			.BufferIn0(WData), .Clock(Clock));
Buffer1 Buffer1_MUT(.Buf1OutR(Buf1OutR), .Buf1OutG(Buf1OutG), .Buf1OutB(Buf1OutB), .Addr1(Addr1), .WE1(WE1), .RE1(RE1),
			.BufferIn1(WData), .Clock(Clock));
addr0counter addr0Count_MUT(.IncAddr0(IncAddr0),.ResetAddr0(ResetAddr0),.Clock(Clock),.Addr0(Addr0));
addr1counter addr1Count_MUT(.IncAddr1(IncAddr1),.ResetAddr1(ResetAddr1),.Clock(Clock),.Addr1(Addr1));
Buf0Mux Buf0Mux_MUT(.Buf0MuxOut(Buf0MuxOut), .Buf0OutR(Buf0OutR), .Buf0OutG(Buf0OutG), .Buf0OutB(Buf0OutB), .SelR0(SelR0), 
			.SelG0(SelG0), .SelB0(SelB0));
Buf1Mux Buf1Mux_MUT(.Buf1MuxOut(Buf1MuxOut), .Buf1OutR(Buf1OutR), .Buf1OutG(Buf1OutG), .Buf1OutB(Buf1OutB), .SelR1(SelR1), 
			.SelG1(SelG1), .SelB1(SelB1));
FrameMux Frame_MUX_MUT(.FrameIn(FrameIn), .B0(Buf0MuxOut), .B1(Buf1MuxOut), .SelBuf0(SelBuf0), .SelBlank(SelBlank), .SelBuf1(SelBuf1));
frameRegister frame_register_MUT(.FrameOut(FrameOut),.FrameIn(FrameIn), .LineOut(LineOut), .PxOut(PxOut),
				 .FrameBufferEnable(FrameBufferEnable), .Clock(Clock));





endmodule