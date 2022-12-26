module data_mem_mon(/*autoarg*/
   // Outputs
   mem_rdata, mem_rdata_vld,
   // Inputs
   clk, rst_n, mem_addr, mem_wdata, mem_wr_en, mem_rd_en
   );

parameter DM_AW = 10;
parameter DM_DW = 32;
parameter RAM_DEPTH = 1 << DM_AW;
parameter BANK_SIZE = RAM_DEPTH >> 2;

input                                   clk;
input                                   rst_n;
input  [DM_AW-1:0]                      mem_addr;
input  [DM_DW-1:0]                      mem_wdata;
input                                   mem_wr_en;
input                                   mem_rd_en;
output [DM_DW-1:0]                      mem_rdata;
output                                  mem_rdata_vld;

reg  [DM_DW -1:0]                       mem_rdata_1;
reg                                     mem_rdata_vld_1;

  wire [DM_DW-1:0] mem_rdata_0;

  ram_bank #(DM_DW, DM_AW, BANK_SIZE) u_ram_bank_0 (
    .clk  (clk), 
    .we   (mem_wr_en), 
    .d    (mem_wdata), 
    .addr (mem_addr), 
    .q    (mem_rdata_0)
  );

  wire mem_read = mem_rd_en & ~mem_wr_en;

  reg mem_read_1;
  always @(posedge clk) begin
     mem_read_1 <= mem_read;
  end

  always @(/*AS*/mem_rdata_0 or mem_read_1) begin
     mem_rdata_1     = {DM_DW{1'b0}};
     mem_rdata_vld_1 = 1'b0;
     if (mem_read_1) begin
         mem_rdata_1     = mem_rdata_0;
         mem_rdata_vld_1 = 1'b1;
     end
  end


  assign mem_rdata     = mem_rdata_1;
  assign mem_rdata_vld = mem_rdata_vld_1;

  // synopsys translate_off
  wire mem_addr_in_range = (mem_addr <= RAM_DEPTH);

  always @(posedge clk) begin : write
     if (mem_wr_en==1'b1) begin
        if (mem_addr_in_range) begin
           $display($time, " MEM: writting addr=%x wdata=%x %m", mem_addr, mem_wdata);
        end
     end
  end

  always @(posedge clk) begin : addr_range_check
     if (mem_wr_en == 1'b1 || mem_rd_en==1'b1) begin
        if (~mem_addr_in_range) begin
           $display($time, " MEM: ERROR: access to addr=%x hits no physical memory %m", mem_addr);
           //$finish;
        end
     end
  end

  reg  [DM_AW-1:0] mem_addr_q;
  always @(posedge clk) begin
     if (mem_rdata_vld) begin
        if (mem_addr_q < RAM_DEPTH) begin
           $display($time, " MEM: reading  addr=%x rdata=%x %m", mem_addr_q, mem_rdata);
        end
     end
     mem_addr_q <= mem_addr;
  end
  // synopsys translate_on

endmodule // data_mem
