//******************************************************************************
/// @file    tb_apb_rom.v
/// @author  JAY CONVERTINO
/// @date    2021.06.23
/// @brief   SIMPLE TEST BENCH
///
/// @LICENSE MIT
///  Copyright 2021 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
///  sell copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

`timescale 1 ns/10 ps

module tb_apb_rom ();

  reg         tb_data_clk = 0;
  reg         tb_rst = 0;

  //apb3 registers
  reg         r_apb_pwrite;
  reg [15:0]  r_apb_paddr;
  reg [31:0]  r_apb_pwdata;
  reg         r_apb_penable;
  reg [ 0:0]  r_apb_psel;

  //wires
  wire        tb_apb_perror;
  wire        tb_apb_pready;
  wire [31:0] tb_apb_prdata;

  //1ns
  localparam CLK_PERIOD = 20;

  localparam RST_PERIOD = 500;

  //device under test
  apb_rom #(
    .ADDRESS_WIDTH(16),
    .BUS_WIDTH(4)
  ) dut (
    //clk reset
    .clk(tb_data_clk),
    .rst(tb_rst),
    //APB
    .s_apb_paddr(r_apb_paddr),
    .s_apb_psel(r_apb_psel),
    .s_apb_penable(r_apb_penable),
    .s_apb_pready(tb_apb_pready),
    .s_apb_pwrite(r_apb_pwrite),
    .s_apb_pwdata(r_apb_pwdata),
    .s_apb_prdata(tb_apb_prdata),
    .s_apb_pslverror(tb_apb_perror)
  );

  //axis clock
  always
  begin
    tb_data_clk <= ~tb_data_clk;

    #(CLK_PERIOD/2);
  end

  //reset
  initial
  begin
    tb_rst <= 1'b1;

    #RST_PERIOD;

    tb_rst <= 1'b0;
  end

  //copy pasta, fst generation
  initial
  begin
    $dumpfile("tb_abp_rom.fst");
    $dumpvars(0,tb_apb_rom);
  end

  //io apb3
  always @(posedge tb_data_clk)
  begin
    if(tb_rst)
    begin
      r_apb_pwrite  <= 1'b0;
      r_apb_penable <= 1'b0;
      r_apb_psel    <= 0;
      r_apb_pwdata  <= 'hAAAADEAD;
      r_apb_paddr   <= 0;
    end else begin
      r_apb_pwrite  <= 1'b0;
      r_apb_penable <= 1'b0;
      r_apb_psel    <= 1;

      if(r_apb_psel == 1)
      begin
        r_apb_penable <= 1'b1;

        if(tb_apb_pready && r_apb_penable)
        begin
          r_apb_penable <= 1'b0;
          r_apb_paddr <= r_apb_paddr + 'h4;
        end

      end

    end
  end

endmodule
