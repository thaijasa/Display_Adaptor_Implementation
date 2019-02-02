module FrameMux(FrameIn, B0, B1, SelBuf0, SelBlank, SelBuf1, Clock);
output reg[7:0] FrameIn;
input[7:0] B0,B1, Clock;
reg[7:0] BK = 8'b00000000;
input SelBuf0, SelBuf1, SelBlank;

always @(posedge Clock)
begin
	if(SelBuf0==1)
	begin
		FrameIn <= B0;
	end
	else if(SelBuf1==1)
	begin
		FrameIn <= B1;
	end
	else if(SelBlank==1)
	begin
		FrameIn <= BK;
	end
end
endmodule
