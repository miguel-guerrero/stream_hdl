% perl_include("pp_macros.pl");
% $fifo_depth=2 unless defined $fifo_depth;
% $n=2 unless defined $n;
% if (!defined $mod) {
%  $mod="wait_for_all";
%  $mod.="_fifo${fifo_depth}" if $fifo_depth > 0;
%  $mod.="_${n}";
% }
% if ($fifo_depth > 0) {
%   $log2_fifo_depth = clog2($fifo_depth);
% }

module  #(parameter W=32) (
    input clk,
    input rst_n,

% for $i (0..$n-1) {
    input [W-1:0] uc_d,
    input [3:0]   uc_mflags,
    output [1:0]  cu_sflags,

% }
% for $i (0..$n-1) {
    output [W-1:0] cd_d,
% }
    output [3:0]   cd_mflags,
    input  [1:0]   dc_sflags
);

wire dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;


wire [2-1:0] fifo_wr, fifo_full, fifo_empty;
wire [2-1:0] uc_again, uc_first, uc_last, uc_vld, cd_first, cd_last;

% for $i (0..$n-1) {
assign {uc_again[], uc_first[], uc_last[], uc_vld[]} = uc_mflags;
% }

wire any_empty = |fifo_empty;
wire all_vld = ~any_empty;
wire fifo_re = all_vld & ~dc_bsy;

% for $i (0..$n-1) {
    assign fifo_wr[] = uc_vld[] & ~uc_again[] & ~fifo_full[];
    assign cu_sflags = {1'b0, fifo_full[]};

    sync_fifo #(.W(2+W), .AW(), .SIZE(2)) u_sync_fifo_ (
       // Inputs
       .clk(clk), 
       .rst_n(rst_n), 
       .fifo_wdata({uc_first[], uc_last[], uc_d}), 
       .fifo_wr(fifo_wr[]), 
       .fifo_re(fifo_re),

       // Outputs
       .fifo_rdata({cd_first[], cd_last[], cd_d}), 
       .fifo_full(fifo_full[]), 
       .fifo_empty(fifo_empty[]), 
       .fifo_afull(), 
       .fifo_aempty()
    );

% }


    assign cd_mflags = {1'b0, cd_first[0] & all_vld, cd_last[0] & all_vld, all_vld};

endmodule

% if ($fifo_depth > 0) {
// DEPENDENCIES: sync_fifo.v
% }
// PP_FILENAME="${mod}.v"
