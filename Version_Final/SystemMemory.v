
module SystemMemory(RESM, WESM, AddrSM ,WData, Clock);
reg[23:0] sysmem[99:0];
input RESM, WESM, Clock;
input [6:0] AddrSM;
output reg[23:0] WData;
integer file_In=0;

always @ (WESM)
begin
	if(WESM==1)
	begin
		if(file_In==0)
		begin
		$readmemh("C:\\Users\\thaijasa\\Desktop\\example0.txt",sysmem);
		file_In=1;
		end
		else if(file_In==1)
		begin
		$readmemh("\C:\\Users\\thaijasa\\Desktop\\example1.txt",sysmem);
		file_In=2;
		end
		else if(file_In==2)
		begin
		$readmemh("C:\\Users\\thaijasa\\Desktop\\example2.txt",sysmem);
		end
	end
end
always @(AddrSM or RESM)
begin
	if (RESM ==1)
		begin
		WData<=sysmem[AddrSM];
		end
end


endmodule
