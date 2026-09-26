# Wrapper to call clib implementation of sqrt

.section .text
.global sqroot
.extern sqrt
sqroot:
	subq $8, %rsp
	call sqrt
	addq $8, %rsp
	ret
