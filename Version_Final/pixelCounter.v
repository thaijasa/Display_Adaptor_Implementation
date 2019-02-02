module pixelcounter(IncPx, ResetPx, Clock, PxOut);
input IncPx,ResetPx, Clock;
wire IncPx,ResetPx, Clock;
output [3:0] PxOut;
reg [3:0] PxOut;

initial
begin
PxOut <= 0;
end

always @( posedge Clock)
begin
if (IncPx==1)
	PxOut <= PxOut + 1;
if (ResetPx==1)
	PxOut<= 0;
end
endmodule
