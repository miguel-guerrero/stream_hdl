// Single Clock domain fifo

//`define SYNC_FIFO_DEBUG

module sync_fifo 
  (/*autoarg*/
   // Outputs
   fifo_rdata, fifo_full, fifo_empty, fifo_afull, fifo_aempty,
   // Inputs
   clk, rst_n, fifo_wdata, fifo_wr, fifo_re
   );

   parameter W=32;
   parameter AW=5;
   parameter SIZE = 1<<AW;
   parameter AF_THR=1; //Almost Full
   parameter AE_THR=1; //Almost Empty

   input          clk;
   input          rst_n;
   input [W-1:0]  fifo_wdata;
   input          fifo_wr;
   input          fifo_re;

   output [W-1:0] fifo_rdata;
   output         fifo_full; 
   output         fifo_empty;
   output         fifo_afull;
   output         fifo_aempty;

   reg  [AW-1:0]  write_ptr;
   wire [AW-1:0]  wr_ptr_pl1;
   reg  [AW-1:0]  read_ptr;
   wire [AW-1:0]  rd_ptr_pl1;
   wire [W-1:0]   fifo_rdata;
   wire           fifo_full, fifo_aempty, fifo_empty;
   reg  [AW:0]    level;
   reg  [W-1:0]   mem[SIZE-1:0];

   wire fifo_wr0 = fifo_wr & ~fifo_full;
   wire fifo_re0 = fifo_re & ~fifo_empty;

   // Memory Block
   always @(posedge clk) begin
      if (fifo_wr0) begin
         mem[write_ptr] <= fifo_wdata;
      end
   end

   assign fifo_rdata  = mem[read_ptr];
      
   // Read/Write Pointers Logic
   always @(posedge clk  or negedge rst_n) begin
      if (~rst_n) 
        write_ptr <=  {AW{1'b0}};
      else if (fifo_wr0)      
        write_ptr <=  wr_ptr_pl1;
   end

   assign wr_ptr_pl1 = (write_ptr == SIZE -1) ? 0 : write_ptr + 1'b1;

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) 
        read_ptr <=  {AW{1'b0}};
      else if (fifo_re0)      
        read_ptr <=  rd_ptr_pl1;
   end

   assign rd_ptr_pl1 = (read_ptr == SIZE - 1) ? 0 : read_ptr +  1'b1;

   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         level <= {AW+1{1'b0}};
      end
      else begin
         if (fifo_wr0 & !fifo_re0) begin
            level <= level +1;
         end
         else if (!fifo_wr0 & fifo_re0) begin
            level <= level -1;
         end
      end
   end
   
   assign fifo_empty  = (level == 0);
   assign fifo_full   = (level == SIZE);
   assign fifo_aempty = (level <= AE_THR);
   assign fifo_afull  = (level >= SIZE - AF_THR);

   // synopsys translate_off
   reg fifo_error;
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         fifo_error <= 1'b0;
      end
      else begin
         if (fifo_wr & fifo_full) begin
            fifo_error <= 1'b1;
            $display($time, " ERROR: attempting to write while fifo is FULL %m");
            repeat (2) @(posedge clk);
            $finish;
         end
         if (fifo_re & fifo_empty) begin
            fifo_error <= 1'b1;
            $display($time, " ERROR: attempting to read while fifo is EMPTY %m");
            repeat (2) @(posedge clk);
            $finish;
         end
      end
   end

`ifdef SYNC_FIFO_DEBUG
   always @(posedge clk) begin
      if (rst_n == 1) begin
         if (fifo_wr0)
            $display($time, " FIFO_WR: data=%x LEVEL=%d %m", fifo_wdata, level);
         if (fifo_re0)
            $display($time, " FIFO_RD: data=%x LEVEL=%d %m", fifo_rdata, level);
      end
   end
`endif
   // synopsys translate_on

endmodule
