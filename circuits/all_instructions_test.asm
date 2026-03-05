.text
   addi  x1, x0, 0x678    // 0x67800093
   lui   x1, 0x12345      // 0x123450b7

   addi  x2, x0, -1       // 0xfff00113
   lui   x2, 0xABCDE      // 0xabcde137

lbl :   
   add  x3,  x2, x1       // 0x001101b3
   sub  x4,  x2, x1       // 0x40110233
   and  x5,  x2, x1       // 0x001172b3 
   or   x6,  x2, x1       // 0x00116333
   xor  x7,  x2, x1       // 0x001143b3 
   sll  x8,  x2, x1       // 0x00111433
   srl  x9,  x2, x1       // 0x001154b3
   sra  x10, x2, x1       // 0x40115533
   slt  x11, x2, x1       // 0x001125b3
   sltu x12, x2, x1       // 0x00113633
   
   addi  x13, x2, 0x678   // 0x67810693
   andi  x14, x2, 0x678   // 0x67817713   
   ori   x15, x2, 0x678   // 0x67816793   
   xori  x16, x2, 0x678   // 0x67814813   
   slli  x17, x2, 1       // 0x00111893
   srli  x18, x2, 2       // 0x00215913
   srai  x19, x2, 3       // 0x40315993
   slti  x20, x2, 4       // 0x00412a13
   sltiu x21, x2, 5       // 0x00513a93
   
   beq  x1, x7,  lbl      // 0xfa708ae3
   bne  x2, x8,  lbl      // 0xfa8118e3
   bge  x3, x9,  lbl      // 0xfa91d6e3
   bgeu x4, x10, lbl      // 0xfaa274e3
   blt  x5, x11, lbl      // 0xfab2c2e3
   bltu x6, x11, lbl      // 0xfab360e3
   
   sb   x1, 1(x0)         // 0x001000a3
   sh   x1, 2(x0)         // 0x00101123    
   sw   x1, 4(x0)         // 0x00102223
   lb   x1, 5(x0)         // 0x00500083
   lbu  x1, 7(x0)         // 0x00704083
   lh   x1, 6(x0)         // 0x00601083
   lhu  x1, 4(x0)         // 0x00405083    
   lw   x1, 0(x0)         // 0x00002083
   
   jal   x0, lbl          // 0xf7dff06f
   auipc x0, 0xfffff      // 0xfffff017
   jalr  x0, 0(x0)        // 0x00000067
