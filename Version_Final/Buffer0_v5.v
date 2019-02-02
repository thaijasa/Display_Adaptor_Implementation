module Buffer0(Buf0OutR, Buf0OutG, Buf0OutB, Addr0, WE0, RE0, BufferIn0, Clock);
output reg[7:0] Buf0OutR;
output reg[7:0] Buf0OutG;
output reg[7:0] Buf0OutB;
input[6:0] Addr0;
input WE0, RE0, Clock;
input[23:0] BufferIn0;
reg[23:0] BufferMem0[6:0];

always @(posedge Clock)
begin
	if(WE0==1)
	begin
		BufferMem0[Addr0] <= BufferIn0;
	end
	if(RE0==1)
	begin
		Buf0OutR <= BufferMem0[Addr0][23:16];
		Buf0OutG <= BufferMem0[Addr0][15:8];
		Buf0OutB <= BufferMem0[Addr0] [7:0];
	end
end
endmodule



