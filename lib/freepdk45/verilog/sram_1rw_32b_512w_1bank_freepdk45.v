// OpenRAM SRAM model
// Words: 512
// Word size: 32

module sram_1rw_32b_512w_1bank_freepdk45(DATA,ADDR,CSb,WEb,OEb,clk);

  parameter DATA_WIDTH = 32 ;
  parameter ADDR_WIDTH = 9 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;
  parameter DELAY = 3 ;

  inout [DATA_WIDTH-1:0] DATA;
  input [ADDR_WIDTH-1:0] ADDR;
  input CSb;             // active low chip select
  input WEb;             // active low write control
  input OEb;             // active output enable
  input clk;             // clock

  reg [DATA_WIDTH-1:0] data_out ;
  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

  // Tri-State Buffer control
  // output : When WEb = 1, oeb = 0, csb = 0
  assign DATA = (!CSb && !OEb && WEb) ? data_out : 32'bz;

  // Memory Write Block
  // Write Operation : When WEb = 0, CSb = 0
  always @ (posedge clk)
  begin : MEM_WRITE
  if ( !CSb && !WEb ) begin
    mem[ADDR] = DATA;
    $display($time," Writing %m ABUS=%b DATA=%b",ADDR,DATA);
    end
  end


  // Memory Read Block
  // Read Operation : When WEb = 1, CSb = 0
  always @ (posedge clk)
  begin : MEM_READ
  if (!CSb && WEb) begin
    data_out <= #(DELAY) mem[ADDR];
    $display($time," Reading %m ABUS=%b DATA=%b",ADDR,mem[ADDR]);
    end
  end

endmodule
