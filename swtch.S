# Context switch
#
#   void swtch(struct context **old, struct context *new);
# 
# Save current register context in old
# and then load register context from new.

#include "syscall.h"
#include "traps.h"

//lebels for the implicit_exit
.globl implicit_exit
.globl end_of_exit

.globl swtch
swtch:
  movl 4(%esp), %eax
  movl 8(%esp), %edx

  # Save old callee-save registers
  pushl %ebp
  pushl %ebx
  pushl %esi
  pushl %edi

  # Switch stacks
  movl %esp, (%eax)
  movl %edx, %esp

  # Load new callee-save registers
  popl %edi
  popl %esi
  popl %ebx
  popl %ebp
  ret

//new func - implicit_exit
implicit_exit:
  //pushl %eax			//?????
  //pushl %eax
  movl $SYS_exit, %eax
  int $T_SYSCALL
end_of_exit:
