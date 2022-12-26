module csc #(parameter W=32) (
    input  clk
   ,input  rst_n
   ,input  [W-1:0] x0
   ,input  [3:0] x0_mflags
   ,output [1:0] x0_sflags
   ,input  [W-1:0] x1
   ,input  [3:0] x1_mflags
   ,output [1:0] x1_sflags
   ,input  [W-1:0] x2
   ,input  [3:0] x2_mflags
   ,output [1:0] x2_sflags
   ,input [W-1:0] A00
   ,input [W-1:0] A01
   ,input [W-1:0] A02
   ,input [W-1:0] A10
   ,input [W-1:0] A11
   ,input [W-1:0] A12
   ,input [W-1:0] A20
   ,input [W-1:0] A21
   ,input [W-1:0] A22
   ,output [W-1:0] y0
   ,output [3:0] y0_mflags
   ,input  [1:0] y0_sflags
   ,output [W-1:0] y1
   ,output [3:0] y1_mflags
   ,input  [1:0] y1_sflags
   ,output [W-1:0] y2
   ,output [3:0] y2_mflags
   ,input  [1:0] y2_sflags
);

wire [W-1:0] x_0;
wire [3:0]   x_0_mflags;
wire [1:0]   x_0_sflags;
wire [W-1:0] x_1;
wire [3:0]   x_1_mflags;
wire [1:0]   x_1_sflags;
wire [W-1:0] x_2;
wire [3:0]   x_2_mflags;
wire [1:0]   x_2_sflags;
wire [W-1:0] mul_00;
wire [3:0]   mul_00_mflags;
wire [1:0]   mul_00_sflags;
wire [W-1:0] mul_01;
wire [3:0]   mul_01_mflags;
wire [1:0]   mul_01_sflags;
wire [W-1:0] mul_02;
wire [3:0]   mul_02_mflags;
wire [1:0]   mul_02_sflags;
wire [W-1:0] mul_10;
wire [3:0]   mul_10_mflags;
wire [1:0]   mul_10_sflags;
wire [W-1:0] mul_11;
wire [3:0]   mul_11_mflags;
wire [1:0]   mul_11_sflags;
wire [W-1:0] mul_12;
wire [3:0]   mul_12_mflags;
wire [1:0]   mul_12_sflags;
wire [W-1:0] mul_20;
wire [3:0]   mul_20_mflags;
wire [1:0]   mul_20_sflags;
wire [W-1:0] mul_21;
wire [3:0]   mul_21_mflags;
wire [1:0]   mul_21_sflags;
wire [W-1:0] mul_22;
wire [3:0]   mul_22_mflags;
wire [1:0]   mul_22_sflags;
wire [W-1:0] y_0;
wire [3:0]   y_0_mflags;
wire [1:0]   y_0_sflags;
wire [W-1:0] y_1;
wire [3:0]   y_1_mflags;
wire [1:0]   y_1_sflags;
wire [W-1:0] y_2;
wire [3:0]   y_2_mflags;
wire [1:0]   y_2_sflags;
wire [4-1:0] A00_mflags;
wire [4-1:0] A01_mflags;
wire [4-1:0] A02_mflags;
wire [4-1:0] A10_mflags;
wire [4-1:0] A11_mflags;
wire [4-1:0] A12_mflags;
wire [4-1:0] A20_mflags;
wire [4-1:0] A21_mflags;
wire [4-1:0] A22_mflags;
wire [4-1:0] u_bufin_0_mflags;
wire [4-1:0] u_bufin_1_mflags;
wire [4-1:0] u_bufin_2_mflags;
wire [2-1:0] u_mul_2_0_sflags;
wire [4-1:0] u_mul_2_0_mflags;
wire [2-1:0] u_mul_2_1_sflags;
wire [4-1:0] u_mul_2_1_mflags;
wire [2-1:0] u_mul_2_2_sflags;
wire [4-1:0] u_mul_2_2_mflags;
wire [2-1:0] u_mul_2_3_sflags;
wire [4-1:0] u_mul_2_3_mflags;
wire [2-1:0] u_mul_2_4_sflags;
wire [4-1:0] u_mul_2_4_mflags;
wire [2-1:0] u_mul_2_5_sflags;
wire [4-1:0] u_mul_2_5_mflags;
wire [2-1:0] u_mul_2_6_sflags;
wire [4-1:0] u_mul_2_6_mflags;
wire [2-1:0] u_mul_2_7_sflags;
wire [4-1:0] u_mul_2_7_mflags;
wire [2-1:0] u_mul_2_8_sflags;
wire [4-1:0] u_mul_2_8_mflags;
wire [2-1:0] u_sum_3_0_sflags;
wire [4-1:0] u_sum_3_0_mflags;
wire [2-1:0] u_sum_3_1_sflags;
wire [4-1:0] u_sum_3_1_mflags;
wire [2-1:0] u_sum_3_2_sflags;
wire [4-1:0] u_sum_3_2_mflags;
wire [2-1:0] u_bufout_0_sflags;
wire [2-1:0] u_bufout_1_sflags;
wire [2-1:0] u_bufout_2_sflags;
assign A00_mflags = 4'b0111;
assign A01_mflags = 4'b0111;
assign A02_mflags = 4'b0111;
assign A10_mflags = 4'b0111;
assign A11_mflags = 4'b0111;
assign A12_mflags = 4'b0111;
assign A20_mflags = 4'b0111;
assign A21_mflags = 4'b0111;
assign A22_mflags = 4'b0111;

bufin #(.W(W)) u_bufin_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(x0_sflags)
    // in from upstream
   ,.uc_d0(x0)
   ,.uc_mflags(x0_mflags)
    // out to downstream
   ,.cd_d0(x_0)
   ,.cd_mflags(u_bufin_0_mflags)
    // in from downstream
   ,.dc_sflags(u_mul_2_0_sflags | u_mul_2_3_sflags | u_mul_2_6_sflags)
);

bufin #(.W(W)) u_bufin_1 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(x1_sflags)
    // in from upstream
   ,.uc_d0(x1)
   ,.uc_mflags(x1_mflags)
    // out to downstream
   ,.cd_d0(x_1)
   ,.cd_mflags(u_bufin_1_mflags)
    // in from downstream
   ,.dc_sflags(u_mul_2_1_sflags | u_mul_2_4_sflags | u_mul_2_7_sflags)
);

bufin #(.W(W)) u_bufin_2 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(x2_sflags)
    // in from upstream
   ,.uc_d0(x2)
   ,.uc_mflags(x2_mflags)
    // out to downstream
   ,.cd_d0(x_2)
   ,.cd_mflags(u_bufin_2_mflags)
    // in from downstream
   ,.dc_sflags(u_mul_2_2_sflags | u_mul_2_5_sflags | u_mul_2_8_sflags)
);

mul_2 #(.W(W)) u_mul_2_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_0_sflags)
    // in from upstream
   ,.uc_d0(A00)
   ,.uc_d1(x_0)
   ,.uc_mflags(A00_mflags & u_bufin_0_mflags)
    // out to downstream
   ,.cd_d0(mul_00)
   ,.cd_mflags(u_mul_2_0_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_1 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_1_sflags)
    // in from upstream
   ,.uc_d0(A01)
   ,.uc_d1(x_1)
   ,.uc_mflags(A01_mflags & u_bufin_1_mflags)
    // out to downstream
   ,.cd_d0(mul_01)
   ,.cd_mflags(u_mul_2_1_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_2 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_2_sflags)
    // in from upstream
   ,.uc_d0(A02)
   ,.uc_d1(x_2)
   ,.uc_mflags(A02_mflags & u_bufin_2_mflags)
    // out to downstream
   ,.cd_d0(mul_02)
   ,.cd_mflags(u_mul_2_2_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_3 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_3_sflags)
    // in from upstream
   ,.uc_d0(A10)
   ,.uc_d1(x_0)
   ,.uc_mflags(A10_mflags & u_bufin_0_mflags)
    // out to downstream
   ,.cd_d0(mul_10)
   ,.cd_mflags(u_mul_2_3_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_1_sflags)
);

mul_2 #(.W(W)) u_mul_2_4 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_4_sflags)
    // in from upstream
   ,.uc_d0(A11)
   ,.uc_d1(x_1)
   ,.uc_mflags(A11_mflags & u_bufin_1_mflags)
    // out to downstream
   ,.cd_d0(mul_11)
   ,.cd_mflags(u_mul_2_4_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_1_sflags)
);

mul_2 #(.W(W)) u_mul_2_5 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_5_sflags)
    // in from upstream
   ,.uc_d0(A12)
   ,.uc_d1(x_2)
   ,.uc_mflags(A12_mflags & u_bufin_2_mflags)
    // out to downstream
   ,.cd_d0(mul_12)
   ,.cd_mflags(u_mul_2_5_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_1_sflags)
);

mul_2 #(.W(W)) u_mul_2_6 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_6_sflags)
    // in from upstream
   ,.uc_d0(A20)
   ,.uc_d1(x_0)
   ,.uc_mflags(A20_mflags & u_bufin_0_mflags)
    // out to downstream
   ,.cd_d0(mul_20)
   ,.cd_mflags(u_mul_2_6_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_2_sflags)
);

mul_2 #(.W(W)) u_mul_2_7 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_7_sflags)
    // in from upstream
   ,.uc_d0(A21)
   ,.uc_d1(x_1)
   ,.uc_mflags(A21_mflags & u_bufin_1_mflags)
    // out to downstream
   ,.cd_d0(mul_21)
   ,.cd_mflags(u_mul_2_7_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_2_sflags)
);

mul_2 #(.W(W)) u_mul_2_8 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_8_sflags)
    // in from upstream
   ,.uc_d0(A22)
   ,.uc_d1(x_2)
   ,.uc_mflags(A22_mflags & u_bufin_2_mflags)
    // out to downstream
   ,.cd_d0(mul_22)
   ,.cd_mflags(u_mul_2_8_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_3_2_sflags)
);

sum_3 #(.W(W)) u_sum_3_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_sum_3_0_sflags)
    // in from upstream
   ,.uc_d0(mul_00)
   ,.uc_d1(mul_01)
   ,.uc_d2(mul_02)
   ,.uc_mflags(u_mul_2_0_mflags & u_mul_2_1_mflags & u_mul_2_2_mflags)
    // out to downstream
   ,.cd_d0(y_0)
   ,.cd_mflags(u_sum_3_0_mflags)
    // in from downstream
   ,.dc_sflags(u_bufout_0_sflags)
);

sum_3 #(.W(W)) u_sum_3_1 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_sum_3_1_sflags)
    // in from upstream
   ,.uc_d0(mul_10)
   ,.uc_d1(mul_11)
   ,.uc_d2(mul_12)
   ,.uc_mflags(u_mul_2_3_mflags & u_mul_2_4_mflags & u_mul_2_5_mflags)
    // out to downstream
   ,.cd_d0(y_1)
   ,.cd_mflags(u_sum_3_1_mflags)
    // in from downstream
   ,.dc_sflags(u_bufout_1_sflags)
);

sum_3 #(.W(W)) u_sum_3_2 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_sum_3_2_sflags)
    // in from upstream
   ,.uc_d0(mul_20)
   ,.uc_d1(mul_21)
   ,.uc_d2(mul_22)
   ,.uc_mflags(u_mul_2_6_mflags & u_mul_2_7_mflags & u_mul_2_8_mflags)
    // out to downstream
   ,.cd_d0(y_2)
   ,.cd_mflags(u_sum_3_2_mflags)
    // in from downstream
   ,.dc_sflags(u_bufout_2_sflags)
);

bufout #(.W(W)) u_bufout_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_bufout_0_sflags)
    // in from upstream
   ,.uc_d0(y_0)
   ,.uc_mflags(u_sum_3_0_mflags)
    // out to downstream
   ,.cd_d0(y0)
   ,.cd_mflags(y0_mflags)
    // in from downstream
   ,.dc_sflags(y0_sflags)
);

bufout #(.W(W)) u_bufout_1 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_bufout_1_sflags)
    // in from upstream
   ,.uc_d0(y_1)
   ,.uc_mflags(u_sum_3_1_mflags)
    // out to downstream
   ,.cd_d0(y1)
   ,.cd_mflags(y1_mflags)
    // in from downstream
   ,.dc_sflags(y1_sflags)
);

bufout #(.W(W)) u_bufout_2 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_bufout_2_sflags)
    // in from upstream
   ,.uc_d0(y_2)
   ,.uc_mflags(u_sum_3_2_mflags)
    // out to downstream
   ,.cd_d0(y2)
   ,.cd_mflags(y2_mflags)
    // in from downstream
   ,.dc_sflags(y2_sflags)
);

endmodule
