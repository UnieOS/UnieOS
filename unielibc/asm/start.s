.global _start
.text
.extern main
// written by llms
// caution

_start:
    call main
    movq %rax, %rdi
    movq $60, %rax
    syscall
    
