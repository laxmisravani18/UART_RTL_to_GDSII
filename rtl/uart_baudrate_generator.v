module baud_gen(
    input clk,
    input reset,
    output reg baud_tick
);

parameter DIV = 5208; // for 9600 baud @ 50MHz

reg [12:0] count;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        count <= 0;
        baud_tick <= 0;
    end
    else
    begin
        if(count == DIV)
        begin
            count <= 0;
            baud_tick <= 1;
        end
        else
        begin
            count <= count + 1;
            baud_tick <= 0;
        end
    end
end

endmodule
