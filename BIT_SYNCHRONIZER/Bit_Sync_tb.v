module Bit_Sync_tb;

parameter PERIOD_CLOCK = 100;
parameter BUS_WIDTH  = 'd1;
parameter NUM_STAGES = 'd4;


reg  CLK     ;
reg  RST_n   ;
reg  [BUS_WIDTH -1  : 0] ASYNC ;
 
wire [BUS_WIDTH - 1 : 0] SYNC ;


Bit_Sync #(.BUS_WIDTH(BUS_WIDTH) , .NUM_STAGES(NUM_STAGES)) dut (.CLK(CLK) ,.RST_n(RST_n) ,.ASYNC(ASYNC) ,.SYNC(SYNC));


integer i;


always #(PERIOD_CLOCK/2) CLK = ~ CLK ;


initial begin

CLK   = 0 ;
ASYNC = 0 ; 

RST_n = 1'b0 ;
#(PERIOD_CLOCK);
RST_n = 1'b1;

@(negedge CLK);

for(i = 0 ; i < 50 ; i = i + 1)
begin
ASYNC = $random;
CHECK_RESULT(ASYNC);
#(PERIOD_CLOCK);
end

RST_n = 1'b0 ;
#(PERIOD_CLOCK);
RST_n = 1'b1;

$stop;

end




task CHECK_RESULT(input [BUS_WIDTH-1 : 0] expected_bit);

begin
	
#(NUM_STAGES * PERIOD_CLOCK);
if(expected_bit == SYNC) $display("RIGHT LATENCY");
else $display("WRONG LATENCY !");

end

endtask



endmodule