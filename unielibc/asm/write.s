.global write
.text
// written by llms
// caution

write:
    movq $1, %rax
    syscall
    ret
    
