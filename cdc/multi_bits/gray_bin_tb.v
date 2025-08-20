module bin_to_gray_tb();

    reg [3:0] a ; 
    wire [3:0] y ;

    initial begin
        a = 4'd0;
        #100
        a = 4'd1;
        #100
        a = 4'd2;
        #100
        a = 4'd3;
        #100
        a = 4'd4;
        #100
        a = 4'd5;
        #100
        a = 4'd6;
        #100
        a = 4'd7;
        #100
        a = 4'd8;
        #100
        a = 4'd9;
        #100
        a = 4'd10;
        #100
        a = 4'd11;
        #100
        a = 4'd12;
        #100
        a = 4'd13;
        #100
        a = 4'd14;
        #100
        a = 4'd15; 

    end

    binary2gray u_bin_to_gray (
        .binary (a ),
        .gray (y )
    );

 endmodule