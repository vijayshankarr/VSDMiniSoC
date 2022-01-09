# VSDMiniSoC
this project aims at designing a SoC with RISCV based microprocessor and perform Physical Design to get the SoC ready for tapeout. Here, we are going to use open source tools and software for design and analysis, hence making an attempt to spread the word about open source chip design possibilities by setting examples.

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
RVMYTH Corre TLV : verilog/rvmyth.tlv

Steps to install sandpiper-saas tool:

```
$ sudo apt install make python python3 python3-pip git iverilog gtkwave docker.io
$ sudo chmod 666 /var/run/docker.sock
$ cd ~
$ pip3 install pyyaml click sandpiper-saas
```

Add the tool path to the $PATH env variable to avoid errors.

Command to convert TLV to Verilog :

![image](https://user-images.githubusercontent.com/94952142/148683684-e04ec697-59d0-4b3c-a63e-9c450bb2a9db.png)

Output : `rvmyth.v` and `rvmyth_gen.v` files will be created in the same directory

The details of rvmyth design workshop report can be found [here](https://github.com/vijayshankarr/vsd_RISC-V_workshop)


## PLL Modelling
Since PLL is an analog block, functional/ behavioural verilog model of PLL is created to integrate with the rvmyth core.
The functional verilog model for PLL is designed based on avsdpll block designed by vsd interns.

File : `verilog/avsdpll.v`

## Integration of PLL and RVMYTH Core
The CLK output from PLL functional block is connected as input clock to RVMYTH core. And a testbench is created to test the working snf snslyse the outputs.

Files : 
- `verilog/vsdminisoc.v` (Functional block)
- `verilog/vsdminisoc_tb.v` (Testbench)

Commands used to generate the vcd file:

![image](https://user-images.githubusercontent.com/94952142/148683936-d42bf8d3-3169-41aa-8431-5f3b06c39bf5.png)

Command used to view the vcd waveforms :

![image](https://user-images.githubusercontent.com/94952142/148683985-3396b8b9-3f1f-4ab5-a3ca-78eddd4ea67d.png)


### Output :
![image](https://user-images.githubusercontent.com/94952142/148682998-e138dbb1-1f36-4112-bc5b-3c193d0a5d86.png)

# References
- [https://github.com/manili/VSDBabySoC](https://github.com/manili/VSDBabySoC)
- [https://github.com/shivanishah269/risc-v-core](https://github.com/shivanishah269/risc-v-core)
- [https://github.com/shivanishah269/vsdfpga](https://github.com/shivanishah269/vsdfpga)
- [https://github.com/lakshmi-sathi/avsdpll_1v8](https://github.com/lakshmi-sathi/avsdpll_1v8)


