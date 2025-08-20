module tx (
    input t_clk,
    input t_rst_n,
    input valid,
    input [31:0] data_in, 
    input ack_t,
    input [31:0] data_in_t,

    output reg [31:0] data_out_t,
    output reg req_t

);


// 第一步dataout 的逻辑，vaild信号
reg valid_d; // valid 信号打一拍

always @(posedge t_clk or negedge t_rst_n) begin
    if(!t_rst_n)begin
        valid_d <= 1'b0;
    end else begin
        valid_d <= valid;
    end
end

// 为了防止一个vaild的信号期间输出多个信号，用上升沿做作为触发
wire valid_flag; 
assign valid_flag = valid & (~valid_d);





// //2打拍 

reg ack_td, ack_tdd; // acknowledge 打两拍
always@(posedge t_clk or negedge t_rst_n) begin
    if(!t_rst_n)begin
        ack_td <= 1'b0;
        ack_tdd <= 1'b0;
    end else begin
        ack_td <= ack_t;
        ack_tdd <= ack_td;
    end
end

// 3.输出与回收逻辑
reg [31:0] data_in_t_valid;

always@(posedge t_clk or negedge t_rst_n) begin
    if(!t_rst_n)begin
        data_out_t <= 32'b0;
        req_t <= 1'b0;
        data_in_t_valid <= 32'b0;
    end
    else begin
        if (ack_tdd == 1) begin
            req_t <= 1'b0;
            data_in_t_valid <= data_in_t; 
        end
        else if(valid_flag)begin
            data_out_t <= data_in;
            req_t <= 1'b1;
        end 
    end
end

    
endmodule


module rx (
    input r_clk,
    input rst_n,
    input req_r,
    input [31:0] data_in_r, 

    output reg ack_r,
    output reg [31:0] data_out_r

);

// 1. req_r 信号打两拍

reg req_rd, req_rdd;

always @(posedge r_clk or negedge rst_n ) begin
    if(!rst_n)begin
        req_rd <= 1'b0;
        req_rdd <= 1'b0;
    end
    else begin
        req_rd <= req_r;
        req_rdd <= req_rd;
    end
    
end

// 2. 存储并输出
reg [31:0] data_in_r_valid;
always @(posedge r_clk or negedge rst_n ) begin
    if(!rst_n)begin
        data_in_r_valid <= 32'b0;
        ack_r <= 1'b0;
        data_out_r <= 32'b0;
    end
    else begin
        if(req_rdd)begin
            data_in_r_valid <= data_in_r;
            ack_r <= 1'b1;
            data_out_r <= ~data_in_r;
        end
        else if(!req_rdd) begin // req 信号拉低
            ack_r <= 1'b0;
        end
    end
end
    
endmodule


module handshake_top (
    input t_clk,
    input r_clk,
    input rst_n,
    input valid,
    input [31:0] data_in
    
);

wire req, ack;
wire [31:0] write_data, read_data;

tx transmit(
    .t_clk(t_clk),
    .t_rst_n(rst_n),
    .valid(valid),
    .data_in(data_in), 
    .ack_t(ack),
    .data_in_t(read_data),

    .data_out_t(write_data),
    .req_t(req)    
);

rx receive(
    .r_clk(r_clk),
    .rst_n(rst_n),
    .req_r(req),
    .data_in_r(write_data), 

    .ack_r(ack),
    .data_out_r(read_data)    
);
    
endmodule