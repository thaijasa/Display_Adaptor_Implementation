module Buf0Mux(Buf0MuxOut, Buf0OutR, Buf0OutG, Buf0OutB, SelR0, SelG0, SelB0, Clock);
output reg[7:0] Buf0MuxOut;
input[7:0] Buf0OutR, Buf0OutG, Buf0OutB;
input SelR0, SelG0, SelB0;
input Clock;

always @(posedge Clock)
begin
	if(SelR0==1)
	begin
		Buf0MuxOut <= Buf0OutR;
	end
	else if(SelG0==1)
	begin
		Buf0MuxOut <= Buf0OutG;
	end
	else if(SelB0==1)
	begin
		Buf0MuxOut <= Buf0OutB;
	end
end
endmodule
