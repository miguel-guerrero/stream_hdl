% $n="1" unless defined $n;
% $mod="converge_flags$n" unless defined $mod;

module ${mod} (
    input clk,
    input rst_n,

% for $i (0..$n-1) {
    input [2:0]   uc_mflags${i},
% }
    output [1:0]  cu_sflags,

    output [2:0]   cd_mflags,
    input  [1:0]   dc_sflags
);

wire cd_vld;

wire [${n}-1:0] uc_vld, uc_first, uc_last;
% for $i (0..$n-1) {

assign uc_first[${i}] = uc_mflags${i}[2];
assign uc_last[${i}]  = uc_mflags${i}[1];
assign uc_vld[${i}]   = uc_mflags${i}[0];
% }

assign cd_first = &uc_first;
assign cd_last  = &uc_last;
assign cd_vld   = &uc_vld;
assign cd_mflags = {cd_first, cd_last, cd_vld};


wire cu_abt = dc_sflags[1];
wire cu_bsy = dc_sflags[0] | ~cd_vld ;
assign cu_sflags = {cu_abt, cu_bsy};

endmodule

// PP_FILENAME="${mod}.v"
