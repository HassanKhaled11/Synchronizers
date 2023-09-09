module Data_Sync_tb;

parameter PERIOD_CLOCK = 100;
parameter BUS_WIDTH  = 'd8;
parameter NUM_STAGES = 'd4;


reg RST_n   ;
reg CLK     ;
reg bus_enable ;
reg [BUS_WIDTH -1  : 0] UNSYNC_bus ;

wire enable_pulse ;
wire [BUS_WIDTH - 1 : 0] SYNC_bus;


Data_Sync #(.NUM_STAGES(NUM_STAGES) , .BUS_WIDTH(BUS_WIDTH) ) dut (

.CLK(CLK)     ,
.RST_n(RST_n)   ,
.bus_enable(bus_enable) ,
.UNSYNC_bus(UNSYNC_bus) ,
.enable_pulse(enable_pulse) ,
.SYNC_bus(SYNC_bus)

);


integer i;


always #(PERIOD_CLOCK/2) CLK = ~ CLK ;


initial begin

CLK   = 0 ;
bus_enable = 0 ; 
UNSYNC_bus = 0;

RST_n = 1'b0 ;
#(PERIOD_CLOCK);
RST_n = 1'b1;


@(negedge CLK)      ;
UNSYNC_bus = 8'hF2  ;
#(2 * PERIOD_CLOCK) ;
bus_en_zero_to_one();
CHECK_RESULT(UNSYNC_bus);

#(PERIOD_CLOCK)     ;
UNSYNC_bus = 8'hAA  ;

#(PERIOD_CLOCK)
bus_en_one_to_zero();
UNSYNC_bus = 8'hBB;
#(3 * PERIOD_CLOCK);
if(SYNC_bus != UNSYNC_bus) $display("RIGHT SYNC DATA");
else $display("WRONG SYNC DATA");




RST_n = 1'b0 ;
#(PERIOD_CLOCK);
RST_n = 1'b1;

$stop;

end




task CHECK_RESULT(input [BUS_WIDTH-1 : 0] expected_out);

begin
	
#((NUM_STAGES + 2) * PERIOD_CLOCK);
if(expected_out == SYNC_bus) $display("RIGHT DATA");
else $display("WRONG DATA !");

if(enable_pulse == bus_enable)  $display("RIGHT enable");
else $display("WRONG enable !");

end

endtask



task bus_en_one_to_zero();

begin
@(negedge CLK);

bus_enable = 1'b1;
#(5 * PERIOD_CLOCK) 
bus_enable = 1'b0;
end

endtask


task bus_en_zero_to_one();

begin
@(negedge CLK);


bus_enable = 1'b0;
#(5 * PERIOD_CLOCK) 
bus_enable = 1'b1;
#(2 * PERIOD_CLOCK)
UNSYNC_bus = 8'hCC;
bus_enable = 1'b0;
#(2 * PERIOD_CLOCK)
bus_enable = 1'b1;
end

endtask





endmodule