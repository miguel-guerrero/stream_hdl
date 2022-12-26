% $n=2 unless defined $n;
% $mod="template${n}x1" unless defined $mod;
% $op="" unless defined $op;

module ${mod} #(parameter W=32) (
    input clk,
    input rst_n,

% for $i (0..$n-1) {
    input [W-1:0] uc_d${i},
% }
    input [3:0]   uc_mflags,
    output [1:0]  cu_sflags,

    output reg [W-1:0] cd_d0,
    output reg [3:0]   cd_mflags,
    input      [1:0]   dc_sflags
);

// to upstream
assign   cu_sflags = dc_sflags;

% for $i (0..$n-1) {
wire [W-1:0] x${i}=uc_d${i};
% }

wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;

always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
      cd_mflags <= 4'b0;
      cd_d0     <= {W{1'b0}};
   end
   else begin
      if (uc_vld & ~uc_again & ~dc_bsy) begin
         cd_d0     <= ${op};
      end
      cd_mflags <= uc_mflags;
   end
end

endmodule

// PP_FILENAME="${mod}.v"
