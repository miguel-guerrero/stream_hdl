module dup(/*autoarg*/);

parameter W=32;

input clk;
input rst_n;
input [W-1:0]   N;

wire [W-1:0]   cnt_ini={{W-1{1'b0}}, 1'b1};


input [W-1:0]    uc_d0;
input [3:0]      uc_mflags;
output [1:0]     cu_sflags;

output [W-1:0]   cd_d0;
output [3:0]     cd_mflags;
input  [1:0]     dc_sflags;

// unpack upstream master flags
wire    uc_again, uc_first, uc_last, uc_vld;
assign {uc_again, uc_first, uc_last, uc_vld} = uc_mflags;

// unpack dowstream slave flags
wire    dc_abt, dc_bsy;
assign {dc_abt, dc_bsy} = dc_sflags;

// pack dowstream master flags
reg cd_first;
reg cd_last;
reg cd_vld;

wire cd_again = dc_bsy;

assign cd_mflags={cd_again, cd_first, cd_last, cd_vld};

// pack upstream slave flags
reg    cu_bsy;
wire   cu_abt;

assign cu_abt = dc_abt;
assign cu_sflags = {cu_abt, cu_bsy};

// to upstream

reg [W-1:0] cnt_nxt, cnt;
wire [W-1:0] cnt_p1;

assign cnt_p1 = cnt + 1'b1;

reg [1:0]   state_nxt, state;

parameter ST_IDLE=0, ST_FIRST=1, ST_MID=3, ST_LAST=2;

always @(posedge clk or negedge rst_n) begin
   if (~rst_n) begin
      state <= ST_IDLE;
      cnt   <= cnt_ini;
   end
   else begin
      state <= state_nxt;
      cnt   <= cnt_nxt;
   end
end

always @* begin
   state_nxt = state;
   cnt_nxt = cnt;
   if (uc_vld & ~uc_again) begin
      case (state) 
            ST_IDLE: begin
                  if (uc_first) begin
                     state_nxt = ST_FIRST;
                     cnt_nxt = cnt_ini;
                  end
               end
            ST_FIRST: begin
                  if (~dc_bsy) begin
                     state_nxt = ST_MID;
                     cnt_nxt = cnt_p1;
                  end
               end
            ST_MID: begin
                  if (~dc_bsy) begin
                     if (cnt_p1 == N && uc_last) begin
                        cnt_nxt = N;
                        state_nxt = ST_LAST;
                     end
                     else begin
                        if (cnt == N)
                           cnt_nxt = cnt_ini;
                        else
                           cnt_nxt = cnt_p1;
                     end
                  end 
               end
            ST_LAST: begin
                  if (~dc_bsy) begin
                      if (uc_first)
                          state_nxt = ST_FIRST;
                      else
                          state_nxt = ST_IDLE;
                      cnt_nxt = cnt_ini;
                  end 
               end
      endcase
   end
end

always @* begin
      cd_vld = 1'b0;
      cd_first = 1'b0;
      cd_last = 1'b0;
      cu_bsy = 1'b1;
      case (state) 
            ST_IDLE: begin
                  if (uc_first) begin
                     state_nxt = ST_FIRST;
                  end
               end
            ST_FIRST: begin
                  cd_vld = 1'b1;
                  cd_first = 1'b1;
               end
            ST_MID: begin
                  cd_vld = 1'b1;
                  cu_bsy = ~(cnt == N);
               end
            ST_LAST: begin
                  cd_vld = 1'b1;
                  cd_last = 1'b1;
               end
      endcase
end

// to downstream
assign   cd_d0 = uc_d0;

endmodule
