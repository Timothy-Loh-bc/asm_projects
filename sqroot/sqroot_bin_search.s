# Binary search sqroot implementation

.section .rodata
	# 6 decimal places
	precision: .double 0.000001
	zero: .double 0.0
	two: .double 2.0
	neg_nan: .quad 0xfff8000000000000

.section .text

.global sqroot

# @brief:	This function calculates the sqroot of a number according to a pre-defined
#			precision. It takes two values, a high (starting with the value passed in) 
#			and a low (0). Then it evaluates in every step, if we need to change the
#			high value. The algorithm converges in.
#			Following C Standard Library, negative numbers passed in, will immediately return
#			-NaN in xmm0.
sqroot:
	# arg is passed in via xmm0
	# ret will be passed out via xmm0

	subq $8, %rsp

	# 1. check if <= 0
	ucomisd zero(%rip), %xmm0
	jp ret_nan
	jz ret_0
	jb ret_nan

	# N:			xmm0 (IMMUTABLE)
	# high: 		xmm1
	# low: 			xmm2
	# mid: 			xmm3
	# high_temp:	xmm4

	# initialize high / low
	movsd zero(%rip), %xmm2 # low = 0
	movsd %xmm0, %xmm1 # high = n
	
	loop:
		# save high into high_temp
		movsd %xmm1, %xmm4

		# xmm4 = high - low
		subsd %xmm2, %xmm4

		ucomisd precision(%rip), %xmm4
		jbe end_of_loop

		# mid = (low + high) / 2

		# store high into mid
		movsd %xmm1, %xmm3
		# low + high
		addsd %xmm2, %xmm3
		# divide by 2
		divsd two(%rip), %xmm3

		# use xmm4 as a scratch register to store xmm3, used for squaring xmm3
		# without destroying it
		movsd %xmm3, %xmm4

		# square it
		mulsd %xmm3, %xmm4

		# assuming xmm0 is always the N passed in
		ucomisd %xmm0, %xmm4
		ja assign_mid_to_high
		jmp assign_mid_to_low

		assign_mid_to_high:		
			movsd %xmm3, %xmm1
			jmp loop
		assign_mid_to_low:
			movsd %xmm3, %xmm2
			jmp loop
			
	end_of_loop:
		addsd %xmm2, %xmm1
		divsd two(%rip), %xmm1
		movsd %xmm1, %xmm0
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
