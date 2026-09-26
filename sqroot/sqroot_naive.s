# Naive sqroot implementation

.section .rodata
	.align 16
	abs_mask: .quad 0x7fffffffffffffff, 0xffffffffffffffff
	neg_nan: .quad 0xfff8000000000000
	zero: .double 0.0
	one: .double 1.0

.section .text

.global sqroot

# @brief: 	This function approximates sqroots
# 			It starts off with 1, and it checks if the value squared is more than
#			or equals to the value we expect. If not, it will increment by 1 every loop iteration.
#			Although the result is in a floating-type, the decimals are always 0.
sqroot:
	# number passed in to calc sqroot is in xmm0
	# return floating-point number in xmm0
	subq $8, %rsp

	# xmm0: contains the return value & passed in value
	# xmm1: contains a copy of what we are multiplying with
	# xmm6: immutable value that contains sqroot input
	# xmm7: previous-best
	# xmm8: goal - previous-best
	# xmm9: goal - current-best

	ucomisd zero(%rip), %xmm0
	jp ret_nan
	jz ret_0
	jb ret_nan

	movsd %xmm0, %xmm6
	
	movsd zero(%rip), %xmm0 # xmm0 is now 0 
	movsd %xmm0, %xmm1
	addsd one(%rip), %xmm1 # xmm1 is now 1

	while_loop:
		# increment xmm0
		addsd one(%rip), %xmm0
		
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
	subsd one(%rip), %xmm0

	jmp end

	ret_nan:
		movsd neg_nan(%rip), %xmm0
		jmp end

	ret_0:
		movsd zero(%rip), %xmm0
		jmp end

	end:
	addq $8, %rsp
	ret
