module fir4 #(parameter W=32) (
    input  clk
   ,input  rst_n
   ,input  [W-1:0] x_in
   ,input  [3:0] x_in_mflags
   ,output [1:0] x_in_sflags
   ,input [W-1:0] B0
   ,input [W-1:0] B1
   ,input [W-1:0] B2
   ,input [W-1:0] B3
   ,output [W-1:0] y_out
   ,output [3:0] y_out_mflags
   ,input  [1:0] y_out_sflags
);

wire [W-1:0] x;
wire [3:0]   x_mflags;
wire [1:0]   x_sflags;
wire [W-1:0] x0;
wire [3:0]   x0_mflags;
wire [1:0]   x0_sflags;
wire [W-1:0] x1;
wire [3:0]   x1_mflags;
wire [1:0]   x1_sflags;
wire [W-1:0] x2;
wire [3:0]   x2_mflags;
wire [1:0]   x2_sflags;
wire [W-1:0] x3;
wire [3:0]   x3_mflags;
wire [1:0]   x3_sflags;
wire [W-1:0] mul_0;
wire [3:0]   mul_0_mflags;
wire [1:0]   mul_0_sflags;
wire [W-1:0] mul_1;
wire [3:0]   mul_1_mflags;
wire [1:0]   mul_1_sflags;
wire [W-1:0] mul_2;
wire [3:0]   mul_2_mflags;
wire [1:0]   mul_2_sflags;
wire [W-1:0] mul_3;
wire [3:0]   mul_3_mflags;
wire [1:0]   mul_3_sflags;
wire [W-1:0] y;
wire [3:0]   y_mflags;
wire [1:0]   y_sflags;
wire [4-1:0] B0_mflags;
wire [4-1:0] B1_mflags;
wire [4-1:0] B2_mflags;
wire [4-1:0] B3_mflags;
wire [4-1:0] u_bufin_0_mflags;
wire [2-1:0] u_delay_line3x4_0_sflags;
wire [4-1:0] u_delay_line3x4_0_mflags;
wire [2-1:0] u_mul_2_0_sflags;
wire [4-1:0] u_mul_2_0_mflags;
wire [2-1:0] u_mul_2_1_sflags;
wire [4-1:0] u_mul_2_1_mflags;
wire [2-1:0] u_mul_2_2_sflags;
wire [4-1:0] u_mul_2_2_mflags;
wire [2-1:0] u_mul_2_3_sflags;
wire [4-1:0] u_mul_2_3_mflags;
wire [2-1:0] u_sum_4_0_sflags;
wire [4-1:0] u_sum_4_0_mflags;
wire [2-1:0] u_bufout_0_sflags;
assign B0_mflags = 4'b0111;
assign B1_mflags = 4'b0111;
assign B2_mflags = 4'b0111;
assign B3_mflags = 4'b0111;

bufin #(.W(W)) u_bufin_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(x_in_sflags)
    // in from upstream
   ,.uc_d0(x_in)
   ,.uc_mflags(x_in_mflags)
    // out to downstream
   ,.cd_d0(x)
   ,.cd_mflags(u_bufin_0_mflags)
    // in from downstream
   ,.dc_sflags(u_delay_line3x4_0_sflags)
);

delay_line3x4 #(.W(W)) u_delay_line3x4_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_delay_line3x4_0_sflags)
    // in from upstream
   ,.uc_d0(x)
   ,.uc_mflags(u_bufin_0_mflags)
    // out to downstream
   ,.cd_d0(x0)
   ,.cd_d1(x1)
   ,.cd_d2(x2)
   ,.cd_d3(x3)
   ,.cd_mflags(u_delay_line3x4_0_mflags)
    // in from downstream
   ,.dc_sflags(u_mul_2_0_sflags | u_mul_2_1_sflags | u_mul_2_2_sflags | u_mul_2_3_sflags)
);

mul_2 #(.W(W)) u_mul_2_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_0_sflags)
    // in from upstream
   ,.uc_d0(B0)
   ,.uc_d1(x0)
   ,.uc_mflags(B0_mflags & u_delay_line3x4_0_mflags)
    // out to downstream
   ,.cd_d0(mul_0)
   ,.cd_mflags(u_mul_2_0_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_4_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_1 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_1_sflags)
    // in from upstream
   ,.uc_d0(B1)
   ,.uc_d1(x1)
   ,.uc_mflags(B1_mflags & u_delay_line3x4_0_mflags)
    // out to downstream
   ,.cd_d0(mul_1)
   ,.cd_mflags(u_mul_2_1_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_4_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_2 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_2_sflags)
    // in from upstream
   ,.uc_d0(B2)
   ,.uc_d1(x2)
   ,.uc_mflags(B2_mflags & u_delay_line3x4_0_mflags)
    // out to downstream
   ,.cd_d0(mul_2)
   ,.cd_mflags(u_mul_2_2_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_4_0_sflags)
);

mul_2 #(.W(W)) u_mul_2_3 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_mul_2_3_sflags)
    // in from upstream
   ,.uc_d0(B3)
   ,.uc_d1(x3)
   ,.uc_mflags(B3_mflags & u_delay_line3x4_0_mflags)
    // out to downstream
   ,.cd_d0(mul_3)
   ,.cd_mflags(u_mul_2_3_mflags)
    // in from downstream
   ,.dc_sflags(u_sum_4_0_sflags)
);

sum_4 #(.W(W)) u_sum_4_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_sum_4_0_sflags)
    // in from upstream
   ,.uc_d0(mul_0)
   ,.uc_d1(mul_1)
   ,.uc_d2(mul_2)
   ,.uc_d3(mul_3)
   ,.uc_mflags(u_mul_2_0_mflags & u_mul_2_1_mflags & u_mul_2_2_mflags & u_mul_2_3_mflags)
    // out to downstream
   ,.cd_d0(y)
   ,.cd_mflags(u_sum_4_0_mflags)
    // in from downstream
   ,.dc_sflags(u_bufout_0_sflags)
);

bufout #(.W(W)) u_bufout_0 (
    .clk
   ,.rst_n
    // out to upstream
   ,.cu_sflags(u_bufout_0_sflags)
    // in from upstream
   ,.uc_d0(y)
   ,.uc_mflags(u_sum_4_0_mflags)
    // out to downstream
   ,.cd_d0(y_out)
   ,.cd_mflags(y_out_mflags)
    // in from downstream
   ,.dc_sflags(y_out_sflags)
);

endmodule
