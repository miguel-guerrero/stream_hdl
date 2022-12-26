module tb;

   reg clk;
   initial begin
      clk <= 0;
      forever 
         #5 clk <= ~clk;
   end

   reg rst_n;
   initial begin
      rst_n <= 1'b0;
      repeat(5)
         @(posedge clk);
      rst_n <= 1'b1;

      repeat(1000)
         @(posedge clk);
      $finish;
   end

   reg first;
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         first <= 1'b1;
      end
      else begin
         first <= 1'b0;
      end
   end

   parameter W=16;
   wire [W-1:0] gs_cnt, cs_cnt0, cs_cnt1;

   wire [3:0] gs_mflags, cs_mflags, add_mflags, mul_mflags, del_mflags, dup_mflags, gs1_mflags, sr_mflags, dl2_mflags;
   wire [1:0] gs_sflags, cs_sflags, add_sflags, mul_sflags, del_sflags, dup_sflags, gs1_sflags, sr_sflags, dl2_sflags;

   gen_seq #(.W(W)) gs_0 (
      .clk, .rst_n,
      .cnt_ini(16'd1), .cnt_max(16'd5), .cnt_inc(16'd1),

      // inputs from UP
      .uc_d0(16'b0),
      .uc_mflags(4'b0101), // AFLV

      // outputs UP
      .cu_sflags(),

      // outputs DOWN
      .cd_d0(gs_cnt),
      .cd_mflags(gs_mflags),

      // inputs from DOWN
      .dc_sflags(cs_sflags)
   );

   cross_seqx2 #(.W(W)) cs_0 (
      .clk, .rst_n,
      .cnt_ini(16'd1), .cnt_max(16'd9), .cnt_inc(16'd1),

      // inputs from UP
      .uc_d0(gs_cnt),
      .uc_mflags(gs_mflags),

      // outputs UP
      .cu_sflags(cs_sflags),

      // outputs DOWN
      .cd_d0(cs_cnt0), .cd_d1(cs_cnt1),
      .cd_mflags(cs_mflags),

       // Inputs from DOWN
      .dc_sflags(add_sflags)
   );

   reg [W-1:0] dup_out;
   dup #(.W(W)) dup_0 (
      .clk, .rst_n,
      .N(16'd4),

       // Inputs from UP
      .uc_d0(cs_cnt1),
      .uc_mflags(cs_mflags),

      // outputs UP
      .cu_sflags(dup_sflags),

      // outputs DOWN
      .cd_d0(dup_out),
      .cd_mflags(),

       // Inputs from DOWN
      .dc_sflags(2'b0)
   );

   wire [W-1:0] add_out;
   sum_2 #(.W(W)) add_0 (
       .clk, .rst_n, 

       // Inputs from UP
       .uc_d0(cs_cnt0), .uc_d1(cs_cnt1), 
       .uc_mflags(cs_mflags),

       // Outputs UP
       .cu_sflags(add_sflags),

       // Outputs DOWN
       .cd_d0(add_out), 
       .cd_mflags(add_mflags),

       // Inputs from DOWN
       .dc_sflags(mul_sflags)
   );

   wire [W-1:0] mul_out;
   mul_2 #(.W(W)) mul_0 (
       .clk, .rst_n, 

       // Inputs from UP
       .uc_d0(add_out), .uc_d1(16'd8), 
       .uc_mflags(add_mflags),

       // Outputs UP
       .cu_sflags(mul_sflags),

       // Outputs DOWN
       .cd_d0(mul_out), 
       .cd_mflags(mul_mflags),

       // Inputs from DOWN
       .dc_sflags(del_sflags)
   );

   reg tb_bsy;
   initial begin
      forever begin
         tb_bsy = 1'b0;
         repeat (10) @(posedge clk);
         tb_bsy = 1'b1;
         repeat (2)  @(posedge clk);
      end
   end


   wire [W-1:0] del_out;
   delay #(.W(W)) delay_0 (
       // Inputs from UP
       .clk, .rst_n, 
       .uc_d0(mul_out), 
       .uc_mflags(mul_mflags),

       // Outputs UP
       .cu_sflags(del_sflags),

       // Outputs DOWN
       .cd_d0(del_out), 
       .cd_mflags(),

       // Inputs from DOWN
       .dc_sflags({1'b0, tb_bsy})
   );


   reg [W-1:0] gs1_out;
   gen_seq #(.W(W)) gs_1 (
      .clk, .rst_n,
      .cnt_ini(16'd2), .cnt_max(16'd15), .cnt_inc(16'd1),

      // inputs from UP
      .uc_d0(16'b0),
      .uc_mflags(4'b0101), // AFLV

      // outputs UP
      .cu_sflags(),

      // outputs DOWN
      .cd_d0(gs1_out),
      .cd_mflags(gs1_mflags),

      // inputs from DOWN
      .dc_sflags(sr_sflags)
   );

   wire [W-1:0] sr_out;
   // not hooked just to check back to back
   sum_reduce #(.W(W)) sr_0 (
      .clk, .rst_n,

      // inputs from UP
      .uc_d0(gs1_out),
      .uc_mflags(gs1_mflags), // FLV

      // outputs UP
      .cu_sflags(sr_sflags),

      // outputs DOWN
      .cd_d0(sr_out),
      .cd_mflags(sr_mflags),

      // inputs from DOWN
      .dc_sflags(dl2_sflags)
   );

   wire [W-1:0] dl2_out0;
   wire [W-1:0] dl2_out1;
   wire [W-1:0] dl2_out2;
   // not hooked just to check back to back
   delay_line2x3 #(.W(W)) dl2_0 (
      .clk, .rst_n,

      // inputs from UP
      .uc_d0(sr_out),
      .uc_mflags(sr_mflags), // FLV

      // outputs UP
      .cu_sflags(dl2_sflags),

      // outputs DOWN
      .cd_d0(dl2_out0),
      .cd_d1(dl2_out1),
      .cd_d2(dl2_out2),
      .cd_mflags(dl2_mflags),

      // inputs from DOWN
      .dc_sflags({1'b0, tb_bsy})
   );


endmodule
