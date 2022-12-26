% $mod="reduce_template" unless defined $mod;
% $op="" unless defined $mod;

module ${mod}(/*autoarg*/);

parameter W=32;

input clk;
input rst_n;

input [W-1:0]   uc_d0;
input [3:0]     uc_mflags;
output [1:0]    cu_sflags;

output [W-1:0]  cd_d0;
output [3:0]    cd_mflags;
input  [1:0]    dc_sflags;

wire            uc_again, uc_first, uc_last, uc_vld;
assign         {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

// unpack dc_sflags
wire            dc_abt, dc_bsy;
assign         {dc_abt, dc_bsy} = dc_sflags;

wire cd_again = dc_bsy;
reg cd_first, cd_vld;
wire cd_last = 1'b0;

// pack cd_mflags
assign          cd_mflags = {cd_again, cd_first, cd_last, cd_vld};

// to upstream
assign   cu_sflags = dc_sflags;


reg [W-1:0] cumm_nxt, cumm;
reg [1:0]   state_nxt, state;
reg cd_first_nxt;

parameter ST_IDLE=0, ST_MID=1, ST_LAST=2;

always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
      state <= ST_IDLE;
      cumm <= {W{1'b0}};
      cd_first <= 1'b0;
   end
   else begin
      state <= state_nxt;
      cumm <= cumm_nxt;
      cd_first <= cd_first_nxt;
   end
end

always @* begin
   cd_vld = 1'b0;
   state_nxt = state;
   cumm_nxt = cumm;
   cd_first_nxt = 1'b0;
   case (state) 
      ST_IDLE: begin
         if (uc_vld & ~uc_again & ~dc_bsy) begin
            if (uc_first) begin
               state_nxt = ST_MID;
               cumm_nxt = uc_d0;
               cd_first_nxt = 1;
            end
         end
      end
      ST_MID: begin
         if (uc_vld & ~uc_again & ~dc_bsy) begin
            cumm_nxt = cumm ${op} uc_d0;
            if (uc_last) begin
               state_nxt = ST_LAST;
            end
         end
      end
      ST_LAST: begin
         cd_vld = 1'b1;
         if (~dc_bsy) begin
            if (uc_vld & ~uc_again & uc_first) begin
               state_nxt = ST_MID;
               cumm_nxt = uc_d0;
               cd_first_nxt = 1;
            end
            else 
               state_nxt = ST_IDLE;
         end
      end
   endcase
end

// to downstream
assign   cd_d0 = cumm;

endmodule

// PP_FILENAME="${mod}.v"
