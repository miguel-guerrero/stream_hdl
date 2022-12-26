
module iir4

parameter W=32

sin [W] x_in
input [W] B0
input [W] B1
input [W] B2
input [W] B3
input [W] A1
input [W] A2
input [W] A3
sout [W] y_out
hstr [W] feedback 

    regin  x_in -> x

    delay_line3 x -> x0 x1 x2 x3

    mul B0 x0 -> p_0
    mul B1 x1 -> p_1
    mul B2 x2 -> p_2
    mul B3 x3 -> p_3

    sum p_0 p_1 p_2 p_3 -> forward


    combo_sum forward feedback -> ym

    delay_line2 ym -> y0 y1 y2
    mul A1 y0 -> q_1
    mul A2 y1 -> q_2
    combo_sum q_1 q_2 -> feedback

    regout y0 -> y_out

endmodule
