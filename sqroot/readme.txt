This showcases performance difference between sqroot implementations taken from
https://medium.com/@dev.madhurendra/finding-square-roots-from-basic-iterations-to-advanced-optimizations-4d2d7b8f4777

Using perf to time.

All sqroot implementations take in two args
	1. 4 byte unsigned integer, number of elements in the array
	2. 8 byte pointer, address to a 4 byte unsigned integer.

All sqroot implementations follow System V ABI.
	e.g. Because they are called from main.s, 
		all sqroot functions will subq $8, %rsp to realign the stack pointer to 16 bits

Caller-Saved: rax, rcx, rdx, rsi, rdi, r8-r11, xmm
Callee-Saved: rbx, rbp, r12-r15

Personal conventions:
	Any counters: rcx
