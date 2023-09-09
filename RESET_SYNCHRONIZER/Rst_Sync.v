module Rst_Sync #(parameter NUM_STAGES = 'd4 , parameter ACTIVE_TYP = "LOW" )(

input   RST    ,
input   CLK      ,
output reg SYNC_RST

);


reg [NUM_STAGES - 1 : 0] FF_Stage;
reg data_SYN;

genvar i;



always @(*)
begin
  
  if(!RST && ACTIVE_TYP == "LOW") SYNC_RST = 1'b0;	
  else if(RST && ACTIVE_TYP == "HIGH") SYNC_RST = 1'b1;	
  else if(data_SYN && ACTIVE_TYP == "LOW")   SYNC_RST =  data_SYN ; 
  else if(!data_SYN && ACTIVE_TYP == "HIGH") SYNC_RST =  data_SYN ;

end


generate
	for(i = 0 ; i < NUM_STAGES ; i = i + 1)
	begin
         always @(posedge CLK or negedge RST) 
         begin
         	if (!RST && ACTIVE_TYP == "LOW") begin
               FF_Stage [i] <= 1'b0; 
         	end

         	else if(RST && ACTIVE_TYP == "HIGH") begin
         	  FF_Stage [i] <= 1'b1;
         	end
         	
         	else if (ACTIVE_TYP == "LOW" && i == 0) begin
         		FF_Stage[i] <= 1'b1;
         	end

         	else if (ACTIVE_TYP == "HIGH" && i == 0) begin
                FF_Stage[i] <= 1'b0;
         	end

         	else if(i == NUM_STAGES -1) 
         		data_SYN <= FF_Stage[i - 1];

         	else FF_Stage[i] <= FF_Stage[i-1];

         end
    end
    
endgenerate



endmodule