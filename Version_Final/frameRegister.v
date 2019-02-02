
module frameRegister(FrameOut,FrameIn, LineOut, PxOut, FrameBufferEnable, Clock);
output reg[7:0] FrameOut;
input [7:0]FrameIn;
input[3:0] LineOut, PxOut;
input Clock, FrameBufferEnable;
input Clock;

reg [7:0] buffer[11:0][29:0];

parameter IDLE=2'b00, Red=2'b01, Green=2'b10, Blue=2'b11;
reg[1:0] p_color= Red;
reg[1:0] n_color;
integer i,j,file;
integer file_num=0;

always @ (p_color or FrameIn)
begin 
	if(FrameBufferEnable==0)
		begin   
		case(p_color)
			
			Red: 	begin
				buffer[LineOut][PxOut*3] <= FrameIn;
				n_color<= Green;
				end	
			Green: 	begin
				buffer[LineOut][(PxOut*3)+1] <= FrameIn;
				n_color<= Blue;
				end
			Blue: 	begin
				buffer[LineOut][(PxOut*3)+2] <= FrameIn;
				n_color<= Red;
				end
		endcase
		end
	else
		begin   
		case(p_color)
			
			Red: 	begin
				buffer[LineOut+2][PxOut*3] <= FrameIn;
				n_color<= Green;
				end	
			Green: 	begin
				buffer[LineOut+2][(PxOut*3)+1] <= FrameIn;
				n_color<= Blue;
				end
			Blue: 	begin
				buffer[LineOut+2][(PxOut*3)+2] <= FrameIn;
				n_color<= Red;
				end
		endcase
		end
	
end
always @(posedge Clock)
begin
	p_color<= n_color;
	if(file_num==0)
	begin
		if((PxOut==9) && (LineOut==9))
		begin
		file = $fopen("C:\\Users\\thaijasa\\Desktop\\example_out0.txt","w");
			for(i=1;i<=12;i=i+1)
			for(j=1; j<=30;j=j+1)
				begin 
				if(j==30)
					begin
					$fwrite(file,"%h \n",buffer[i-1][j-1]);
					end
				else
					begin
					$fwrite(file,"%h ",buffer[i-1][j-1]);
					end
				end
		end
	file_num=1;
	
	end
	if(file_num==1)
	begin
		if((PxOut==9) && (LineOut==9))
		begin
		file = $fopen("C:\\Users\\thaijasa\\Desktop\\example_out1.txt","w");
			for(i=1;i<=12;i=i+1)
			for(j=1; j<=30;j=j+1)
				begin 
				if(j==30)
					begin
					$fwrite(file,"%h \n",buffer[i-1][j-1]);
					end
				else
					begin
					$fwrite(file,"%h ",buffer[i-1][j-1]);
					end
				end
		end
	file_num=2;
	
	end
	if(file_num==2)
	begin
		if((PxOut==9) && (LineOut==9))
		begin
		file = $fopen("C:\\Users\\thaijasa\\Desktop\\example_out.txt","w");
			for(i=1;i<=12;i=i+1)
			for(j=1; j<=30;j=j+1)
				begin 
				if(j==30)
					begin
					$fwrite(file,"%h \n",buffer[i-1][j-1]);
					end
				else
					begin
					$fwrite(file,"%h ",buffer[i-1][j-1]);
					end
				end
		end
	
	
	end
	

end

endmodule