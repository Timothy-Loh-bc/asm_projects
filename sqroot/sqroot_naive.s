# Naive sqroot implementation

.section .text

.global sqroot

sqroot:
	# number passed in to calc sqroot is in rdi
	# return floating-point number in xmm0
	subq $8, %rsp

	# xmm0: contains the return value
	# xmm1: contains a copy of what we are multiplying with
	# xmm2: contains 1, used for incrementing xmm0
	# xmm3: contains number passed in to calc sqroot

	movq $0, %rdx
	cvtsi2sd %rdx, %xmm0 # xmm0 is now 0
	incq %rdx 
	cvtsi2sd %rdx, %xmm2 # xmm2 is now 1
	cvtsi2sd %rdi, %xmm3 # xmm3 is now the number we calculate sqroot for, but in floating-point

	while_loop:
		# increment xmm0
		addsd %xmm2, %xmm0
		
		# set xmm1 to xmm0
		movaps %xmm0, %xmm1

		# xmm1 = xmm1 * xmm0
		mulsd %xmm0, %xmm1

		# check if xmm1 <= xmm3
		ucomisd %xmm1, %xmm3
		ja while_loop
	
	addq $8, %rsp
	ret
