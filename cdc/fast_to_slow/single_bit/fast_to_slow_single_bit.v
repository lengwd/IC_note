module single_bit_async(
    input clk1, // fast clock
    input clk2, // slow clock
    input read,

    input sys_rst_n,

    output clk1_dly1, clk1_dly2,
    output clk1_or,
    output clk2_sync1, clk2_sync2,
    output read_async_read
);

reg read_clk1_dly1, read_clk1_dly2;



always @(posedge clk1 ) begin
    if(! sys_rst_n)begin
        read_clk1_dly1 <= 1'b0;
        read_clk1_dly2 <= 1'b0;
    end
    else begin
        read_clk1_dly1 <= read;
        read_clk1_dly2 <= read_clk1_dly1;
    end
end

assign clk1_dly1 = read_clk1_dly1;
assign clk1_dly2 = read_clk1_dly2;

wire read_clk1_or;
assign read_clk1_or = read || read_clk1_dly1 || read_clk1_dly2;
assign clk1_or = read_clk1_or;

reg read_clk2_sync1, read_clk2_sync2;

always @(posedge clk2 ) begin
    if(! sys_rst_n)begin
        read_clk2_sync1 <= 1'b0;
        read_clk2_sync2 <= 1'b0;
    end else begin
        read_clk2_sync1 <= read_clk1_or;
        read_clk2_sync2 <= read_clk2_sync1;
    end
end

assign clk2_sync1 = read_clk2_sync1;
assign clk2_sync2 = read_clk2_sync2;

assign read_async_read = read_clk2_sync1 & ~read_clk2_sync2; 

endmodule