% perl_include("pp_macros.pl");
% $fifo_depth=2 unless defined $fifo_depth;
% if (!defined $mod) {
%  $mod="buffer";
%  $mod.="_fifo${fifo_depth}" if $fifo_depth > 0;
% }
% if ($fifo_depth > 0) {
%   $log2_fifo_depth = clog2($fifo_depth);
% }

module ${mod} #(parameter W=32) (
    input clk,
    input rst_n,

    input [W-1:0] uc_d0,
    input [3:0]   uc_mflags,
    output [1:0]  cu_sflags,

    output [W-1:0] cd_d0,
    output [3:0]   cd_mflags,
    input  [1:0]   dc_sflags
);

wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;

wire    uc_again, uc_first, uc_last, uc_vld; 
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

wire fifo_wr, fifo_full, fifo_empty;
wire fifo_first, fifo_last;

wire cd_vld = ~fifo_empty;
wire fifo_re = cd_vld & ~dc_bsy;


assign fifo_wr = uc_vld & ~uc_again & ~fifo_full;

sync_fifo #(.W(2+W), .AW(${log2_fifo_depth}), .SIZE(${fifo_depth})) u_sync_fifo_${i} (
   // Inputs
   .clk(clk), 
   .rst_n(rst_n), 
   .fifo_wdata({uc_first, uc_last, uc_d0}), 
   .fifo_wr(fifo_wr), 
   .fifo_re(fifo_re),

   // Outputs
   .fifo_rdata({fifo_first, fifo_last, cd_d0}), 
   .fifo_full(fifo_full), 
   .fifo_empty(fifo_empty), 
   .fifo_afull(), 
   .fifo_aempty()
);

wire cd_again    = dc_bsy;
wire cd_first    = fifo_first & cd_vld;
wire cd_last     = fifo_last  & cd_vld;
assign cd_mflags = {cd_again, cd_first, cd_last, cd_vld};

assign cu_sflags = {1'b0, fifo_full};

endmodule

% if ($fifo_depth > 0) {
// DEPENDENCIES: sync_fifo.v
% }
// PP_FILENAME="${mod}.v"
