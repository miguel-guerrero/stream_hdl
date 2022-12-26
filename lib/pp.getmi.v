% perl_include("pp_macros.pl");
% $fifo_depth=2 unless defined $fifo_depth;
% if (!defined $mod) {
%  $mod="getmi";
% ## $mod.="_fifo${fifo_depth}" if $fifo_depth > 0;
% }
% if ($fifo_depth > 0) {
%   $log2_fifo_depth = clog2($fifo_depth);
% }

module ${mod} #(parameter W=32, AW=W, TW=4) (
    input clk,
    input rst_n,

    input [W-1:0] uc_d0, // addr offset0
    input [W-1:0] uc_d1, // addr offset1
    input [W-1:0] uc_d2, // enable on any of {first, last, vld}
    input [3:0]   uc_mflags,
    output [1:0]  cu_sflags,

    output     [W-1:0] cd_d0,
    output     [3:0]   cd_mflags,
    input      [1:0]   dc_sflags,

    // mem arbiter if outputs
    output [AW-1:0] client_addr, 
    output [W-1:0]  client_wdata, // unused
    output          client_wr_en, // unused
    output          client_rd_en,
    output [TW-1:0] client_tag,

    // mem arbiter if inputs
    input           client_bsy,
    input [W-1:0]   client_rdata, 
    input [TW-1:0]  client_rtag,
    input           client_rdata_vld
);

// from upsetream
wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

// from downstream
wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;

wire first, last;
wire [AW-1:0] addr;
wire [AW-1:0] comp_addr  = uc_d0[AW-1:0] + uc_d1[AW-1:0];


wire req_fifo_empty, req_fifo_full;

// to upstream
assign cu_sflags = {1'b0, req_fifo_full};

// Q requests

wire ena = uc_vld & |({uc_first, uc_last, 1'b1} & uc_d2[2:0]);
wire trigger = ~req_fifo_empty & ~resp_fifo_full;

wire req_fifo_wr  = ena & ~uc_again & ~req_fifo_full;
wire req_fifo_re  = trigger & ~client_bsy;

sync_fifo #(.W(2+AW), .AW(${log2_fifo_depth}), .SIZE(${fifo_depth})) u_sync_fifo_req (
   // Inputs
   .clk(clk), 
   .rst_n(rst_n), 
   .fifo_wdata({uc_first, uc_last, comp_addr}), 
   .fifo_wr(req_fifo_wr), 
   .fifo_re(req_fifo_re),
   // Outputs
   .fifo_rdata({first, last, addr}), 
   .fifo_empty(req_fifo_empty), 
   .fifo_full(req_fifo_full), 
   .fifo_afull(), 
   .fifo_aempty()
);

// to downstream

wire cd_abt   = 1'b0;
wire cd_first, cd_last, cd_vld;

// Q responses
wire resp_fifo_empty;
assign cd_vld = ~resp_fifo_empty;
wire resp_fifo_wr = client_rdata_vld;
wire resp_fifo_re = cd_vld & ~dc_bsy;
wire resp_fifo_first, resp_fifo_last;

sync_fifo #(.W(2+W), .AW(${log2_fifo_depth}), .SIZE(${fifo_depth})) u_sync_fifo_resp (
   // Inputs
   .clk(clk), 
   .rst_n(rst_n), 
   .fifo_wdata({client_rtag[1:0], client_rdata}), 
   .fifo_wr(resp_fifo_wr), 
   .fifo_re(resp_fifo_re),
   // Outputs
   .fifo_rdata({resp_fifo_first, resp_fifo_last, cd_d0}), 
   .fifo_empty(resp_fifo_empty), 
   .fifo_full(resp_fifo_full), 
   .fifo_afull(), 
   .fifo_aempty()
);

assign cd_first = resp_fifo_first & cd_vld;
assign cd_last  = resp_fifo_last  & cd_vld;

// if resp fifo is empty make flags 4'b0000
assign cd_mflags = {cd_abt, cd_first, cd_last, cd_vld};

// client interface

assign client_addr  = addr;
assign client_wdata = {W{1'b0}}; // unused
assign client_wr_en = 1'b0; // unused
assign client_rd_en = trigger;
assign client_tag   = {{TW-2{1'b0}}, first, last};

endmodule

% if ($fifo_depth > 0) {
// DEPENDENCIES: sync_fifo.v
% }
// PP_FILENAME="${mod}.v"
