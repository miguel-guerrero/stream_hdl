// as per Altera recomendation for automatic inference of ram1rw
module ram_bank (clk, we, d, addr, q);
parameter DW=8;
parameter AW=7;
parameter DEPTH=1<<AW;

input clk, we;
input [DW-1:0] d;
input [AW-1:0] addr;
output [DW-1:0] q;

reg [DW-1:0] mem [DEPTH-1:0];
reg [DW-1:0] q;
integer i;

    // synopsys translate_off
    initial begin
       $display("RAM_DUMP: INSTANCE: %m TYPE: ram1rw DW: %d AW: %d DEPTH: %d", DW, AW, DEPTH);
       for (i=0; i<DEPTH; i=i+1) begin
           mem[i] = 32'h0;
       end
    end
    // synopsys translate_on

    always @(posedge clk) begin
       if (we)
          mem[addr] <= d;
    end
    always @(posedge clk) begin
       q <= mem[addr]; // q doesn't get d in this clock cycle
    end

endmodule
