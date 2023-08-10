//NAME :ABHIROOP KAUR
//UCID:30152829
//DESCRIPTION: ASSIGNMENT 6





			.data						
pi_over_2:		.double	0r1.57079632679489661923			// setting global variable for pi/2
float_90:		.double 0r90.0						// float constant 90.0 
float_0:		.double 0r0.0						// float constant 0.0
deg_l:			.double 0r0.0						// lower bound
deg_u:			.double	0r90.0						// upper bound.
convergence_limit:	.double	0r1.0e-10					// Limit for when to stop Taylor series.
			.text
print_1:		.string "Opening file: %s\n"				// output.
print_header:		.string "|   x (Degrees)  |    cos(x)     |     sin(x)    |\n"
print_2:		.string "       %.2f     "					
print_3:		.string "End of file reached.\n"			
print_cos:		.string "   %.10f  "					// print statement for cosine.
print_sin:		.string "  %.10f  \n"					// print statement for sine.

print_err1:		.string "Error: incorrect number of arguments. Usage: ./a6 <filename.bin>\n"
										// error messages
print_err2:		.string "Error: Filename %s not found.\n"		
print_err3:		.string "Input %f out of range.\n"				
			

buf_size = 8									// creating buffer for reading 8-byte inputs
alloc = -(16 + buf_size)&-16							// allocating memory
dealloc = -alloc								// dellocating memory 
buf_s = 16									// location of buffer in memory

i_r			.req w19						// counter 
argcommand_r		.req w20						
argval_r		.req x21						// Argument values
filed_r			.req w22						// file descriptor register.
bufferbase_r		.req x23						// base register of buffer
nread_r			.req x24						// base address 			






			.balign 4





sin:			stp 	x29, x30, [sp, -16]!				// part sine 
			mov 	x29, sp

			
		

			fmov	d9, d0						// moving input d0 into temporary register d9

			adrp	x10, convergence_limit				// getting address pointer for convergence limit
			add	x10, x10, :lo12:convergence_limit
			ldr	d10, [x10]								

			adrp	x11, pi_over_2					// getting the address pointer for pi/2 constant
			add	x11, x11, :lo12:pi_over_2
			ldr	d11, [x11]					
			adrp	x12, float_90					// getting address pointer for the float constant 90
			add	x12, x12, :lo12:float_90			
			ldr	d12, [x12]					// Load float value of 90 into d12			

			fdiv	d11, d11, d12					// d11 = pi / 2 / 90 = pi / 180

			fmul	d9, d9, d11					// Convert degrees to radians ( deg * pi/180 )	

			mov	w11, 1						// Term number. (Increases by 1 each iteration)

			adrp	x15, float_0					// Initialize d15 to 0.0
			add	x15, x15, :lo12:float_0
			ldr	d15, [x15]			


		

			
			fmov	d12, 1.0							
sin_loop:										
			
			cmp	w11, 1						// checking if w11 = 1 is the first term
			b.gt	sin_next1									
			fmov	d13, d9						// setting first term to equal x
			b	sin_continue					//branching to continue		
sin_next1:		
			fmul	d13, d13, d9					
			fmul	d13, d13, d9				 	// multiplying the  current term by x (x^2 total)
			fdiv	d13, d13, d12					
			fmov	d14, 1.0					// setting temporary register to 1.0
			fsub	d12, d12, d14					
			fdiv	d13, d13, d12					// dividing by n-1
			fadd	d12, d12, d14					// incrementing the n back
			
			fneg	d13, d13					// negating the current term.

			

sin_continue:		fadd	d15, d15, d13					// adding current term to ongoing sum
			add	w11, w11, 1					
			fmov	d1, 2.0						
			fadd	d12, d12, d1								
										// checking if current term is smaller than convergence limit

			adrp	x14, float_0					// setting a temporary register d14 = 0.0 for comparison
			add	x14, x14, :lo12:float_0
			ldr	d14, [x14]

			fcmp	d13, d14					// check if current value is a negative value
			b.gt	sin_conv_check					
									
									
			fneg	d13, d13
			fcmp	d13, d10					// Check if value is greater than convergence limit,
			fneg	d13, d13					// Return value to what it was before.
			b.gt	sin_loop					// If current value was greater, then branch back to top of loop.
			b	sin_end						// Otherwise, branch to sin_end.	
			

sin_conv_check:		fcmp	d13, d10					// If current term is greater than convergence limit,
			b.gt	sin_loop					// Loop back to top.
										// Otherwise, end.	


sin_end:			fmov	d0, d15						
			ldp 	x29, x30, [sp], 16					
			ret							// Return 











		
cos:			stp 	x29, x30, [sp, -16]!				// part cosine
			mov 	x29, sp

			
								
			fmov	d9, d0						// moving input d0 into temporary register d9

			adrp	x10, convergence_limit				// getting the  address pointer for convergence limit
			add	x10, x10, :lo12:convergence_limit
			ldr	d10, [x10]								

			adrp	x11, pi_over_2					// getting the  address pointer for pi/2 constant
			add	x11, x11, :lo12:pi_over_2
			ldr	d11, [x11]					// Load value of pi/2 into d11

			adrp	x12, float_90					// Get address pointer for the float constant 90
			add	x12, x12, :lo12:float_90			
			ldr	d12, [x12]					// Load float value of 90 into d12			

			fdiv	d11, d11, d12					
			fmul	d9, d9, d11					// converting degrees to radians	

			mov	w11, 1						
			adrp	x15, float_0					
			add	x15, x15, :lo12:float_0
			ldr	d15, [x15]			


			// Begin the loop to calculate cosine.	

			adrp	x12, float_0					// setting n to 0 (x^n / n!)
			add	x12, x12, :lo12:float_0
			ldr	d12, [x12]
		
cos_loop:		// Check if current term is the first term.
			
			cmp	w11, 1						// checking if this is the first term	
			b.gt	cos_next1					// If it is, set first term value = 1. Otherwise branch.
			
			fmov	d13, 1.0					// setting first term to 1.0
			b	cos_continue							
cos_next1:		
			fmul	d13, d13, d9					
			fmul	d13, d13, d9				 	// multiplying the  current term by x (x^2 total)
			fdiv	d13, d13, d12					
			fmov	d14, 1.0					// setting temporary register to 1.0
			fsub	d12, d12, d14					
			fdiv	d13, d13, d12					
			fadd	d12, d12, d14					// incrementing n back to its current value.
			
			fneg	d13, d13					// negating the term.

			// Add current term to ongoing sum.

cos_continue:		fadd	d15, d15, d13					// Add current term to ongoing sum
			add	w11, w11, 1					// Increment term number by 1
			fmov	d1, 2.0						
			fadd	d12, d12, d1								
		

			adrp	x14, float_0					// setting a temporary register d14 = 0.0
 			add	x14, x14, :lo12:float_0
			ldr	d14, [x14]

			fcmp	d13, d14					// checking if current value is negative
			b.gt	cos_conv_check					// if the value is  positive then go to regular convergence check.
									
									
			fneg	d13, d13
			fcmp	d13, d10					// Check if value is greater than convergence limit,
			fneg	d13, d13					// Return value to what it was before.
			b.gt	cos_loop					// If current value was greater, then branch back to top of loop.
			b	cos_end						// Otherwise, branch to cos_end.	
			

cos_conv_check:		fcmp	d13, d10					// If current term is greater than convergence limit,
			b.gt	cos_loop						
									


cos_end:			fmov	d0, d15					// moving return value to d0.
			ldp 	x29, x30, [sp], 16					
			ret							// Return 






			.global main

main:			stp	x29, x30, [sp, alloc]!				
			mov	x29, sp

			mov	argcommand_r,	w0
			mov	argval_r,	x1

			
			cmp	argcommand_r, 2					// comparing number of arguments.
			b.eq	next_1						
			adrp	x0, print_err1					// error message.
			add	x0, x0, :lo12:print_err1
			bl	printf
			b	end						// branching to end.

			
			// Print out "reading input from file". 
next_1:			adrp	x0, print_1					// values into the string	
			add	x0, x0, :lo12:print_1				
			ldr	x1, [argval_r, 8]					
			bl	printf						
	
			mov	w0, -100					// reading input from file.
			ldr	x1, [argval_r, 8]				// putting input string into x1
			mov	w2, 0						
			mov	w3, 0						
			mov	x8, 56						// Openat I/O request
			svc	0						// Call system function
			mov	filed_r, w0					// Move result into file descriptor.

			// Do error checking for openat()
			cmp	filed_r, 0					// Error check: branch over.
			b.ge	next_2						// If filed_r > 0, open successful.

			adrp	x0, print_err2					// error message 
			add	x0, x0, :lo12:print_err2
			ldr	x1, [argval_r, 8]					
			bl	printf						
			b	end						// branching to end.

next_2:		

			adrp	x0, print_header				// Print
			add	x0, x0, :lo12:print_header
			bl	printf

			add	bufferbase_r, x29, buf_s			// Setting memory base address of buffer
open:			mov	w0, filed_r					
			mov	x1, bufferbase_r					
			mov	w2, buf_size					
			mov	x8, 63						// reading I/O request
			svc	0						// caling system function
			mov	nread_r, x0					
			cmp	nread_r, buf_size				
			b.ne	exit						//branch to end.

		
			
			adrp	x0, print_2					//print
			add	x0, x0, :lo12:print_2				 
			ldr	d0, [bufferbase_r]					
			bl	printf						
			

			ldr	d0, [bufferbase_r]				// loading input
			bl	cos						// branch- link to cos(x)

			adrp	x0, print_cos					// Set up print statement for cos(x)
			add	x0, x0, :lo12:print_cos
			bl	printf						// Branch link to print()


			

			ldr	d0, [bufferbase_r]					
			bl	sin						// Branch-link to sin(x)
			
			adrp	x0, print_sin					// Set up print statement for sin(x)
			add	x0, x0, :lo12:print_sin
			bl	printf						// Branch-link to print()

			b	open								
exit:			adrp	x0, print_3					// setting up print_3 statement
			add	x0, x0, :lo12:print_3					
			bl	printf						
			
			mov	w0, filed_r					
			mov	x8, 57						// closing I/O request
			svc	0						// calling system function.

end:			ldp	x29, x30, [sp], dealloc				// De-allocating memory from stack
			ret							// Return 			

