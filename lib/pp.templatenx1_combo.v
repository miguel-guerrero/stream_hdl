% $n=2 unless defined $n;
% $mod="stream_binnop" unless defined $mod;
% $op="" unless defined $op;

module ${mod}(/*autoarg*/);

parameter W=32;

input clk;
input rst_n;

% for $i (0..$n-1) {
input  [W-1:0] uc_d${i};
% }
input  [3:0]   uc_mflags;
output [1:0]   cu_sflags;

output [W-1:0] cd_d0;
output [3:0]   cd_mflags;
input  [1:0]   dc_sflags;

// to upstream
assign   cu_sflags = dc_sflags;

% for $i (0..$n-1) {
wire [W-1:0] x${i}=uc_d${i};
% }

assign  cd_d0 = ${op};
assign  cd_mflags = uc_mflags;

endmodule

// PP_FILENAME="${mod}.v"
