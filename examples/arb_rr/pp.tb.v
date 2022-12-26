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

    /* gen_seq AUTO_TEMPLATE
        (
            .cd_d0(x[]),
            .cd_mflags(x_mflags[]),
        );
     */
     gen_seq #(.W(W)) u_x (
        .clk, .rst_n,
        .cnt_ini(16'd1), .cnt_max(16'd15), .cnt_inc(16'd1),

        // inputs from UP
        .uc_d0(16'b0),
        .uc_mflags(4'b0101), // AFLV

        // outputs UP
        .cu_sflags(),

        // inputs from DOWN
        .dc_sflags({1'b0, client_bsy_0}),

        /*autoinst*/
     );

    /* gen_seq AUTO_TEMPLATE
        (
            .cd_d0(y[]),
            .cd_mflags(y_mflags[]),
        );
     */
     gen_seq #(.W(W)) u_y (
        .clk, .rst_n,
        .cnt_ini(16'd33), .cnt_max(16'd47), .cnt_inc(16'd1),

        // inputs from UP
        .uc_d0(16'b0),
        .uc_mflags(4'b0101), // AFLV

        // outputs UP
        .cu_sflags(),

        // inputs from DOWN
        .dc_sflags({1'b0, client_bsy_1}),

        /*autoinst*/
     );

    /* arb_rr_2 AUTO_TEMPLATE
       (
	 .client_req_0			(x_mflags[0] & ~tb_bsy),
	 .client_addr_0			(x[]),
	 .client_read_0			(1'b0),
	 .client_wdata_0		(x[]),
	 .client_tag_0		        ({TW{1'b0}}),

	 .client_req_1			(y_mflags[0]),
	 .client_addr_1			(y[]),
	 .client_read_1			(1'b0),
	 .client_wdata_1		(y[]),
	 .client_tag_1		        ({TW{1'b0}}),
       );
    */

    arb_rr_2 #(.W(W), .AW(AW)) u_arb_2 
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
