# Naive sqroot implementation

.section .rodata
	.align 16
	abs_mask: .quad 0x7fffffffffffffff, 0xffffffffffffffff

.section .text

.global sqroot

sqroot:
	# number passed in to calc sqroot is in rdi
	# return floating-point number in xmm0
	subq $8, %rsp

	# xmm0: contains the return value
	# xmm1: contains a copy of what we are multiplying with
	# xmm2: contains 1, used for incrementing xmm0
	# xmm6: contains number passed in to calc sqroot
	# xmm7: previous-best
	# xmm8: goal - previous-best
	# xmm9: goal - current-best

	movq $0, %rdx
	cvtsi2sd %rdx, %xmm0 # xmm0 is now 0
	cmp %rdx, %rdi # check if input is < 0, just return 0
	jle end
	incq %rdx
	cvtsi2sd %rdx, %xmm1 # xmm1 is now 1
	cvtsi2sd %rdx, %xmm2 # xmm2 is now 1
	cvtsi2sd %rdi, %xmm6 # xmm6 is now the number we calculate sqroot for, but in floating-point

	while_loop:
		# increment xmm0
		addsd %xmm2, %xmm0
		
		# save previous best
		movaps %xmm1, %xmm7
		
		# set xmm1 to xmm0
		movaps %xmm0, %xmm1

		# xmm1 = xmm1 * xmm0
		mulsd %xmm0, %xmm1

		# check if xmm6 > xmm1
		ucomisd %xmm1, %xmm6
		ja while_loop

	# compare previous best (xmm7) and current best (xmm1)

	# check if xmm1 == goal
	ucomisd %xmm1, %xmm6
	je end

	# move goal into xmm8
	# xmm8 = goal - previous best
	movaps %xmm6, %xmm8
	subsd %xmm7, %xmm8

	# move goal into xmm9
	# xmm9 = goal - current best
	movaps %xmm6, %xmm9
	subsd %xmm1, %xmm9

	# abs both of them
	andpd abs_mask(%rip), %xmm8
	andpd abs_mask(%rip), %xmm9
	
	ucomisd %xmm8, %xmm9
	jbe end
	subsd %xmm2, %xmm0

	end:
	addq $8, %rsp
	ret
