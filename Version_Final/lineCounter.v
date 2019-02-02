module linecounter(IncLine, ResetLine, Clock, LineOut);
input IncLine,ResetLine,Clock;
wire IncLine,ResetLine,Clock;
output [3:0] LineOut;
reg [3:0] LineOut;

initial
begin
LineOut <= 0;
end

always @(posedge Clock)
begin
if (IncLine==1)
	LineOut <= LineOut + 1;
if (ResetLine==1) 
	LineOut<= 0;
end
endmodule
