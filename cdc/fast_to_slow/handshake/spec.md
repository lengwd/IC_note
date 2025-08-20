# handshake module review

## transmit moudle

1.输入输出

> - 输入：clk_t, rst_n_t, data_in, vaild, ack_t, data_in_ack_t
> - 输出：req_t, data_out_t

2.模块设计

> - 第一步：通过vaild的信号的上升沿触发，避免同一个周期中多个信号传递
> - 第二步：ack信号 打两拍
> - 第三步：分先后 对于同一次交换过程中而言（1）valid 上升沿 传递信号 并且拉高req_t（2）收到ack信号 接受data_in 并且拉低req_t
> - 注意：但是在写逻辑的时候要把（2）写在（1）的前面，保证完成了一次handshake再进行第二次
> - 注意：同一个寄存器的所有逻辑要写在一个周期中

## receive

1.输入输出

> - 输入：clk_r, rst_n, data_in_r, req_r
> - 输出：ack_r, data_out_ack_r

2.模块设计

> - 第一步：req_r 信号打两拍同步
> - 第二步：（1）如果收到req_rdd的信号，就拉高ack_r并且传入信号、传出应答信号；（2）（之后transmit收到data_in信号，req_t会拉低）如果req_rdd拉低， ack_r信号拉低

## top

> 引用模块，定义wire将二者联系起来
