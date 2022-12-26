module csc

parameter W=32

sin [W] x0
sin [W] x1
sin [W] x2
input [W] A00
input [W] A01
input [W] A02
input [W] A10
input [W] A11
input [W] A12
input [W] A20
input [W] A21
input [W] A22
sout [W] y0
sout [W] y1
sout [W] y2

    bufin  x0 -> x_0
    bufin  x1 -> x_1
    bufin  x2 -> x_2

    mul A00 x_0 -> mul_00
    mul A01 x_1 -> mul_01
    mul A02 x_2 -> mul_02
    mul A10 x_0 -> mul_10
    mul A11 x_1 -> mul_11
    mul A12 x_2 -> mul_12
    mul A20 x_0 -> mul_20
    mul A21 x_1 -> mul_21
    mul A22 x_2 -> mul_22

    sum mul_00 mul_01 mul_02 -> y_0
    sum mul_10 mul_11 mul_12 -> y_1
    sum mul_20 mul_21 mul_22 -> y_2

    bufout y_0 -> y0
    bufout y_1 -> y1
    bufout y_2 -> y2

endmodule
