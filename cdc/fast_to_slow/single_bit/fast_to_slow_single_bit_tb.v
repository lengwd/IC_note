`timescale 1ns / 1ps

module TB();

reg sys_clk1; 
reg sys_clk2; 
reg sys_rst_n; 
reg read ;

wire read_async_read;
wire clk1_dly1;
wire clk1_dly2;
wire clk1_or;
wire clk2_sync1;
wire clk2_sync2;

initial begin
    sys_clk1 = 1'b0;
    sys_clk2 = 1'b0;
    sys_rst_n = 1'b0;

    read = 1'b0;

    #200
    sys_rst_n = 1'b1;

    #100
    read = 1'b1;

    #20
    read = 1'b0;
    #100
    read = 1'b1;
    #20
    read = 1'b0;

end

always #10 sys_clk1 = ~sys_clk1;
always #30 sys_clk2 = ~sys_clk2;

single_bit_async single_bit_async1(
    .clk1 (sys_clk1 ),
    .clk2 (sys_clk2 ),
    .read (read ),
    .sys_rst_n (sys_rst_n),
    .clk1_dly1(clk1_dly1),
    .clk1_dly2(clk1_dly2),
    .clk1_or(clk1_or),
    .clk2_sync1(clk2_sync1),
    .clk2_sync2(clk2_sync2),
    .read_async_read(read_async_read)
 );
endmodule