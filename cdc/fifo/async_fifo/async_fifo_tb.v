`timescale 1ns/1ps

module tb_async_fifo;

reg         r_clk, w_clk;
reg         rst_n;
reg         r_en, w_en;
reg  [7:0]  data_in;
wire [7:0]  data_out;
wire        empty, full;

// 实例化DUT
async_fifo dut (
    .r_clk(r_clk),
    .w_clk(w_clk),
    .rst_n(rst_n),
    .r_en(r_en),
    .w_en(w_en),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
);

// 时钟产生：异步
initial begin
    r_clk = 0;
    forever #7 r_clk = ~r_clk;   // 读时钟周期14ns
end

initial begin
    w_clk = 0;
    forever #5 w_clk = ~w_clk;   // 写时钟周期10ns
end

// 写入数据任务
task write_data(input [7:0] d);
begin
    @(negedge w_clk);
    w_en = 1;
    data_in = d;
    @(negedge w_clk);
    w_en = 0;
end
endtask

// 读出数据任务
task read_data(output [7:0] d);
begin
    @(negedge r_clk);
    r_en = 1;
    @(negedge r_clk);
    r_en = 0;
    d = data_out;
end
endtask

// 主控制流程
integer i;
reg [7:0] data_mem [0:15]; // 记录写入的数据
reg [7:0] data_tmp;

initial begin
    // 初始信号
    rst_n = 0;
    r_en = 0;
    w_en = 0;
    data_in = 0;
    #30;
    rst_n = 1;
    #20;

    // 1. 连续写入16个数据
    for (i=0; i<16; i=i+1) begin
        while (full) @(negedge w_clk); // 等待不满
        write_data(i+8'hA0);
        data_mem[i] = i+8'hA0;
        $display("Write: %h", i+8'hA0);
    end

    // 2. 再多写几次，验证full不会再写入
    repeat(3) begin
        write_data(8'hFF);
        $display("Try Write When Full: %h", 8'hFF);
    end

    // 3. 连续读出16个数据
    for (i=0; i<16; i=i+1) begin
        while (empty) @(negedge r_clk); // 等待非空
        read_data(data_tmp);
        $display("Read: %h (Expect: %h)", data_tmp, data_mem[i]);
        if (data_tmp !== data_mem[i])
            $display("ERROR: Data mismatch at %0d!", i);
    end

    // 4. 再多读几次，验证empty不会再读出
    repeat(3) begin
        read_data(data_tmp);
        $display("Try Read When Empty: %h", data_tmp);
    end

    $display("Testbench finished!");
    $stop;
end

endmodule
