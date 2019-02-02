`timescale 1ns/1ns
module TopDisplayAdaptor_tb();

reg Clock;
reg CSDisplay;

initial 
begin
Clock <=0;
CSDisplay<=0;
#202 CSDisplay<=1;
end

always
#1 Clock<=~Clock;

TopDisplayAdaptor Top_DisplayAdaptor_MUT(Clock, CSDisplay);
endmodule

