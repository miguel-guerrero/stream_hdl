module tb;

   parameter W=16;
   parameter AW=10;
   parameter TW=4;
   parameter DM_DW=W;
   parameter DM_AW=10;

   reg tb_bsy;
   /*autowire*/

   reg clk;
   initial begin
      clk <= 0;
      forever 
         #5 clk <= ~clk;
   end

   reg rst_n;
   reg start;
   initial begin
      start <= 1'b0;
      rst_n <= 1'b0;
      repeat(5)
         @(posedge clk);
      rst_n <= 1'b1;

      repeat(2)
         @(posedge clk);
      start <= 1'b1;
      repeat(1)
         @(posedge clk);
      start <= 1'b0;

      repeat(2000)
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

   /* matrix AUTO_TEMPLATE (
       .ROWS(16'd5), 
       .COLS(16'd5), 
       .STRIDE(16'd5), 
       .X(16'd32), 
       .Y(16'd64), 
       .A(16'd0), 
       .mem_\(.*\)(mem_\1[]), 
   ); */
   matrix #(.W(W), .AW(AW), .TW(TW)) u_matrix 
        (/*autoinst*/);


    /* data_mem_mon AUTO_TEMPLATE (
       ); */
    data_mem_mon #(.DM_AW(AW), .DM_DW(W)) u_mem_0 
        (/*autoinst*/);

    initial begin : init_ram
        integer i;
        for (i=0; i<5*5; i=i+1) begin
            u_mem_0.u_ram_bank_0.mem[i] = (i / 5);
        end
        for (i=32; i<32+5; i=i+1) begin
            u_mem_0.u_ram_bank_0.mem[i] = i-31;
        end
    end

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
