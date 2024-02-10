// 322453200 Ilanit Berditchevski
.section .rodata
    str_invalid_input:        .string	"invalid input!\n"


.text	                                        #the beginnig of the code
.globl	pstrlen
.type	pstrlen, @function	                # label "pstrlen" meaning the beginning of a function
# char pstrlen(Pstring* pstr)
# p1 in %rdi
pstrlen:                            	        # the pstrlen function:
	    movb   (%rdi), %al                      # load from memory at the address pointed to by %rdi
	                                            #and store it in the lower 8 bits of %al. return size of pstring

	    ret                                     #return to caller function

.globl	pstrijcpy
.type	pstrijcpy, @function	            # the label "pstrijcpy" representing the beginning of a function
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
# p1 in %rdi, p2 in %rsi, i in %dl, j in %cl
pstrijcpy:
        pushq	%rbp	                        #save the old frame pointer
        movq	%rsp, %rbp                      #create the new frame pointer

        xorq    %r8, %r8                        # %r8 = 0
	    movb   (%rdi), %r8b                     # len(p1) passed to %r8b
        xorq    %r9, %r9                        # %r9 = 0
	    movb   (%rsi), %r9b                     # len(p2) passed to %r9b

        cmpb    %dl, %cl                        #compare j : i
        jb      .Error2                         #if j < i, do Error2

        cmpb    %dl, %r8b                       #compare len(p1) : i
        jbe      .Error2                        #if len(p1) <= i, do Error2

        cmpb    %dl, %r9b                       #compare len(p2) : i
        jbe      .Error2                        #if len(p2) <= i, then Error2

        cmpb    %cl, %r8b                       #compare len(p1) : j
        jbe      .Error2                        #if len(p1) <= j, then Error2

        cmpb    %cl, %r9b                       #compare len(p2) : j
        jbe      .Error2                        #if len(p2) <= j, then Error2

        movzbq  %dl, %rdx                       #add 0's in the end of %dl

.While2:
        cmpb    %dl, %cl                        #compare j : i
        jb      .Done2                          #if j < i, then Done2
        movb    1(%rsi, %rdx), %r8b             #move p1[i+1] to temp
        movb    %r8b, 1(%rdi, %rdx)             #move temp to p2[i+1]
        incb    %dl                             #compute i = i + 1
        jmp     .While2

.Error2:
        #.align 8
        xorq    %rsi, %rsi
        xorq	%rax, %rax

        movq    %rdi, %rbx                      #return p1
        movq	$str_invalid_input, %rdi        #the str_invalid passed to printf

        call	printf	                        #call to printf AFTER we passed its parameters.
        jmp     .Done2


.Done2:
      #  movq    %rdi, %rbx                      #return p1
        movq	%rbp, %rsp                      #restore the old stack pointer - release all used memory.
        popq	%rbp
	    ret		                                #return to caller function


.globl	swapCase
	.type	swapCase, @function	                #the label "swapCase" representing the beginning of a function
# Pstring* swapCase(Pstring* pstr)
# p1 in %rdi
swapCase:	                                    #the run_main function: rdi
        xorq    %rax, %rax                      #compute i = 0
	    movb   (%rdi), %al                      #get the first size char of a pstring p1 in i

.While3:
        cmpb    $0, %al                         #compare i : 0
        je      .Done3                          #if i = 0, then Done3
        movb    (%rdi, %rax), %dl               #move p1[i] to c1
        cmpb    $122, %dl                       #compare c1 : 122 (the last letter in english in ascii - z)
        ja      .Next3                          #if c1 > 122, then Next3 (not a letter in english)
        cmpb    $65, %dl                        #compare c1 : 65 (the first letter in english in ascii - A)
        jb      .Next3                          #if c1 < 65, then Next3 (not a letter in english)
        cmpb    $91, %dl                        #compare c1 : 91 (the last upper letter in english in ascii)
        jb      .Upper_Case                     #if c1 < 91, then it is a upperCase
        cmpb    $96, %dl                        #compare c1 : 96 (the first lower letter in english in ascii)
        ja      .Lower_Case                     #if c1 > 96, then it is a lowerCase
        jmp     .Next3

.Lower_Case:
        subb    $32, %dl                        #compute c1 - 32 (from lower to upper)
        movb    %dl, (%rdi, %rax)               #move the upper back to p[i]
        jmp     .Next3

.Upper_Case:
        addb    $32, %dl                        #compute c1 + 32 (from upper to lower)
        movb    %dl, (%rdi, %rax)               #move the lower back to p[i]

.Next3:
        decb    %al                             #compute i = i - 1
        jmp     .While3


.Done3:
        movq    %rdi, %rax                      #return p1
	    ret		                                #return to caller function

