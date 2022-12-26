% $n=1 unless defined $n;
% $o=$n+1;
% $mod="delay${n}x${o}";

module ${mod}(/*autoarg*/);

parameter W=32;

input clk;
input rst_n;

input  [W-1:0] uc_d0;
input  [3:0]   uc_mflags;
output [1:0]   cu_sflags;

% for $i (0..$n) {
output [W-1:0] cd_d${i};
% }
output [3:0]   cd_mflags;
input  [1:0]   dc_sflags;

% for $i (0..$n) {
reg [W-1:0] cd_d${i};
reg [3:0]   cd_mflags${i};
% }

// to upstream
assign   cu_sflags = dc_sflags;

// to downstream

wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;

reg  cd_first, cd_last, cd_vld;


always @* begin
   cd_d0 = uc_d0;
   cd_mflags0 = uc_mflags;
end

always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
% for $i (1..$n) { 
      cd_mflags${i} <= 4'b0;
      cd_d${i}      <= {W{1'b0}};
% }
   end
   else begin
      if (uc_vld & ~uc_again & ~dc_bsy) begin
% for $i (1..$n) { 
%  $im1=$i-1;
         cd_mflags${i} <= cd_mflags${im1};
         cd_d${i}      <= cd_d${im1};
% }
      end
   end
end

assign cd_mflags = cd_mflags${n};

endmodule

// PP_FILENAME="${mod}.v"
