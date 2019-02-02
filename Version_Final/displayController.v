
module DisplayController(pstate, RESM, WESM, ResetAddrSM, IncAddrSM, RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1,
                         SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, FrameBufferEnable, 
						 SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1,
						 PxOut, LineOut, VBOut,HBOut, AIPOut, AILOut, Addr0, Addr1, CSDisplay, Clock);

output reg RE0, WE0, RE1, WE1, SelR0, SelG0, SelB0, SelR1, SelG1, SelB1,
SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine, FrameBufferEnable, 
SyncVB, Buf0Empty, Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1,RESM, WESM, ResetAddrSM, IncAddrSM;

input[3:0] PxOut, LineOut, AIPOut, AILOut; 
input[1:0] VBOut, HBOut;
input CSDisplay, Clock;
input[6:0] Addr0, Addr1;
reg currB0, currB1;
parameter IDLE=5'b00000, START0=5'b00001, VB0R= 5'b00010 ,VB0G= 5'b00011 ,VB0B= 5'b00100,
ResetVB0R= 5'b00101, ResetVB0G= 5'b00110, ResetVB0B= 5'b00111, Switch0VB_Act= 5'b01000,
R0=5'b01001,G0=5'b01010,B0=5'b01011, ResetR0=5'b01100, ResetG0=5'b01101,ResetB0=5'b01110,
LastR0=5'b01111, LastG0=5'b10000, LastB0=5'b10001, ResetLastR0= 5'b10010,ResetLastG0= 5'b10011,ResetLastB0= 5'b10100,
START1= 5'b10101,SYSMEM_BUF=5'b10110;
output[4:0] pstate;
reg[4:0] nstate, pstate=IDLE;


always @(posedge Clock)
begin
    if ((WE0 == 1) && (Addr0 == 99))
    begin
        WE0 <= 0;
        IncAddr0 <= 0;
        ResetAddr0 <= 1;
        RESM <= 0;
	IncAddrSM <= 0;
        ResetAddrSM <= 1;
    end

    if ((WE1 == 1) && (Addr1 == 99))
    begin
        WE1 <= 0;
        IncAddr1 <= 0;
        ResetAddr1 <= 1;
        RESM <= 0;
	IncAddrSM <= 0;
        ResetAddrSM <= 1;
    end
end

always @(CSDisplay or pstate)
begin
	case(pstate)
		IDLE :  begin
			if(CSDisplay==0)
			begin
			RESM<=0;
			WESM<=1;
			ResetAddrSM<=1;
			ResetAddr0<=1;
			nstate <= SYSMEM_BUF;
			end
			end
		SYSMEM_BUF:begin
			if(CSDisplay==0)
			begin
			WESM<=0;
			RESM<=1;
			WE0<=1;
			ResetAddrSM<=0;
			ResetAddr0<=0;
			IncAddrSM<=1;
			IncAddr0<=1;
			nstate<=SYSMEM_BUF;
			end
			else if(CSDisplay==1)
			begin
			nstate<= START0;
			IncAddrSM<=0;
			ResetAddrSM<=1;
			ResetAddr0<=1;
			IncAddr0<=0;
			WE0<=0;
			RESM<=0;
			end
			end
		
		START0 : begin
			FrameBufferEnable<=0;
            		ResetLine<=0;
			ResetPx<=0;
	        	SelBlank <=1;
			Buf0Empty<=0;	
	        	Buf1Empty <=1;
			WESM<=1;
	        	SyncVB=1;
	        	SelBuf0<=0;
	        	SelBuf1<= 0;		
			currB0<=1;
			currB1<=0;
			SelB1<=0;
			IncPx<=0;
			IncLine<=0;
			nstate<= VB0G;			
			end
		START1 : begin
			FrameBufferEnable<=0;
			ResetLine<=0;
			ResetPx<=0;
			SelBlank <=1;
			Buf0Empty <=1;
			Buf1Empty <=0;
			WESM<=1;
			SyncVB=1;
			SelBuf0<=0;
			SelBuf1<= 0;
			currB0<=0;
			currB1<=1;
			SelB0<=0;
			IncPx<=0;
			IncLine<=0;	
			FrameBufferEnable<=1;
            		nstate<= VB0G;			
			end			
		VB0R : begin
			
		    	ResetPx<=0;
			IncPx<=0;
		   	IncLine<=0;
			nstate<= VB0G;
			end
		VB0G :  begin
			WESM<=0;
			RESM<=1;
			IncAddrSM<=1;
			ResetAddrSM<=0;
			ResetAddr1<=0;
                        if (currB0 == 1)
                        begin
			    WE1<=1;
			    RE1<=0;
                            IncAddr1<=1;
                            ResetAddr1<=0;
                        end
			else if (currB1 == 1)
			begin
			    WE0 <= 1;
			    RE0 <= 0;
                            IncAddr0 <= 1;
                            ResetAddr0 <= 0;
                        end
			nstate<= VB0B;
			end
		VB0B : begin
			IncPx<=1;
			if(PxOut < (HBOut+AIPOut)-2)
				nstate<= VB0R;
			else
				nstate<= ResetVB0R;
			end
		ResetVB0R : begin
		    	    IncPx<=0;
		    	    nstate<=ResetVB0G;
            		    end
		ResetVB0G : begin
			    if(LineOut < (VBOut-1))
		    	    nstate<=ResetVB0B;
			    else if(LineOut ==(VBOut-1))
			    nstate <= Switch0VB_Act;
            		    end
		ResetVB0B : begin
			    ResetPx<=1;
			    IncLine<=1;
			    nstate<=VB0R;
            		    end        	
               Switch0VB_Act : 	begin
            		       	ResetPx<=1;
            			ResetLine<=1;
				if(currB0==1)
				begin
				    RE0<=1;
				end
				if(currB1==1)
				begin
				    RE1<=1;
				end
				nstate<=R0;
            			end			
		R0 :	begin 
		    	ResetPx<=0;
			ResetAddr0<=0;
			ResetAddr1<=0;
			SelBlank<=0;
			SelBuf0<=currB0;
            		SelBuf1<=currB1;
			IncPx<=0;
			IncLine<=0;
			ResetLine<=0;
			SelR0<=currB0;
			SelR1<=currB1;
			SelB0<=0;
			SelB1<=0;
			FrameBufferEnable<=1;
			nstate<=G0;
			
			
			end
		G0 :	begin
		    	SelR0<=0;
		    	SelG0<=currB0;
			SelG1<=currB1;
			SelR1<=0;
		    	nstate<=B0;
			Buf1Empty=0;
			/*if(currB0==1)
			begin
				RESM<=0;
				WE1<=0;
			end*/
			if(currB0==1)
			begin
			    IncAddr0<=1;
			end
			if(currB1==1)
			begin
			    IncAddr1<=1;	
			end
			end
		B0 : 	begin
		     	IncPx<=1;
			SelG0<=0;
			SelB0<=currB0;
			SelB1<=currB1;
			SelG1<=0;
			if(currB0==1)
			begin
			    IncAddr0<=0;
			end
			if(currB1==1)
			begin
			    IncAddr1<=0;
			end
		    	if (PxOut < (AIPOut-2))
			    nstate<=R0;
			else if (PxOut ==(AIPOut -2))
			    nstate<=ResetR0;
			end
		ResetR0 : 	begin
		    		IncPx<=0;
				SelR0<=currB0;
				SelR1<=currB1;
				SelB0<=0;
				SelB1<=0;
				nstate<=ResetG0;
		    		end
		ResetG0 : 	begin
				if(currB0==1)
				begin
				IncAddr0<=1;
				end
				if(currB1==1)
				begin
				IncAddr1<=1;
				end
				SelR0<=0;
		    		SelG0<=currB0;
				SelG1<=currB1;
				SelR1<=0;
		    		nstate<=ResetB0;
		    		end
		ResetB0 : 	begin
		    		ResetPx<=1;
				SelB0<=currB0;
				SelB1<=currB1;
				SelG0<=0;
				SelG1<=0;
				if(currB0==1)
				begin
				    IncAddr0<=0;
				end
				if(currB1==1)
				begin
				    IncAddr1<=0;
				end
				IncLine<=1;
		    		if (LineOut < (AILOut-2))
					nstate<=R0;
				else if (LineOut == (AILOut-2))
					nstate<=LastR0;
				end
		LastR0: 	begin
				ResetPx<=0;
				IncLine<=0;
				IncPx<=0;
				SelR0<=currB0;
				SelR1<=currB1;
				SelB0<=0;
				SelB1<=0;
				nstate<=LastG0;
				end
		
		LastG0:		begin
				SelR0<=0;
		    		SelG0<=currB0;
				SelG1<=currB1;
				SelR1<=0;
				if(currB0==1)
				begin
				    IncAddr0<=1;
				end
				if(currB1==1)
				begin
				    IncAddr1<=1;
				end
				
				nstate<=LastB0;					
				end
		LastB0:		begin
				SelB0<=currB0;
				SelB1<=currB1;
				SelG0<=0;
				SelG1<=0;	
				IncPx<=1;
				IncAddr0<=0;
				IncAddr1<=0;
				if(PxOut<(AIPOut-2))
					nstate<=LastR0;
				else if(PxOut==(AIPOut-2))
					nstate<=ResetLastR0;
				end
		ResetLastR0:	begin
				SelR0<=currB0;
				SelR1<=currB1;
				SelB0<=0;
				SelB1<=0;
				IncPx<=0;
				nstate<=ResetLastG0;
				end
		ResetLastG0:	begin
				SelR0<=0;
		    		SelG0<=currB0;
				SelG1<=currB1;
				SelR1<=0;
				if(currB0==1)
				begin
					ResetAddr0<=1;
				end
				if(currB1==1)
				begin
					ResetAddr1<=1;
				end
				nstate<=ResetLastB0;
				end
		ResetLastB0:	begin
				SelB0<=currB0;
				SelB1<=currB1;
				SelG0<=0;
				SelG1<=0;
				ResetLine<=1;
				ResetPx<=1;
				if (currB0 == 1)
					begin	
					RE0<=0;
			    		nstate<=START1;
					
					end
				else if (currB1 == 1)	
					begin	
					nstate<=START0;
					RE1<=0;
					end
				end
		endcase
end
always @ (posedge Clock)
pstate <= nstate;
endmodule