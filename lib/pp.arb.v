% $n=3 unless defined $n;
% $rr=1 unless defined $rr;
% if (!defined $mod) {
%  $mod="arb";
%  $mod.="_rr" if $rr;
%  $mod.="_${n}";
% }
% $mem_has_rvld=1 unless defined $mem_has_rvld;

% if ($rr) {
// RR arbiter. client 0 initially has higher priority, then it rotates
% } else {
// Strict Priority arbiter. Client 0 has highest priority
% }

module ${mod} #(parameter W=32, AW=W, TW=4) (
    input clk,
    input rst_n,

% for $i (0..$n-1) {

    // request interface client ${i}
    input          client_req_${i},
    input [AW-1:0] client_addr_${i},
    input [TW-1:0] client_tag_${i},
    input          client_read_${i},
    input [W-1:0]  client_wdata_${i},
    // request response
    output         client_bsy_${i},
    // read response interface
    output         client_rdata_vld_${i},

% }

    // data from memory to requesters
    output [W-1:0]      client_rdata,
    output [TW-1:0]     client_rtag,

    // mem i/f
    output reg [AW-1:0] mem_addr,
    output reg          mem_rd_en,
    output reg          mem_wr_en,
    output reg [W-1:0]  mem_wdata,
% if ($mem_has_rvld) {
    input               mem_rdata_vld,
% }
    input      [W-1:0]  mem_rdata
);

parameter NUM_REQS=${n};

function [NUM_REQS-1:0] pri_encode;
    input [NUM_REQS-1:0] r;
    reg [NUM_REQS-1:0] mask;
    integer i;
    begin
        pri_encode = {NUM_REQS{1'b0}};
        mask = {1'b1, {NUM_REQS-1{1'b0}}};
        for (i=NUM_REQS-1; i>=0; i=i-1) begin
            if (|(r & mask)) 
                pri_encode = mask;
            mask = mask >> 1'b1;
        end
    end
endfunction


wire [NUM_REQS-1:0] reqs, gnt;

assign reqs = {
% for (my $i=$n-1; $i>=1; $i--) {
                client_req_${i},
% }
                client_req_0
            };

% if ($rr) {

// RR arbitration
reg  [NUM_REQS-1:0] last_gnt;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
        last_gnt <= {1'b0, {NUM_REQS-1{1'b0}}};
    else 
        last_gnt <= gnt;
end

wire [NUM_REQS-1:0] low_mask, req_up, req_dn;

assign low_mask = last_gnt | (last_gnt-1'b1);
assign req_dn   = reqs &  low_mask;
assign req_up   = reqs & ~low_mask;

assign gnt      = |req_up ? pri_encode(req_up) : pri_encode(req_dn);
% } else {

// Priority arbitration

assign gnt     = pri_encode(reqs);
% }
wire any_req   = |reqs;

reg [AW-1:0]       i_client_addr;
reg [W-1:0]        i_client_wdata;
reg                i_client_rd;
reg                i_client_wr;
reg [TW-1:0]       i_client_tag;

always @* begin
    i_client_addr  = {AW{1'b0}};
    i_client_wdata = {W{1'b0}};
    i_client_rd    = 1'b0;
    i_client_wr    = 1'b0;
    i_client_tag   = {TW{1'b0}};
    case (1'b1) // synopsys parallel_case
% for $i (0..$n-1) {
        gnt[${i}] : begin
            i_client_addr  = client_addr_${i};
            i_client_wdata = client_wdata_${i};
            i_client_rd    = any_req &  client_read_${i};
            i_client_wr    = any_req & ~client_read_${i};
            i_client_tag   = client_tag_${i};
        end
% }
    endcase
end

// mem if outputs

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mem_rd_en <= 1'b0;
        mem_wr_en <= 1'b0;
    end
    else begin
        mem_rd_en <= i_client_rd;
        mem_wr_en <= i_client_wr;
    end
end

always @(posedge clk) begin
    mem_addr  <= any_req     ? i_client_addr  : mem_addr;  // to save toggles
    mem_wdata <= i_client_wr ? i_client_wdata : mem_wdata; // to save toggles
end


// client outputs

wire [TW+NUM_REQS-1:0] rd_control, rd_control_from_fifo;
assign rd_control = {i_client_tag, gnt};



% if ($mem_has_rvld) {
wire i_rdata_vld = mem_rdata_vld;
% } else {
// self generate data vld after 1 clk of request
reg i_rdata_vld;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
        i_rdata_vld <= 1'b0;
    else 
        i_rdata_vld <= mem_rd_en; // data comes back one clk after rd request
end
% }

sync_fifo #(.W(TW+NUM_REQS), .AW(2), .SIZE(3)) sync_fifo_0 (
    // Inputs
    .clk(clk), 
    .rst_n(rst_n), 
    .fifo_wdata(rd_control), 
    .fifo_wr(i_client_rd), 
    .fifo_re(i_rdata_vld),

   // Outputs
   .fifo_rdata(rd_control_from_fifo), 
   .fifo_full(), 
   .fifo_empty(), 
   .fifo_afull(), 
   .fifo_aempty()
  );

wire [NUM_REQS-1:0] client_rd_gnt;
assign client_rdata = mem_rdata;
assign {client_rtag, client_rd_gnt} = rd_control_from_fifo;

% for $i (0..$n-1) {
assign client_rdata_vld_${i} = i_rdata_vld & client_rd_gnt[${i}];
% }

% for $i (0..$n-1) {
assign client_bsy_${i} = ~(any_req & gnt[${i}]);
% }

endmodule
// DEPENDENCIES: sync_fifo.v
// PP_FILENAME="${mod}.v"
