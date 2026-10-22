module uart_rx(
input clk,
input reset,
input baud_tick,
input rx,
output reg [7:0] data_out,
output reg done
);

reg [1:0] state;
reg [3:0] bit_count;
reg [7:0] data_reg;

parameter IDLE=0, DATA=1, STOP=2;

always @(posedge clk or posedge reset)
begin
if(reset)
begin
state<=IDLE;
done<=0;
bit_count<=0;
end

else if(baud_tick)
begin
case(state)

IDLE:
begin
done<=0;
if(rx==0)
begin
state<=DATA;
bit_count<=0;
end
end

DATA:
begin
data_reg[bit_count]<=rx;
bit_count<=bit_count+1;

if(bit_count==7)
state<=STOP;
end

STOP:
begin
data_out<=data_reg;
done<=1;
state<=IDLE;
end

endcase
end
end

endmodule
