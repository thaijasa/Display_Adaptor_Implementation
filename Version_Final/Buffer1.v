
module Buffer1(Buf1OutR, Buf1OutG, Buf1OutB, Addr1, WE1, RE1, BufferIn1, Clock);
output reg[7:0] Buf1OutR;
output reg[7:0] Buf1OutG;
output reg[7:0] Buf1OutB;
input[6:0] Addr1;
input WE1, RE1, Clock;
input[23:0] BufferIn1;
reg[23:0] BufferMem1[99:0];


always @(posedge Clock)
begin
	if(WE1==1)
	begin
		BufferMem1[Addr1] <= BufferIn1;
	end
	if(RE1==1)
	begin
		Buf1OutR <= BufferMem1[Addr1][23:16];
		Buf1OutG <= BufferMem1[Addr1][15:8];
		Buf1OutB <= BufferMem1[Addr1] [7:0];
	end
end
endmodule
