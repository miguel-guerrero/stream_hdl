module matrix_mm

parameter W=32

input     start
input [W] A
input [W] X
input [W] Y
input [W] COLS
input [W] ROWS
input [W] STRIDE

    mem_1rw [W] M1 

    range  (.uc_fist(start), .cnt_ini(A), .cnt_inc(STRIDE), .times(ROWS))    -> a_i0

        cross_seq (.cnt_ini(0), .cnt_inc(1), .cnt_max(COLS))  -> a_i j

            getmi<M1> X, j   -> x_j
            getmi<M1> a_i, j -> a_ij

            mul a_ij x_j    -> p_ij

            sum_reduce p_ij -> y_j

            setmi.on_last<M1> Y, j, y_ij       // only on last of str

endmodule
