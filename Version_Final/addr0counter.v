
module addr0counter(IncAddr0,ResetAddr0,Clock,Addr0);
input IncAddr0,ResetAddr0,Clock;
wire IncAddr0,ResetAddr0,Clock;
output [6:0] Addr0;
reg [6:0] Addr0=0;

always @(posedge Clock)
begin
if (IncAddr0==1)
	Addr0 <= Addr0 + 1;
else if (ResetAddr0==1)
	Addr0<= 0;
end
endmodule