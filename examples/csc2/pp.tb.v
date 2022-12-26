module tb;

   parameter W=16;

   /*autowire*/

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


% for $i (0..2) {

   /* gen_seq AUTO_TEMPLATE
      (
         .cd_d0(x${i}[]),
         .cd_mflags(x${i}_mflags[]),
      );
   */
   gen_seq #(.W(W)) u_x${i} (
      .clk, .rst_n,
      .cnt_ini(16'd1+16'd${i}), .cnt_max(16'd5+16'd${i}), .cnt_inc(16'd1),

      // inputs from UP
      .uc_d0(16'b0),
      .uc_mflags(4'b0101), // AFLV

      // outputs UP
      .cu_sflags(),

      // inputs from DOWN
      .dc_sflags(2'b00),

      /*autoinst*/
   );

% }

   /* csc AUTO_TEMPLATE
      (
         .A00(16'd1), 
         .A01(16'd1), 
         .A02(16'd1),
         .A10(-16'd1), 
         .A11(16'd4), 
         .A12(-16'd1),
         .A20(16'd0), 
         .A21(16'd0), 
         .A22(16'd3),
         .x\(.*\)(x\1[]),
         .y\(.*\)_sflags (2'b00),
      );
   */

   csc #(.W(W)) csc_0 (/*autoinst*/);

   reg tb_bsy;
   initial begin
      forever begin
         tb_bsy = 1'b0;
         repeat (10) @(posedge clk);
         tb_bsy = 1'b1;
         repeat (2)  @(posedge clk);
      end
   end


endmodule

// Local Variables:
// verilog-library-directories :("." "../../gen" "../../lib")
// end:
