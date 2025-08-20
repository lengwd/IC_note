`timescale 10ns/1ns
module sync_fifo_tb();

reg rst_n, clk, rd_en, wr_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire full, empty;

sync_fifo dut(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .en_rd(rd_en),
    .en_wr(wr_en),
    .data_out(data_out),
    .empty(empty),
    .full(full)
);

initial begin
    clk = 0;
    forever #20 clk = ~clk;
end

initial begin
    rst_n = 0;
    #50 rst_n = 1; // 多给几个时钟
end

initial begin
    wr_en = 0;
    #60 wr_en = 1; // 保证复位后再写
    #640 wr_en = 0;
end

initial begin
    rd_en = 0;
    #700 rd_en = 1;
end

initial begin
    data_in = 8'h0;
    repeat (16) begin
        #40 data_in = data_in + 1;
    end
end

endmodule
