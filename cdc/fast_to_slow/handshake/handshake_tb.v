`timescale 1ns / 1ps
 
module tb_handshake(    );
reg     tclk;
reg     rclk;
reg  [31:0]   data_in;
reg     valid;
reg     reset;
 
initial begin
tclk = 0;
rclk = 0;
reset = 0;
data_in = 0;
valid = 0;
#200 ;
reset = 1;
#300 ;
data_in = 32'hf0f0f0f0;
valid   = 1;
#200 ;
valid = 0;
#300 ;
data_in = 32'hffff0000;
valid = 1;
#200 ;
valid = 0;
# 300;
data_in = 32'hff00ff00;
valid =1;
end
always # 5 tclk = ~tclk;
always # 10  rclk = ~rclk;
handshake_top handshake1(
.t_clk (tclk  ),
.r_clk (rclk  ),
.rst_n (reset  ),
.valid(valid),
.data_in(data_in)
);

endmodule