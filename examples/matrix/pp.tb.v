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


   /* gen_seq AUTO_TEMPLATE
      (
         .cd_d0(x_in[]),
         .cd_mflags(x_in_mflags[]),
      );
   */
   gen_seq #(.W(W)) u_x (
      .clk, .rst_n,
      .cnt_ini(16'd1), .cnt_max(16'd15),

      // inputs from UP
      .uc_d0(16'b0),
      .uc_mflags(4'b0101), // AFLV

      // outputs UP
      .cu_sflags(),

      // inputs from DOWN
      .dc_sflags(2'b00),

      /*autoinst*/
   );


   /* fir4 AUTO_TEMPLATE
      (
         .B0(16'd1), 
         .B1(16'd1), 
         .B2(16'd1),
         .B3(-16'd1), 
         .x_in\(.*\)(x_in\1[]),
         .y_out\(.*\)_sflags (2'b00),
      );
   */

   fir4 #(.W(W)) u_fir4_0 (/*autoinst*/);

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
