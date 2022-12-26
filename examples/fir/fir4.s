module fir4

parameter W=32

sin [W] x_in
input [W] B0
input [W] B1
input [W] B2
input [W] B3
sout [W] y_out

    bufin  x_in -> x

    delay_line3 x -> x0 x1 x2 x3

    mul B0 x0 -> mul_0
    mul B1 x1 -> mul_1
    mul B2 x2 -> mul_2
    mul B3 x3 -> mul_3

    sum mul_0 mul_1 mul_2 mul_3 -> y

    bufout y -> y_out

endmodule
