% $n="2" unless defined $n;
% $mod="one_to_many$n" unless defined $mod;

module ${mod} (
    input clk,
    input rst_n,

    input  [2:0]  uc_mflags,
    output [1:0]  cu_sflags,

% for $i (0..$n-1) {
    input  [1:0]   dc_sflags${i},
% }
    output [2:0]   cd_mflags,
);

wire [${n}-1:0] dc_abt, dc_bsy;
% for $i (0..$n-1) {

assign dc_abt[${i}] = dc_sflags${i}[1];
assign dc_bsy[${i}] = dc_sflags${i}[0];
% }

// Flags going UP stream
wire cu_abt = |dc_abt;
wire cu_bsy = |dc_bsy;
assign cu_sflags = {cu_abt, cu_bsy};

wire    uc_first, uc_last, uc_vld;
assign {uc_first, uc_last, uc_vld} = uc_mflags;

// Flags going DOWN stream
// we assert valid down only if all of them are not busy
assign cd_mflags = {uc_first, uc_last, uc_vld & ~cu_bsy};


endmodule

// PP_FILENAME="${mod}.v"
