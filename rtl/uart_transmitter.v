module uart_tx(
input clk,
input reset,
input baud_tick,
input [7:0] data_in,
input start,
output reg tx,
output reg busy
);

reg [1:0] state;
reg [3:0] bit_count;
reg [7:0] data_reg;

parameter IDLE=0, START=1, DATA=2, STOP=3;

always @(posedge clk or posedge reset)
begin
if(reset)
begin
state<=IDLE;
tx<=1;
busy<=0;
bit_count<=0;
end

else if(baud_tick)
begin
case(state)

IDLE:
begin
tx<=1;
busy<=0;
if(start)
begin
data_reg<=data_in;
state<=START;
busy<=1;
end
end

START:
begin
tx<=0;
state<=DATA;
bit_count<=0;
end

DATA:
begin
tx<=data_reg[bit_count];
bit_count<=bit_count+1;

if(bit_count==7)
state<=STOP;
end

STOP:
begin
tx<=1;
state<=IDLE;
end

endcase
end
end

endmodule
