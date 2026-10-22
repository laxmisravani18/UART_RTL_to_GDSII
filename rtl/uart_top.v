module uart_top(
  input        clk,
  input        reset,
  input        start,
  input  [7:0] data_in,
  input        rx,
  output       tx,
  output       busy,
  output [7:0] data_out,
  output       done
);
  wire baud_tick;
  baud_gen u_baud (.clk(clk), .reset(reset), .baud_tick(baud_tick));
  uart_tx  u_tx   (.clk(clk), .reset(reset), .baud_tick(baud_tick),
                   .data_in(data_in), .start(start), .tx(tx), .busy(busy));
  uart_rx  u_rx   (.clk(clk), .reset(reset), .baud_tick(baud_tick),
                   .rx(rx), .data_out(data_out), .done(done));
endmodule
