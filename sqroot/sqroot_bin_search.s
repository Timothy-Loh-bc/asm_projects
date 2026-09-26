# Binary search sqroot implementation

.section .rodata
	# 6 decimal places
	precision: .double 0.000001
	zero: .double 0.0
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
	ucomisd %xmm0, zero(%rip)
	jz ret_0
	jb ret_nan

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
