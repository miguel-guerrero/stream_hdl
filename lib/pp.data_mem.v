% $D=1                if !defined($D);
% $WORD_LSB=2         if !defined($WORD_LSB);
% $DM_DW=8<<$WORD_LSB if !defined($DM_DW);
% $MONITORS=0         if !defined($MONITORS);

% if (!defined $mod) {
%  $mod = "data_mem";
%  $mod .= "_mon" if $MONITORS;
% }

module ${mod}(/*autoarg*/);

parameter DM_AW = 10;
parameter DM_DW = 32;
parameter RAM_DEPTH = 1 << DM_AW;
parameter BANK_SIZE = RAM_DEPTH >> ${WORD_LSB};

input                                   clk;
input                                   rst_n;
input  [DM_AW-1:0]                      mem_addr;
input  [DM_DW-1:0]                      mem_wdata;
input                                   mem_wr_en;
input                                   mem_rd_en;
output [DM_DW-1:0]                      mem_rdata;
output                                  mem_rdata_vld;

% for my $i (1 .. $D) {
reg  [DM_DW -1:0]                       mem_rdata_${i};
reg                                     mem_rdata_vld_${i};
% }

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

  always @(/*AS*/) begin
     mem_rdata_1     = {DM_DW{1'b0}};
     mem_rdata_vld_1 = 1'b0;
     if (mem_read_1) begin
         mem_rdata_1     = mem_rdata_0;
         mem_rdata_vld_1 = 1'b1;
     end
  end

% for my $n (2 .. $D) { 
%  my $p = $n - 1;

  always @(posedge clk) begin
     mem_rdata_${n} <= mem_rdata_${p};
  end

  always @(posedge clk or negedge rst_n) begin
     if (~rst_n)
        mem_rdata_vld_${n} <= 1'b0;
     else 
        mem_rdata_vld_${n} <= mem_rdata_vld_${p};
  end

% }

  assign mem_rdata     = mem_rdata_${D};
  assign mem_rdata_vld = mem_rdata_vld_${D};

% if ($MONITORS) {
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
% }

endmodule // data_mem

// PP_FILENAME="${mod}.v"
