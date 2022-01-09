module vsdminisoc (
   output wire [9:0] OUT,
   input  wire reset,
   input  wire VCO_IN,
   input  wire ENb_CP,
   input  wire ENb_VCO,
   input  wire REF
);

   wire CLK;
   
   rvmyth core (
      .OUT(OUT),
      .CLK(CLK),
      .reset(reset)
   );

   avsdpll pll (
      .CLK(CLK),
      .VCO_IN(VCO_IN),
      .ENb_CP(ENb_CP),
      .ENb_VCO(ENb_VCO),
      .REF(REF)
   );   
endmodule
