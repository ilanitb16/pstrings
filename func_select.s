// 322453200 Ilanit Berditchevski
.section .data
    selected_option: .int 0                     # reserve space for the user number

.section .rodata                              # contains initialized data
    str_invalid:        .string	    "invalid option!\n"
    pstr_length:        .string     "first pstring length: %d, second pstring length: %d\n"
    scan_num:           .string     "%d"
    str_pstrijcpy:      .string     "length: %d, string: %s\n"
    swap_case:          .string	    "length: %d, string: %s\n"


 # align address to multiple of 8
.align 8

.text                                           #the beginnig of the code
.globl	run_func                                #declaring as global so the gcc could find
.type	run_func, @function	                #the label "run_func" representing the beginning of a function

    # void run_func(int option, pstring* p1, pstring* p2)
    # option in %edi, p1 in %rsi, p2 in %rdx
run_func:
    pushq	%rbp	                        #save the old frame pointer
	movq	%rsp, %rbp                      #create the new frame pointer
	subq     $8, %rsp                       #add 8 bytes to the stack

    pushq    %rbx                           #save collee register
    pushq    %r12                           #save collee register
    pushq    %r13                           #save collee register

    movq     %rsi, %rbx                     #copy p1 from %rsi to %rbx
    movq     %rdx, %r12                     #copy p2 from %rdx to %r12

    mov %edi, %edx

    cmp $31, %edx                             # compare numbers case 31
    je .L_pstrlen

    cmp $33, %edx                             # compare numbers case 33
    je .L_swap_case

    cmp $34, %edx                             # compare numbers case 34
    je .L_pstrijcpy

    jmp .L_terminate

.L_pstrlen:
    movq    %rbx, %rdi                      #pass p1 to pstrlen in %rdi,  (first argument to a func is passed in %rdi).
    call    pstrlen                         #call: char pstrlen(Pstring* pstr).

    #result of pstrlen is stored in %rax.
    #%al is the lower 8 bits of the %rax register.
    movb    %al, (%rsp)                     #store val in %al as single byte at memory location pointed by stack pointer

    movq    %r12, %rdi                      #pass to pstrlen the value of p2 from %r12
    call    pstrlen                         #call: char pstrlen(Pstring* pstr).

    # zero-extend %al to fill the entire 32-bit %edx register
    movzbl   %al, %edx                      #save in %edx the length of p2
    movzbl   (%rsp), %esi                   #save in %esi the length of p1

    movq    $pstr_length, %rdi              # pstr_length first param passed to printf

    # printf is "varargs", must zero out the al register (the low 8 bits of eax/rax)
    xorq	%rax, %rax                      # %rax = 0 (xoring value by itself = zero)
    xor    %eax, %eax

    call	printf	                        #call to printf after passing its parameters.
    jmp      .Done

.L_swap_case:
    movq    %rbx, %rdi                      #pass to swapCase p1 by %rdi
    call    swapCase                        #call: Pstring* swapCase(Pstring* pstr),

    movq    %r12, %rdi                      #pass to swapCase p2 by %rdi
    call    swapCase                        #call: Pstring* swapCase(Pstring* pstr) with %rdi

    movq    %rbx, %rdi                      #pass to pstrlen p1 using %rdi
    call    pstrlen                         #call: char pstrlen(Pstring* pstr) with %rdi

    movq	$swap_case, %rdi                #passing string to printf function
    movzbl  %al, %esi                       #PASS LENGTH OF P1 to PRINTF (part of %rsi)
    leaq    1(%rbx), %rdx                   #address of memory location pointed by %rbx + 1
                                            #store result in the %rdx register.PASS P1 to PRINTF

    xorq	%rax, %rax                      # %rax = 0
    call	printf	                        #call to printf passing parameters.

    movq    %r12, %rdi                      #pass to pstrlen p2 by %rdi
    call    pstrlen                         #call: char pstrlen(Pstring* pstr) result stored in %al

    movq	$swap_case, %rdi                #the swap_case is the first paramter passed to the printf function
    movzbl  %al, %esi                       #PASS LENGTH OF P2 to PRINTF
    leaq    1(%r12), %rdx                   #pass P2 from %r12 (skip the first character: size char)
    xorq	%rax, %rax                      # %rax = 0
    call	printf	                        #call to printf after passing its parameters.
    jmp      .Done



.Done:
        addq     $8, %rsp                       #deallocate 8 bytes from the stack
        popq     %r13                           #get the collee value back
        popq	%r12                            #get the collee value back
        popq	%rbx                            #get the collee value back
        movq	%rbp, %rsp                      #restore the old stack pointer - release all used memory.
        popq	%rbp	                        #restore old frame pointer (the caller function frame)
        ret		                                #return to caller function


# passing p1 in %rdi, passing p2 in %rsi, passing i in %rdx (%dl because its a char => 8 bits), passing j in %cl (%rcx)
.L_pstrijcpy:

        #get the /n from the last scanf.
        movq    $0, %rax                        #clear rax register
        leaq   (%rsp), %rsi                 # overrite the option of the switch case
        movq    $scan_num, %rdi             # load format string
        call    scanf                       #pass the pointer address of stack (%rsp) = address of i. (to scanf)

        movq    $0, %rax                        #clear rax register
        movq    $scan_num, %rdi                 #first paramter passed to the scanf is in %rdi
        leaq    4(%rsp), %rsi                   #pass pointer address of rsp + 4 (stack) = address of j. (to scanf)
        call    scanf                           #call to scanf after passing its parameters.

        movq    %rbx, %rdi                      #pass p1 to dst in pstrijcpy
        movq    %r12, %rsi                      #pass p2 to src in pstrijcpy
        movb    (%rsp), %dl                     #pass i from stack to pstrijcpy
        movb    4(%rsp), %cl                    #pass j from stack to pstrijcpy
        call    pstrijcpy                       #Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)

        movq    %rbx, %rdi                      #pass to pstrlen p1 by %rdi
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)

        movq	$str_pstrijcpy, %rdi            #string passed to printf function
        movzbl  %al, %esi                       #pass length of p1 to printf
        leaq    1(%rbx), %rdx                   #pass to p1 (not including first size char)
        movq    $0, %rax                        #clear rax register
	    call	printf	                        #call to printf AFTER we passed its parameters.

        movq    %r12, %rdi                      #pass p1 to pstrlen
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)

        movq	$str_pstrijcpy, %rdi            #string passed to printf function
        movzbl  %al, %esi                       #pass length of p2 to printf
        leaq    1(%r12), %rdx                   #pass to p1 (not including first size char)
        movq    $0, %rax                        #clear rax register
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp     .Done



.L_terminate:
    movq    $str_invalid, %rdi                  #passing invalid option string to %rdi
    xorq    %rax,   %rax                        # zeroing %rax
    call    printf                              #printing the option is not valid
    jmp     .Done