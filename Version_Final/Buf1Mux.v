module Buf1Mux(Buf1MuxOut, Buf1OutR, Buf1OutG, Buf1OutB, SelR1, SelG1, SelB1, Clock);
output reg[7:0] Buf1MuxOut;
input[7:0] Buf1OutR, Buf1OutG, Buf1OutB;
input SelR1, SelG1, SelB1, Clock;

always @(posedge Clock)
begin
	if(SelR1==1)
	begin
		Buf1MuxOut <= Buf1OutR;
	end
	else if(SelG1==1)
	begin
		Buf1MuxOut <= Buf1OutG;
	end
	else if(SelB1==1)
	begin
		Buf1MuxOut <= Buf1OutB;
	end
end
endmodule
