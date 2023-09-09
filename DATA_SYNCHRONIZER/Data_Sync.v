module Data_Sync #(parameter NUM_STAGES = 'd4 , parameter BUS_WIDTH = 1) (

input CLK     ,
input RST_n   ,
input bus_enable ,
input      [BUS_WIDTH -1  : 0] UNSYNC_bus ,

output  reg enable_pulse ,
output  reg [BUS_WIDTH - 1 : 0] SYNC_bus

);


reg pulse_gen ;
reg Q_in;
reg  [NUM_STAGES -1 : 0]  FF_Stage ;
reg  data_SYN2; 

genvar i ;

generate

	for(i = 0 ; i < NUM_STAGES ; i = i + 1)
	begin
	  
	  always @(posedge CLK or negedge RST_n)
	  begin
	  	
	  	if (!RST_n) begin
	  	    FF_Stage[i] <= 0;
	  	end


	  	else if (i == 0) begin
	  		FF_Stage[i] <= bus_enable;
	  	end

        
        else if(i == NUM_STAGES - 1) begin  //Final FF
            data_SYN2 <= FF_Stage [i-1]; 
        end
	  	
	  	else begin
	        FF_Stage[i] <= FF_Stage[i-1];		
	  	end

	  end
	end  
	
endgenerate


/////////////////////////////////////////////
/////////////// Pulse Generator /////////////
/////////////////////////////////////////////

always @(posedge CLK or negedge RST_n) begin
	if (!RST_n) begin
	 pulse_gen <= 1'b0;
	 Q_in  <= 1'b0;
	end
	else begin
     Q_in <= data_SYN2;
	 pulse_gen <= ~Q_in & data_SYN2 ;	
	end
end



/////////////////////////////////////////////
//////////////// SYNC BUS ///////////////////
/////////////////////////////////////////////


always @(posedge CLK or negedge RST_n) begin
	if (!RST_n) begin
	   SYNC_bus <= 1'b0;
	end

	else begin
	  SYNC_bus <= (pulse_gen)? UNSYNC_bus : SYNC_bus;	
	end
end



/////////////////////////////////////////////
///////////////// Enable Bus ////////////////
/////////////////////////////////////////////

always @(posedge CLK or negedge RST_n) begin
	if (!RST_n) begin
	  enable_pulse <= 1'b0;
	end

	else begin
	  enable_pulse <= pulse_gen;	
	end
end



endmodule


