module gray2binary #(
    parameter WIDTH = 4
) (
    input [WIDTH-1:0] gray,
    output [WIDTH-1:0] binary
);

assign binary[3] = gray[3];
assign binary[2] = binary[3] ^ gray[2];
assign binary[1] = binary[2] ^ gray[1];
assign binary[0] = binary[1] ^ gray[0];
    
endmodule



module binary2gray #(
    parameter WIDTH = 4
)(
    input [WIDTH-1:0] binary,
    output [WIDTH-1:0] gray
);

assign gray = binary ^ (binary>>1);

endmodule