module async_fifo ( 
    input r_clk,
    input w_clk,
    input rst_n,
    input r_en,
    input w_en,
    input [7:0] data_in,

    output reg [7:0] data_out,
    output empty,
    output full
);

reg [7:0] ram [15:0] ;
// 指针扩展 及指针
reg [4:0] r_addr_a, w_addr_a;
wire [3:0] r_addr, w_addr;
assign r_addr = r_addr_a_g[3:0];
assign w_addr = w_addr_a_g[3:0];

// gray encode

wire  [4:0] r_addr_a_g, w_addr_a_g;

assign r_addr_a_g = r_addr_a ^ (r_addr_a >> 1); 
assign w_addr_a_g = w_addr_a ^ (w_addr_a >> 1);

// DFF

reg [4:0] r_addr_a_gd, r_addr_a_gdd; 
reg [4:0] w_addr_a_gd, w_addr_a_gdd;

always @(posedge w_clk ) begin
    if(!rst_n) begin
        r_addr_a_gd <= 5'b0;
        r_addr_a_gdd <= 5'b0;
    end
    else begin
        r_addr_a_gd <= r_addr_a_g;
        r_addr_a_gdd <= r_addr_a_gd;
    end
end

always @(posedge r_clk ) begin
    if(!rst_n) begin
        w_addr_a_gd <= 5'b0;
        w_addr_a_gdd <= 5'b0;
    end
    else begin
        w_addr_a_gd <= w_addr_a_g;
        w_addr_a_gdd <= w_addr_a_gd;
    end
end

// 读逻辑

always @(posedge r_clk ) begin
    if(!rst_n) begin
        r_addr_a <= 5'b0;
        data_out <= 8'b0;
    end
    else begin
        if(r_en && !empty) begin
            r_addr_a <= r_addr_a + 1'b1;
            data_out <= ram[r_addr];
        end
    end
    
end

// 写逻辑
always @(posedge w_clk ) begin
    if(!rst_n)begin
        w_addr_a <= 5'b0;
    end
    else begin
        if(w_en && !full)begin
            w_addr_a <= w_addr_a + 1'b1;
            ram[w_addr] <= data_in;
        end
    end
    
end

//empty / full

assign empty = (r_addr_a_g == w_addr_a_gdd) ? 1'b1 : 1'b0;
assign full = (w_addr_a_g[4] != r_addr_a_gdd[4] && w_addr_a_g[3:0] == r_addr_a_gdd[3:0]) ? 1'b1 : 1'b0; 



    
endmodule