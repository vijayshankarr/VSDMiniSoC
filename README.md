# VSDMiniSoC
This project aims at designing a SoC with RISCV based microprocessor and perform Physical Design to get the SoC ready for tapeout. Here, we are going to use open source tools and software for design and analysis, hence making an attempt to spread the word about open source chip design possibilities by setting examples.

# Introduction
 A System on Chip (SoC) is an integrated chip that contains all the required blocks, like CPU, internal memory, input and output blocks, hence reducing the power consumption, size
and improving performance. In this project, we will design a SoC, which integrates a RISC-V based microprocessor with PLL, DAC and SRAM blocks, and perform Physical design. The last SoC designed by VSD - VSDBabySoC - comprised PLL and DAC blocks, where the instructions were stored in internal register memory. This project enhances the previous design by including an SRAM block. Since SRAMs can serve as high speed registers and cache memories, they can be used to store the instructions and provide additional registers which can perform additional computations and can provide scope for enhancing the functionalities of the microprocessor at large.

# COMPONENTS
The various components of the VSDMiniSoC (see Fig. 1) are:
![image](https://user-images.githubusercontent.com/94952142/148682270-09039217-fbe5-43c6-80b9-e91c48e3c74f.png)

Fig. 1 Block diagram of components in SoC 

## A. RISC-V based Microprocessor
RISC-V is an open standard instruction set architecture (ISA) based on reduced instruction set computer (RISC) principles, which has open source licenses. A RISC-V based microprocessor (uP) used in this project may have functionalities to perform basic arithmetic computations, which can be used for educational purposes and can be used as reference for future designs. 

## B. Phase Locked Loop (PLL):
A phase-locked loop is a feedback circuit used to synchronize the phase and frequency of the Voltage controlled crystal oscillator output signal with the reference signal. In this SoC, PLL may be used for generation of the stable system clock for processor. In future if Synchronous SRAMs are used, then it can provide clock input to SRAMs as well. 

## C. DAC
A Digital to Analog Converter is a circuit that converts a digital signal into analog signal. They are widely used in communication systems and in data loggers. Here, the DAC can be used to process the micro-processor output to give final SoC analog output. They can also be used as digital power supply for processor.

## D. SRAM
A Static Random Access Memory uses bistable latching circuitry made of transistors to store binary bits and requires a constant power flow to hold information. Since, they don’t have capacitors to store data and hence constant refresh is not required like DRAMs. They are more expensive and hold less data per unit volume. Therefore, they are used popularly as cache memory, buffer and high speed registers. There are different types, based on load, like 4T, 6T and TFT. Among this 6T cell, which consists of 4 NMOS and 2 PMOS, offers better electrical performances as it uses MOSFETs instead of resistor or transistor loads. The data transfer between SRAM and uP can be asynchronous or synchronous. Here, in this project we can use a 6T cell asynchronous SRAM. In future, this can be enhanced to synchronous SRAMs, in which the read/write cycles are synchronized with uP clock, and therefore can be used for high speed functionalities.

# VSDMiniSoC Modelling

## RVMYTH Core Modelling
RVMYTH core is designed in TL Verilog on Makerchip platform. After this we use sandpiper-saas to convert TLVerilog code to Verilog code.

RVMYTH Core TLV : verilog/rvmyth.tlv

Steps to install sandpiper-saas tool:

```
$ sudo apt install make python python3 python3-pip git iverilog gtkwave docker.io
$ sudo chmod 666 /var/run/docker.sock
$ cd ~
$ pip3 install pyyaml click sandpiper-saas
```

Add the tool path to the $PATH env variable to avoid errors.

Add the module definition and makerchip interface added for babysoc at the top of rvmyth tlv file
```
   // Module interface, either for Makerchip, or not.
   m4_ifelse_block(M4_MAKERCHIP, 1, ['
   // Makerchip module interface.
   m4_makerchip_module
   wire CLK = clk;
   logic [9:0] OUT;
   assign passed = cyc_cnt > 300;
   '], ['
   // Custom module interface for BabySoC.
   module rvmyth(
      output reg [9:0] OUT,
      input CLK,
      input reset
   );
   wire clk = CLK;
   '])
```

Remove the passed and failed conditional wires and assign the output register value to OUT signal:
```
   // Assert these to end simulation (before Makerchip cycle limit).
   //*passed = *cyc_cnt > 40;
   //*passed = |cpu/xreg[15]>>5$value == (1+2+3+4+5+6+7+8+9);
   //*failed = 1'b0;
   \SV_plus
      always @ (posedge clk) begin
          *out = |cpu/xreg[15]>>5$value
      end
```

Command to convert TLV to Verilog :

![image](https://user-images.githubusercontent.com/94952142/148683684-e04ec697-59d0-4b3c-a63e-9c450bb2a9db.png)

Output : `rvmyth.v` and `rvmyth_gen.v` files will be created in the same directory

The details of rvmyth design workshop report can be found [here](https://github.com/vijayshankarr/vsd_RISC-V_workshop)


## PLL Modelling
Since PLL is an analog block, functional/ behavioural verilog model of PLL is created to integrate with the rvmyth core.
The functional verilog model for PLL is designed based on avsdpll block designed by vsd interns.

File : `verilog/avsdpll.v`

## Integration of PLL and RVMYTH Core
The CLK output from PLL functional block is connected as input clock to RVMYTH core. And a testbench is created to test the working and analyse the outputs.

Files : 
- `verilog/vsdminisoc.v` (Functional block)
- `verilog/vsdminisoc_tb.v` (Testbench)

Commands used to generate the vcd file:

![image](https://user-images.githubusercontent.com/94952142/148683936-d42bf8d3-3169-41aa-8431-5f3b06c39bf5.png)

Command used to view the vcd waveforms :

![image](https://user-images.githubusercontent.com/94952142/148683985-3396b8b9-3f1f-4ab5-a3ca-78eddd4ea67d.png)

### Output :
![image](https://user-images.githubusercontent.com/94952142/148682998-e138dbb1-1f36-4112-bc5b-3c193d0a5d86.png)

## Issues seen during Integration of PLL with RVMYTH

### Issue :
Syntax error in continuos assignment.

#### Error Snapshot 1:
![image](https://user-images.githubusercontent.com/94952142/149650982-fe577be2-4b7e-42d0-ac37-5b6ebb567f36.png)

#### Error Snapshot 2:
![image](https://user-images.githubusercontent.com/94952142/149651025-934a4f55-118c-4866-9668-e2a4c408a3f5.png)

#### Resolution :
The issue is fixed after updating the `==?` to `==`.

### Issue :
reg instrs; cannot be driven by primitives or continuos assignment

#### Error Snapshot 1:
![image](https://user-images.githubusercontent.com/94952142/149651037-fd2755e1-4f2b-42a6-aade-48bff3c1d5f8.png)

#### Error Snapshot 2 :
![image](https://user-images.githubusercontent.com/94952142/149651056-476fbe05-cfb5-4820-93b4-9f4f61726f23.png)

#### Resolution :
This is fixed if we use riscv_shell_lib.tlv from shivani shah's github repo.

Include the following library in rvmyth.tlv :
m4_include_lib(['https://raw.githubusercontent.com/shivanishah269/risc-v-core/master/FPGA_Implementation/riscv_shell_lib.tlv'])

### Issue : 
The Assembly code from RISCV workshop is not giving the expected output with the changes. 

#### Resolution :
Change the ASM code to fix the issue.

Code from RISCV workshop :
```
   m4_asm(ADD, r10, r0, r0)             // Initialize r10 (a0) to 0.
   // Function:
   m4_asm(ADD, r14, r10, r0)            // Initialize sum register a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store count of 10 in register a2.
   m4_asm(ADD, r13, r10, r0)            // Initialize intermediate sum register a3 with 0
   // Loop:
   m4_asm(ADD, r14, r13, r14)           // Incremental addition
   m4_asm(ADDI, r13, r13, 1)            // Increment intermediate register by 1
   m4_asm(BLT, r13, r12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   m4_asm(ADD, r10, r14, r0)            // Store final result to register a0 so that it can be read by main program
   
   m4_asm(SW, r0, r10, 100)
   m4_asm(LW, r15, r0, 100)
   // Optional:
   // m4_asm(JAL, r7, 00000000000000000000) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)
```

New code used :
```
   m4_asm(ADDI, r9, r0, 1)
   m4_asm(ADDI, r10, r0, 101011)
   m4_asm(ADDI, r11, r0, 0)
   m4_asm(ADDI, r15, r0, 0)
   m4_asm(ADD, r15, r15, r11)
   m4_asm(ADDI, r11, r11, 1)
   m4_asm(BNE, r11, r10, 1111111111000)
   m4_asm(ADD, r15, r15, r11)
   m4_asm(SUB, r15, r15, r11)
   m4_asm(SUB, r11, r11, r9)
   m4_asm(BNE, r11, r9, 1111111111000)
   m4_asm(SUB, r15, r15, r11)
   m4_asm(BEQ, r0, r0, 1111111100000)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)
```

## Integration of DAC and RVMYTH Core
The 10 bit output from RVMYTH core is connected to DAC and the output from DAC is taken out as final out of vsdminisoc. And a testbench is created to test the working and analyse the outputs.

Files : 
- `verilog/avsddac.v` (DAC Functional block)
- `verilog/vsdminisoc.v` (Functional block)
- `verilog/vsdminisoc_tb.v` (Testbench)

### Output :
![image](https://user-images.githubusercontent.com/94952142/149652085-4aac8e07-018e-40fd-9040-2d5ba9186b9e.png)

## Issues seen during Integration of DAC with RVMYTH Core

### Issue :
The OUT signal from avsddac gives a continuos low (0) throughout. 

#### Error Snapshot :
![image](https://user-images.githubusercontent.com/94952142/149650822-c1aa82b3-0580-4e18-8d76-f225614dacb7.png)

#### Resolution :
Input output asignment causing issue :

![image](https://user-images.githubusercontent.com/94952142/149650900-8559ca8e-10eb-4742-b922-960074726f4b.png)

Use the input output signal assignment as follows :

![image](https://user-images.githubusercontent.com/94952142/149650880-c76ff5f4-a277-42c1-88b9-52d0e792784f.png)

# References
- [https://github.com/manili/VSDBabySoC](https://github.com/manili/VSDBabySoC)
- [https://github.com/shivanishah269/risc-v-core](https://github.com/shivanishah269/risc-v-core)
- [https://github.com/shivanishah269/vsdfpga](https://github.com/shivanishah269/vsdfpga)
- [https://github.com/lakshmi-sathi/avsdpll_1v8](https://github.com/lakshmi-sathi/avsdpll_1v8)


