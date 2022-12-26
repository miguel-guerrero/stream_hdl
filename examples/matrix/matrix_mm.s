module matrix_mm

parameter W=32

input [W] A
input [W] X
input [W] Y
input [W] COLS
input [W] ROWS
input [W] STRIDE

    mem_1rw [W] M1 

    gen_seq   (.cnt_ini(0), .cnt_max(ROWS))    -> i0

        mul STRIDE i0  -> row_offs
        add A row_offs -> a_row_addr

        cross_seq (.cnt_ini(0), .cnt_max(COLS)) i0 -> i j

            getmi<M1> X, j          -> x_j
            getmi<M1> a_row_addr, j -> a_ij

            mul a_ij x_j    -> p_ij

            sum_reduce p_ij -> y_j

            setmi.on_last<M1> Y, j, y_ij       // only on last of str

endmodule
