module csc #(parameter W=16) (

  input clk,
  input rst_n,

  input [W-1:0] A00, A01, A02,
  input [W-1:0] A10, A11, A12,
  input [W-1:0] A20, A21, A22,

  input [W-1:0] x0, 
  input [W-1:0] x1,
  input [W-1:0] x2,

  input  [3:0] x0_mflags,
  output [1:0] x0_sflags,

  input  [3:0] x1_mflags,
  output [1:0] x1_sflags,

  input  [3:0] x2_mflags,
  output [1:0] x2_sflags,

  output  [W-1:0] y0,
  output  [3:0]   y0_mflags,
  input   [1:0]   y0_sflags,

  output  [W-1:0] y1,
  output  [3:0]   y1_mflags,
  input   [1:0]   y1_sflags,

  output  [W-1:0] y2,
  output  [3:0]   y2_mflags,
  input   [1:0]   y2_sflags
);

/*autowire*/

assign x0_sflags = mul_00_sflags | mul_10_sflags | mul_20_sflags;
assign x1_sflags = mul_01_sflags | mul_11_sflags | mul_21_sflags;
assign x2_sflags = mul_02_sflags | mul_12_sflags | mul_22_sflags;

% for $i (0..2) {
%  for $j (0..2) {

   /* mul_2 AUTO_TEMPLATE
   (
      .uc_d0(A${i}${j}[]), 
      .uc_d1(x${j}[]),
      .uc_mflags(x${j}_mflags[]), // FLV

      // outputs UP
      .cu_sflags (mul_${i}${j}_sflags[]),

      // outputs DOWN
      .cd_d0(mul_${i}${j}[]),
      .cd_mflags (mul_${i}${j}_mflags[]),

      // inputs from DOWN
      .dc_sflags (sum_${i}_sflags[]),
   ); */

   mul_2 #(.W(W)) u_mul_${i}${j} (/*AUTOINST*/);

%  }
% }

% for $i (0..2) {

   /* sum_3 AUTO_TEMPLATE
   (
      .uc_d0(mul_${i}0[]), 
      .uc_d1(mul_${i}1[]),
      .uc_d2(mul_${i}2[]),
      .uc_mflags(mul_${i}0_mflags[]), // taking only one

      // outputs UP
      .cu_sflags (sum_${i}_sflags[]),

      // outputs DOWN
      .cd_d0     (y${i}[]),
      .cd_mflags (y${i}_mflags[]),

      // inputs from DOWN
      .dc_sflags (y${i}_sflags),
   ); */

   sum_3 #(.W(W)) u_sum_${i}${j} (/*AUTOINST*/);

% }



endmodule

// Local Variables:
// verilog-library-directories :("." "../../gen")
// end:
