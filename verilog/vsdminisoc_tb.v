`timescale 1ns / 1ps
`include "vsdminisoc.v"
`include "avsdpll.v"
`include "rvmyth.v"
`include "clk_gate.v"

module vsdminisoc_tb;
   reg       reset;
   reg       VCO_IN;
   reg       ENb_CP;
   reg       ENb_VCO;
   reg       REF;
   reg [9:0] OUT;

   vsdminisoc uut (
      .OUT(OUT),
      .reset(reset),
      .VCO_IN(VCO_IN),
      .ENb_CP(ENb_CP),
      .ENb_VCO(ENb_VCO),
      .REF(REF),
      );

   initial begin
      reset = 0;
      {REF, ENb_VCO} = 0;
      VCO_IN = 1'b0 ;
      
      #20 reset = 1;
      #100 reset = 0;
   end
   
   initial begin
      $dumpfile("rvmyth_pll.vcd");
      $dumpvars(0, vsdminisoc_tb);
   end
 
   initial begin
      repeat(600) begin
         ENb_VCO = 1;
         #100 REF = ~REF;
         #(83.33/2) VCO_IN = ~VCO_IN;
      end
      $finish;
   end
   
endmodule
