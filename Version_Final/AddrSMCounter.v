
module addrSMcounter(IncAddrSM,ResetAddrSM,Clock,AddrSM);

input IncAddrSM,ResetAddrSM,Clock;

output [6:0] AddrSM;
reg [6:0] AddrSM=0;

always @(posedge Clock)
begin
if (IncAddrSM==1)
	AddrSM <= AddrSM + 1;
else if (ResetAddrSM==1)
	AddrSM<= 0;
end
endmodule