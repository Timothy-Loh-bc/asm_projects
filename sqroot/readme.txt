This showcases performance difference between sqroot implementations taken from
https://medium.com/@dev.madhurendra/finding-square-roots-from-basic-iterations-to-advanced-optimizations-4d2d7b8f4777

Using perf to time.

All sqroot implementations take in just one arg.
	1. Value to square root in xmm0

All sqroot implementations follow System V ABI.
	e.g. Because they are called from main.s, 
		all sqroot functions will subq $8, %rsp to realign the stack pointer to 16 bits

Caller-Saved: rax, rcx, rdx, rsi, rdi, r8-r11, xmm
Callee-Saved: rbx, rbp, r12-r15

Personal conventions:
	Any counters: rcx
