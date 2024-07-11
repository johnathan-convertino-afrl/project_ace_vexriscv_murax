//Jay Convertino

module apb_rom  #(
    parameter ADDRESS_WIDTH = 16,
    parameter BUS_WIDTH     = 4
  )
  (
    //clk reset
    input                       clk,
    input                       rst,
    //APB3
    input  [ADDRESS_WIDTH-1:0]  s_apb_paddr,
    input  [0:0]                s_apb_psel,
    input                       s_apb_penable,
    output                      s_apb_pready,
    input                       s_apb_pwrite,
    input  [BUS_WIDTH*8-1:0]    s_apb_pwdata,
    output [BUS_WIDTH*8-1:0]    s_apb_prdata,
    output                      s_apb_pslverror
  );

  reg                       r_up_rack;
  reg  [BUS_WIDTH*8-1:0]    r_up_rdata;
  wire                      s_up_rreq;
  wire                      s_up_rack;

  assign s_up_rack  = r_up_rack & s_up_rreq;

  //device under test
  up_apb3 #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .BUS_WIDTH(BUS_WIDTH)
  ) inst_up_apb3 (
    //clk reset
    .clk(clk),
    .rst(rst),
    //APB
    .s_apb_paddr(s_apb_paddr),
    .s_apb_psel(s_apb_psel),
    .s_apb_penable(s_apb_penable),
    .s_apb_pready(s_apb_pready),
    .s_apb_pwrite(s_apb_pwrite),
    .s_apb_pwdata(s_apb_pwdata),
    .s_apb_prdata(s_apb_prdata),
    .s_apb_pslverror(s_apb_pslverror),
    //uP
    //read interface
    .up_rreq(s_up_rreq),
    .up_rack(s_up_rack),
    .up_raddr(),
    .up_rdata(r_up_rdata),
    //write interface
    .up_wreq(),
    .up_wack(1'b0),
    .up_waddr(),
    .up_wdata()
  );

   //up registers decoder
  always @(posedge clk)
  begin
    if(rst)
    begin
      r_up_rack   <= 1'b0;
      r_up_rdata  <= 0;
    end else begin
      r_up_rack   <= 1'b0;
      r_up_rdata  <= r_up_rdata;

      if(s_up_rreq == 1'b1)
      begin
        r_up_rack <= 1'b1;

        r_up_rdata <= 'h41424344;
      end
    end
  end

endmodule
