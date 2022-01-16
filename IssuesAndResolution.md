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
