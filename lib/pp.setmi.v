% perl_include("pp_macros.pl");
% $fifo_depth=3 unless defined $fifo_depth;
% if (!defined $mod) {
%  $mod="setmi";
% ## $mod.="_fifo${fifo_depth}" if $fifo_depth > 0;
% }
% if ($fifo_depth > 0) {
%   $log2_fifo_depth = clog2($fifo_depth+1);
% }

module ${mod} #(parameter W=32, AW=W, TW=4) (
    input clk,
    input rst_n,

    input [W-1:0] uc_d0, // addr offset0
    input [W-1:0] uc_d1, // addr offset1
    input [W-1:0] uc_d2, // wdata
    input [W-1:0] uc_d3, // enable on any of {first, last, vld}
    input [3:0]   uc_mflags,
    output [1:0]  cu_sflags,

    // mem arbiter if outputs
    output [AW-1:0] client_addr, 
    output [W-1:0]  client_wdata, 
    output          client_wr_en,
    output          client_rd_en, // unused
    output [TW-1:0] client_tag, // unused
    // mem arbiter if inputs
    input           client_bsy
);

// from upstream
wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

// to upstream
assign  cu_sflags = {1'b0, req_fifo_full};

// thre is no dowstream (no dc_sflags, cd_mflags)


assign client_rd_en = 1'b0;
assign client_tag = {TW{1'b0}};

wire [W-1:0] wdata;
wire first, last;
wire [AW-1:0] addr;
wire [AW-1:0] comp_addr = uc_d0[AW-1:0] + uc_d1[AW-1:0];


wire req_fifo_empty, req_fifo_full;

// Q requests

wire ena = uc_vld & |({uc_first, uc_last, 1'b1} & uc_d3[2:0]);
wire trigger = ~req_fifo_empty;

wire req_fifo_wr = ena & ~uc_again & ~req_fifo_full;
wire req_fifo_re = trigger & ~client_bsy;

sync_fifo #(.W(2+AW+W), .AW(${log2_fifo_depth}), .SIZE(${fifo_depth})) u_sync_fifo_req (
   // Inputs
   .clk(clk), 
   .rst_n(rst_n), 
   .fifo_wdata({uc_first, uc_last, comp_addr, uc_d2}), 
   .fifo_wr(req_fifo_wr), 
   .fifo_re(req_fifo_re),
   // Outputs
   .fifo_rdata({first, last, addr, wdata}), 
   .fifo_empty(req_fifo_empty), 
   .fifo_full(req_fifo_full), 
   .fifo_afull(), 
   .fifo_aempty()
);


assign client_addr  = addr;
assign client_wdata = wdata;
assign client_wr_en = ~req_fifo_empty;

endmodule

% if ($fifo_depth > 0) {
// DEPENDENCIES: sync_fifo.v
% }
// PP_FILENAME="${mod}.v"
