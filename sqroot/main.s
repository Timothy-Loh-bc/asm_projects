.section .rodata
	array: .quad -2,0,1,5,9,10,15,25,63,65,100,121,144,145,146,147,155,200,222,2000,3000,4000,7000,10000,150000
	number_of_elems: .quad 25
	printf_string: .string "The square root of %d is %lf\n"

.section .text

.global main

.extern sqroot
.extern printf
main:
	# realign the stack pointer
	subq $8, %rsp

	# rcx used for indexing through array 
	xorq %rcx, %rcx

	# r8 used for address of the first element of the array
	leaq array(%rip), %r8
	
	# r9 used for number of elements in the array
	movq number_of_elems(%rip), %r9

	for_loop_array:
		# we use rdi for the number we are calculating for
		# preparing it for the first arg when calling sqroot, therefore, moving it to xmm0 
		# (as per SystemV x86-64 convention)
		movq (%r8,%rcx,8), %rdi
		cvtsi2sd %rdi, %xmm0		
		
		incq %rcx

		# calling sqroot here, return value in rax
		pushq %r8
		pushq %r9
		pushq %rcx
		pushq %rdi
		call sqroot
		popq %rdi
		popq %rcx
		popq %r9
		popq %r8
		
		# setup printf args
		movq %rdi, %rsi # move the number we want to calc sqroot to 2nd arg
		leaq printf_string(%rip), %rdi # string to print is 1st arg
		
		# by SystemV ABI, floating-point values are returned via xmm registers
		# therefore, we don't need to touch it, we assume the floating-point
		# value to print is in xmm0
		
		movb $1, %al # one floating-point number

		# save caller-saved registers before calling printf
		pushq %r8
		pushq %r9
		pushq %rcx

		# rsp is misaligned, therefore, manual adjust it
		subq $8, %rsp
		call printf
		addq $8, %rsp
		
		popq %rcx
		popq %r9
		popq %r8

		# check for exit condition
		cmpq %r9, %rcx
		jnz for_loop_array
	
	addq $8, %rsp # restore stack pointer to original value
	xorq %rax, %rax # return value is 0 for success
	ret
