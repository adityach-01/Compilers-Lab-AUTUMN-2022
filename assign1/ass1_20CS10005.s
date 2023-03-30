	# Aditya Choudhary, 20CS10005
	
	.file	"asgn1.c"
	.text
	.section	.rodata
	.align 8
	# allocating address to the strings
.LC0:
	.string	"Enter the string (all lower case): "
.LC1:
	.string	"%s"
.LC2:
	.string	"Length of the string: %d\n"
	.align 8
.LC3:
	.string	"The string in descending order: %s\n"

	# starting the text section
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64

	pushq	%rbp                     # saving the current base pointer in the stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp               # save the current stack pointer in the rbp register for accessing local variables and function arguments
	.cfi_def_cfa_register 6
	subq	$80, %rsp                # create space for local variables and function arguments
	movq	%fs:40, %rax             # pushing stack-guard value in stack
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax               # clear eax register
	leaq	.LC0(%rip), %rdi         # move the address of .LC0 to rdi register for print function
	movl	$0, %eax                 # eax <- 0
	call	printf@PLT               # print string at .LC0
	leaq	-64(%rbp), %rax          # rax = rbp - 64 (starting address of str (&str[0]) is now stored in rax)
	movq	%rax, %rsi               # rsi(second argument of the function) <- address of str
	leaq	.LC1(%rip), %rdi         # rdi(first argument of the function) <- address of .LC1 (%s)
	movl	$0, %eax                 # eax <- 0
	call	__isoc99_scanf@PLT       # calling scanf

	# setting up arguments for length function
	leaq	-64(%rbp), %rax          # rax = rbp - 64
	movq	%rax, %rdi               # rdi (1st argument of the function) <- rbp-64 (str)
	call	length                   # calling length subroutine


	movl	%eax, -68(%rbp)          # len returned in eax, then storing it in physical memory space at (rbp-68)
	movl	-68(%rbp), %eax          # eax <- len

	# setting arguments for printf
	movl	%eax, %esi               # esi (2nd argument of the function) <- len
	leaq	.LC2(%rip), %rdi         # rdi (1st argument of the function) <- .LC2
	movl	$0, %eax                 # eax <- 0
	call	printf@PLT               # calling printf

	# setting up arguments for sort
	leaq	-32(%rbp), %rdx          # rdx (3rd argument of the function) <- rbp-32 (address of starting of string dest (&dest[0]) )
	movl	-68(%rbp), %ecx          # ecx <- len
	leaq	-64(%rbp), %rax          # rax = rbp - 64 (&str[0])
	movl	%ecx, %esi               # esi (2nd argument of the function) <- ecx (len)
	movq	%rax, %rdi               # rdi (1st argument of the function) <- rax (&str[0])
	call	sort                     # calling sort

	# setting up arguments for printf
	leaq	-32(%rbp), %rax          # rax <- rbp-32 (&dest[0])
	movq	%rax, %rsi               # rsi (2nd argument of a function) <- rax (&dest[0])
	leaq	.LC3(%rip), %rdi         # rdi (1st argument of a function) <- .LC3
	movl	$0, %eax                 # eax <- 0
	call	printf@PLT               # calling print 
	movl	$0, %eax                 # eax <- 0
	movq	-8(%rbp), %rcx           # rcx <- %fs:40
	xorq	%fs:40, %rcx             # performing stack check, if zero go to .L3, else call stack check fail subroutine	
	je	.L3
	call	__stack_chk_fail@PLT

.L3:
	leave
	.cfi_def_cfa 7, 8
	ret                              # end of subroutine main
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	length
	.type	length, @function

# length subroutine
length:
# function begins
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp                    # preserve current frame pointer in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp              # set the rbs register value equal to stack pointer for accessing local variables
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)         # storing the string address (&str[0]) in physical memory of the subroutine at (rbp-24). rdi contains the 1st argujment to a function, hence it contains &str[0]/ starting address of string
	movl	$0, -4(%rbp)            # i = 0
	jmp	.L5
.L6:
	addl	$1, -4(%rbp)            # i++
.L5:
	movl	-4(%rbp), %eax          # eax <- i
	movslq	%eax, %rdx              # rdx <- eax along with sign extension
	movq	-24(%rbp), %rax         # rax <- &str[0]
	addq	%rdx, %rax              # rax = rax + i, rax = &str[0] + i, points to the ith character in the string
	movzbl	(%rax), %eax            # eax = *(str+i)
	testb	%al, %al                # if the bitwise AND of the Least significant 8 bits of %eax register is not zero, then jump to .L6
	jne	.L6                         # jump if Z flag != 0, Z flag becomes 1 when the result of the previous operation is 0.
	movl	-4(%rbp), %eax          # put final i (length of the string) in eax register
	popq	%rbp                    # pop back the old frame pointer
	.cfi_def_cfa 7, 8
	ret                             # return from the subroutine to the address pushed in the stack
	.cfi_endproc

# function ends
.LFE1:
	.size	length, .-length
	.globl	sort
	.type	sort, @function

# sort subroutine
sort:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp                    # preserve the current frame pointer by pushing in the stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp              # rbp <- rsp, holding the current stack frame
	.cfi_def_cfa_register 6
	subq	$48, %rsp               # creating space for local variables
	movq	%rdi, -24(%rbp)         # %rdi hold the 1st argument of the function,*(rbp-24) <- address of str (&str[0]) 
	movl	%esi, -28(%rbp)         # 2nd argument of function, *(rbp-28) <- len
	movq	%rdx, -40(%rbp)         # 3rd argument of function, *(rbp-40) <- address of dest (&dest[0])
	movl	$0, -8(%rbp)            # i <- 0
	jmp	.L9                         # jump to .L9
.L13:
	movl	$0, -4(%rbp)            # j <- 0
	jmp	.L10                        # jump to .L10	
.L12:
	movl	-8(%rbp), %eax          # eax <- i
	movslq	%eax, %rdx              # rdx <- eax with sign bit extension, rdx <- i
	movq	-24(%rbp), %rax         # rax <- str, adderess of the 1st character of string (&str[0])
	addq	%rdx, %rax              # rax += rdx, rax = &str[i]
	movzbl	(%rax), %edx            # edx <- str[i]
	movl	-4(%rbp), %eax          # eax <- j
	movslq	%eax, %rcx              # rcx <- eax with sign bit extension, rcx <- j
	movq	-24(%rbp), %rax         # rax <- str, address of 1st character of the string 
	addq	%rcx, %rax              # rax += rcx, rax = &str[j]
	movzbl	(%rax), %eax            # eax <- str[j]
	cmpb	%al, %dl                # if edx >= eax, ie. str[i] >= str[j], then go to .L11, else skip next instruction
									# only lower 8 bits are used as we are comparing only the character, which only occupy 8 bits
	jge	.L11                        # jump if than greater equal
	movl	-8(%rbp), %eax          # eax <- i
	movslq	%eax, %rdx              # rdx <- i
	movq	-24(%rbp), %rax         # rax <- str
	addq	%rdx, %rax              # rax += rdx, rax = &str[i]
	movzbl	(%rax), %eax            # eax <- str[i]
	movb	%al, -9(%rbp)           # *(rbp-9) <- str[i], only 8 bits needed, or temp = str[i]
	movl	-4(%rbp), %eax          # eax <- j
	movslq	%eax, %rdx              # rdx <- j
	movq	-24(%rbp), %rax         # rax <- str
	addq	%rdx, %rax              # rax <- &str[j]
	movl	-8(%rbp), %edx          # edx <- i
	movslq	%edx, %rcx              # rcx <- i
	movq	-24(%rbp), %rdx         # rdx <- str
	addq	%rcx, %rdx              # rdx += rcx, rdx = &str[i]
	movzbl	(%rax), %eax            # eax <- str[j]
	movb	%al, (%rdx)             # str[i] = str[j], only 8 bits needed
	movl	-4(%rbp), %eax          # eax <- j
	movslq	%eax, %rdx              # rdx <- j
	movq	-24(%rbp), %rax         # rax <- str
	addq	%rax, %rdx              # rdx <- &str[j]
	movzbl	-9(%rbp), %eax          # eax <- str[i] (temp)
	movb	%al, (%rdx)             # str[j] = temp, only 8 bits neededm, hence only %al can be used
.L11:
	addl	$1, -4(%rbp)               # j++
.L10:
	movl	-4(%rbp), %eax             # eax <- j
	cmpl	-28(%rbp), %eax            # if len > j, jump to .L12, else skip next instruction. *(rbp-28) contains len and %eax contains j
	jl	.L12
	addl	$1, -8(%rbp)               # i++
.L9:
	movl	-8(%rbp), %eax             # eax <- i
	cmpl	-28(%rbp), %eax			   # if eax < *(rbp-28), then jump to .L13 (len > i)
	jl	.L13                           # performs a signed comparison jump after a test

	# setting up arguments for calling reverse subroutine
	movq	-40(%rbp), %rdx            # rdx <- dest, pointer to the beginning of dest array, 3rd argument of reverse function
	movl	-28(%rbp), %ecx            # ecx <- len
	movq	-24(%rbp), %rax            # rax <- str, pointer to the beginning of str array
	movl	%ecx, %esi                 # esi <- len, 2nd argument of reverse function
	movq	%rax, %rdi                 # rdi <- str, 1st argument of reverse function
	call	reverse                    # calling reverse subroutine
	nop                                # do nothing
	leave
	.cfi_def_cfa 7, 8
	ret                                # return from the subroutine
	.cfi_endproc
	
.LFE2:
	.size	sort, .-sort
	.globl	reverse
	.type	reverse, @function

	# reverse subroutine

reverse:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp                      # saving the previous frame pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp                # setting the current frame pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)           # *(rbp-24) = str
	movl	%esi, -28(%rbp)           # *(rbp-28) = len
	movq	%rdx, -40(%rbp)           # *(rbp-40) = rdx 
	movl	$0, -8(%rbp)              # i <- 0
	jmp	.L15                          # jump to .L15
	
	# inner for loop                      
.L20:
	movl	-28(%rbp), %eax           # eax <- len
	subl	-8(%rbp), %eax            # eax <- len-i
	subl	$1, %eax                  # eax = len-i-1
	movl	%eax, -4(%rbp)            # j = len-i-1
	nop                               # do nothing
	movl	-28(%rbp), %eax           # eax <- len
	movl	%eax, %edx                # edx <- len
	shrl	$31, %edx                 # get the sign bit of len
	addl	%edx, %eax                # eax <- len + sign-bit of len (0 if len >= 0)
	sarl	%eax                      # eax <- eax/2 = len/2
	cmpl	%eax, -4(%rbp)            # if j < len/2, then jump to .L18, else skip next instruction
	jl	.L18 
	movl	-8(%rbp), %eax            # eax <- i
	cmpl	-4(%rbp), %eax            # set flags after calculating (i-j) 
	je	.L23                          # if i == j, then jump to .L23, ie break the inner for loop
	movl	-8(%rbp), %eax            # eax <- i
	movslq	%eax, %rdx                # rdx <- i
	movq	-24(%rbp), %rax           # rax <- str
	addq	%rdx, %rax                # rax = &str[i]
	movzbl	(%rax), %eax              # eax = str[i]
	movb	%al, -9(%rbp)             # temp = str[i], only lower 8 bits necessary as we store characters
	movl	-4(%rbp), %eax            # eax <- j
	movslq	%eax, %rdx                # rdx <- j
	movq	-24(%rbp), %rax           # rax <- str
	addq	%rdx, %rax                # rax <- &str[j]
	movl	-8(%rbp), %edx            # edx <- i
	movslq	%edx, %rcx                # rcx <- i
	movq	-24(%rbp), %rdx           # rdx <- str
	addq	%rcx, %rdx                # rdx <- &str[i]
	movzbl	(%rax), %eax              # eax <- str[j]
	movb	%al, (%rdx)               # str[i] <- str[j]
	movl	-4(%rbp), %eax            # eax <- j
	movslq	%eax, %rdx                # rdx <- j
	movq	-24(%rbp), %rax           # rax <- str
	addq	%rax, %rdx                # rdx <- &str[j]
	movzbl	-9(%rbp), %eax            # eax = temp (str[i])
	movb	%al, (%rdx)               # str[j] = temp
	jmp	.L18                          # break, go to inner for loop
.L23:
	nop                               # do nothing

	# outer for loop
.L18:
	addl	$1, -8(%rbp)              # i++
.L15:
	movl	-28(%rbp), %eax           # eax <- len
	movl	%eax, %edx                # edx <- len
	shrl	$31, %edx                 # get sign bit of len
	addl	%edx, %eax                # add sign bit to len
	sarl	%eax                      # eax <- len/2;
	cmpl	%eax, -8(%rbp)            # if i < len/2, then jump to .L20, else skip next instruction
	jl	.L20                          # jump to .L20, go to inner for loop
	movl	$0, -8(%rbp)              # i = 0, initialising i = 0 for the last for loop in reverse function
	jmp	.L21                          # jump to .L21, assign values to the dest string
.L22:
	movl	-8(%rbp), %eax            # eax <- i
	movslq	%eax, %rdx                # rdx <- i
	movq	-24(%rbp), %rax           # rax <- str
	addq	%rdx, %rax                # rax <- &str[i]
	movl	-8(%rbp), %edx            # edx <- i
	movslq	%edx, %rcx                # rcx <- i
	movq	-40(%rbp), %rdx           # rdx <- dest
	addq	%rcx, %rdx                # rdx <- &dest[i]
	movzbl	(%rax), %eax              # eax <- str[i] 
	movb	%al, (%rdx)               # dest[i] = str[i]
	addl	$1, -8(%rbp)              # i++
.L21:
	movl	-8(%rbp), %eax            # eax <- i
	cmpl	-28(%rbp), %eax           # if i < len, then jump to .L22, else skip the next instruction
	jl	.L22
	nop
	nop
	popq	%rbp                      # load the previous frame pointer
	.cfi_def_cfa 7, 8
	ret                               # return from the reverse subroutine
	.cfi_endproc
.LFE3:
	.size	reverse, .-reverse
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
