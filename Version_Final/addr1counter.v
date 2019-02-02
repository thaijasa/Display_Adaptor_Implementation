module addr1counter(IncAddr1,ResetAddr1,Clock,Addr1);
input IncAddr1,ResetAddr1,Clock;
wire IncAddr1,ResetAddr1,Clock;
output [3:0] Addr1;
reg [3:0] Addr1=0;


always @(posedge Clock)
begin
if (IncAddr1==1)
	Addr1 <= Addr1 + 1;
else if (ResetAddr1==1)
	Addr1<= 0;
end
endmodule
