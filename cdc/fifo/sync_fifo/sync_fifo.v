module sync_fifo(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input en_rd,
    input en_wr,

    output reg [7:0] data_out,
    output empty,
    output full
);

reg [7:0] ram [15:0];


// 读信号 指针
wire [3:0] addr_rd, addr_wr;
// 扩展指针用于判断空满
reg [4:0] addr_rd_a, addr_wr_a;
// 指针 取扩展指针的低四位
assign addr_rd = addr_rd_a[3:0];
assign addr_wr = addr_wr_a[3:0];

// 读逻辑
always @(posedge clk ) begin
    if(!rst_n)begin
        addr_rd_a <= 5'b0;
        data_out <= 8'b0;
    end
    else begin
        if(en_rd && !empty)begin
            data_out <= ram[addr_rd];
            addr_rd_a <= addr_rd_a + 1'b1;
        end
    end
    
end


// 写逻辑
always @(posedge clk ) begin
    if (!rst_n) begin
        addr_wr_a <= 5'b0;
    end
    else begin
        if(en_wr && !full) begin
            ram[addr_wr] <= data_in;
            addr_wr_a <= addr_wr_a + 1'b1;
        end
    end
end

// full/ empty
// 下面这个代码用于判断读写不超过一个周期
assign full =  (addr_wr_a[4] != addr_rd_a[4] && addr_wr_a[3:0] == addr_rd_a[3:0])?1'b1:1'b0;
assign empty = (addr_rd_a == addr_wr_a)?1'b1:1'b0;

    
endmodule