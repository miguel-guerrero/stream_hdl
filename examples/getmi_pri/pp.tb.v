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

    /* gen_seq AUTO_TEMPLATE (
            .cd_d0(x0[]),
            .cd_mflags(x0_mflags[]),
            .dc_sflags(setmi_0_sflags[]),
        ); */

     gen_seq #(.W(W)) u_x0 (
        .clk, .rst_n,
        .cnt_ini(16'd1), .cnt_max(16'd15), .cnt_inc(16'd1),

        // inputs from UP
        .uc_d0(16'b0),
        .uc_mflags(4'b0101), // AFLV

        // outputs UP
        .cu_sflags(),

        /*autoinst*/
     );

    /* gen_seq AUTO_TEMPLATE (
            .cd_d0(y0[]),
            .cd_mflags(y0_mflags[]),
            .dc_sflags(getmi_0_sflags[]),
        ); */

     gen_seq #(.W(W)) u_y0 (
        .clk, .rst_n,
        .cnt_ini(16'd1), .cnt_max(16'd15), .cnt_inc(16'd1),

        // inputs from UP
        .uc_d0(16'b0),
        .uc_mflags(4'b0101), // AFLV

        // outputs UP
        .cu_sflags(),

        /*autoinst*/
     );

    /* setmi AUTO_TEMPLATE
    (
        .uc_d0(x0[]), // addr offset0
        .uc_d1(16'd0), // addr offset1
        .uc_d2(x0[]), // wdata
        .uc_d3({13'b0, 1'b0, 1'b0, x0_mflags[0]}), // enable
        .uc_mflags(x0_mflags[] & {3'b111, ~hold_0}),
        .cu_sflags(setmi_0_sflags[]),

        // mem arbiter if outputs
        .client_\(.*\) (client_\1_0[]),
    );
    */
    setmi #(.W(W), .AW(AW))  u_setmi_0
        (/*autoinst*/);

    /* getmi AUTO_TEMPLATE
    (
        .uc_d0(y0[]), // addr offset0
        .uc_d1(16'd0),   // addr offset1
        .uc_d2({15'b0, 1'b1}), // enable FLV
        .uc_mflags(y0_mflags[]),
        .cu_sflags(getmi_0_sflags[]),
        .dc_sflags(2'b00),

        // mem arbiter if outputs
        .client_rdata (client_rdata[]),
        .client_rtag  (client_rtag[]),
        .client_\(.*\) (client_\1_1[]),
    );
    */
    getmi #(.W(W), .AW(AW))  u_getmi_0
        (/*autoinst*/);

    /* arb_2 AUTO_TEMPLATE
       (
	 .client_read_0			(client_rd_en_0),
	 .client_req_0			(client_wr_en_0 | client_rd_en_0),
	 .client_read_1			(client_rd_en_1),
	 .client_req_1			(client_wr_en_1 | client_rd_en_1),
       );
    */

    arb_2 #(.W(W), .AW(AW)) u_arb2_0
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
