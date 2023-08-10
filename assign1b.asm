// File: firstcode.s
// Authors: Abhiroop Kaur
//Date : 21 Sept 2021
//
//Description:
//   Assignment 1 (with macros)

output_str:     .string "x:%d, y:%d, maxima:%d"
                .balign 4
                .global main
		b loop_test
main :
                stp     x29, x30, [sp, -16]!  //save FP and LR to stack
                mov     x29, sp               //Update FP to current SP

                // initialize the loop counter
                mov x19, -10 //loop starts from -10
                mov x26, 0   // initializing maxima
define(x_r,x19)
		mov x_r,-10    // initialization
		b loop_test    // calling the test part of loop
loop_top: // loop starts here

                

                mov x20, 56 // storing the constant values
                mul x20, x19,x20  // creating the first value of the function 56x

                mul x21, x19, x19
                mov x22, 301            // // storing the constant values
                mul x22, x22, x21   // creating the second value of the function 301x^2

                mul x23, x21, x21       // x^4
                mov x24, -4              // storing the constant values
                mul x24, x24, x23        // creating the last value of -4x^4


                add x25,x20,x22
                add x25, x25, x24
                sub x25, x25, 103       // getting the final y value 

                cmp x26, x25		// comparing the maxima value to get the greater one


                b.ge else		 // calling the else statement 

                ldr x0,=output_str

                mov x26, x25		   // changing the value to new maxima  
else:
                ldr x0,=output_str
                mov x1, x19
                mov x2, x25
                mov x3, x26
                bl printf		// calling printf
                add x_r, x_r,1

loop_test:
       		cmp x_r,10
		b.le loop_top		// returning to the loop
exit:
                ldp x29, x30, [sp],16	 // restore the stack
                ret			// returning value
