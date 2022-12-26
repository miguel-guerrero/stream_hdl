module tb;

   parameter W=16;
   parameter AW=10;
   parameter TW=4;

   reg tb_bsy;
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

wire hold_0 = tb_bsy;
wire hold_1 = 1'b0;

% for $i (0..1) {
%  $base = 16*$i;

    /* gen_seq AUTO_TEMPLATE
        (
            .cd_d0(x${i}[]),
            .cd_mflags(x${i}_mflags[]),
            .dc_sflags(setmi_${i}_sflags[]),
        );
     */
     gen_seq #(.W(W)) u_x${i} (
        .clk, .rst_n,
        .cnt_ini(16'd${base} + 16'd1), .cnt_max(16'd${base} + 16'd15), .cnt_inc(16'd1),

        // inputs from UP
        .uc_d0(16'b0),
        .uc_mflags(4'b0101), // AFLV

        // outputs UP
        .cu_sflags(),

        /*autoinst*/
     );

    /* setmi AUTO_TEMPLATE
    (
        .uc_d0(x${i}[]), // addr offset0
        .uc_d1(16'd0), // addr offset1
        .uc_d2(x${i}[]), // wdata
        .uc_d3({13'b0, 1'b0, 1'b0, x${i}_mflags[0]}), // enable
        .uc_mflags(x${i}_mflags[] & {3'b111, ~hold_${i}}),
        .cu_sflags(setmi_${i}_sflags[]),

        // mem arbiter if outputs
        .client_\(.*\) (client_\1_${i}[]),
    );
    */
    setmi #(.W(W), .AW(AW))  u_setmi_${i}
        (/*autoinst*/);
% }

    /* arb_rr_2 AUTO_TEMPLATE
       (
	 .client_read_0			(client_rd_en_0),
	 .client_req_0			(client_wr_en_0 | client_rd_en_0),
	 .client_read_1			(client_rd_en_1),
	 .client_req_1			(client_wr_en_1 | client_rd_en_1),
       );
    */

    arb_rr_2 #(.W(W), .AW(AW)) u_arb2_0
        (/*autoinst*/);

    /* data_mem_mon AUTO_TEMPLATE
       (
       );
    */
    data_mem_mon #(.DM_AW(AW), .DM_DW(W)) u_mem_0 
        (/*autoinst*/);


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
// verilog-auto-inst-param-value :t 
// end:
