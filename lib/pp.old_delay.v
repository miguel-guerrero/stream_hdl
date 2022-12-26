
module delay(/*autoarg*/);

parameter W=32;

input clk;
input rst_n;

input  [W-1:0] uc_d0;
input  [3:0]   uc_mflags;
output [1:0]   cu_sflags;

output [W-1:0] cd_d0;
output [3:0]   cd_mflags;
input  [1:0]   dc_sflags;

// to upstream
assign   cu_sflags = dc_sflags;

// to downstream

wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;


reg  cd_again, cd_first, cd_last, cd_vld;
reg [W-1:0]  cd_d0;

always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
      {cd_again, cd_vld, cd_first, cd_last} <= 4'b0;
      cd_d0 <= {W{1'b0}};
   end
   else begin
      if (uc_vld & ~uc_again & ~dc_bsy) begin
         {cd_again, cd_first, cd_last, cd_vld} <= {uc_again, uc_first, uc_last, uc_vld};
         cd_d0 <= uc_d0;
      end
   end
end

assign cd_mflags = {cd_again, cd_first, cd_last, cd_vld};

endmodule
