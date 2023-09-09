module Rst_Sync_tb;

/************************************************************
 /////////TO MAKE IT ACTIVE HIGH SYNCHRONIZED RESET//////////
/*

1) Make all sensitivity list posedge RST instead of neg
2) Make the parameter Type HiGH insted of LOW
3) Modify the Test Stimulus

*///*********************************************************

parameter PERIOD_CLOCK = 100 ;
parameter NUM_STAGES = 'd4   ;         //Must be st least 2 as this is a synchronizer
parameter ACTIVE_TYP = "LOW" ;

reg RST ;
reg CLK   ;

wire SYNC_RST;


Rst_Sync #(.NUM_STAGES(NUM_STAGES) , .ACTIVE_TYP(ACTIVE_TYP)) dut (.RST(RST), .CLK(CLK) ,.SYNC_RST(SYNC_RST));


always #(PERIOD_CLOCK/2) CLK = ~ CLK ;


initial
begin
CLK   = 1'b0 ;
RST = 1'b0 ;
repeat(5) @(negedge CLK);
RST = 1'b1;	
#((NUM_STAGES+2) * PERIOD_CLOCK);
@(negedge CLK);
RST = 0;
#(2*PERIOD_CLOCK);

$stop;	
end


endmodule