	.text
	.intel_syntax noprefix
	.file	"spectre-pht.c"
	.globl	victim_function_v1              # -- Begin function victim_function_v1
	.p2align	4, 0x90
	.type	victim_function_v1,@function
victim_function_v1:                     # @victim_function_v1
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB0_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB0_2:
	ret
.Lfunc_end0:
	.size	victim_function_v1, .Lfunc_end0-victim_function_v1
                                        # -- End function
	.globl	leakByteLocalFunction           # -- Begin function leakByteLocalFunction
	.p2align	4, 0x90
	.type	leakByteLocalFunction,@function
leakByteLocalFunction:                  # @leakByteLocalFunction
# %bb.0:
	mov	al, byte ptr [esp + 4]
	movzx	eax, byte ptr [esp + 4]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
	ret
.Lfunc_end1:
	.size	leakByteLocalFunction, .Lfunc_end1-leakByteLocalFunction
                                        # -- End function
	.globl	victim_function_v2              # -- Begin function victim_function_v2
	.p2align	4, 0x90
	.type	victim_function_v2,@function
victim_function_v2:                     # @victim_function_v2
# %bb.0:
	sub	esp, 12
	mov	eax, dword ptr [esp + 16]
	mov	eax, dword ptr [esp + 16]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB2_2
# %bb.1:
	mov	eax, dword ptr [esp + 16]
	movzx	eax, byte ptr [eax + publicarray]
	mov	dword ptr [esp], eax
	call	leakByteLocalFunction
.LBB2_2:
	add	esp, 12
	ret
.Lfunc_end2:
	.size	victim_function_v2, .Lfunc_end2-victim_function_v2
                                        # -- End function
	.globl	leakByteNoinlineFunction        # -- Begin function leakByteNoinlineFunction
	.p2align	4, 0x90
	.type	leakByteNoinlineFunction,@function
leakByteNoinlineFunction:               # @leakByteNoinlineFunction
# %bb.0:
	mov	al, byte ptr [esp + 4]
	movzx	eax, byte ptr [esp + 4]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
	ret
.Lfunc_end3:
	.size	leakByteNoinlineFunction, .Lfunc_end3-leakByteNoinlineFunction
                                        # -- End function
	.globl	victim_function_v3              # -- Begin function victim_function_v3
	.p2align	4, 0x90
	.type	victim_function_v3,@function
victim_function_v3:                     # @victim_function_v3
# %bb.0:
	sub	esp, 12
	mov	eax, dword ptr [esp + 16]
	mov	eax, dword ptr [esp + 16]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB4_2
# %bb.1:
	mov	eax, dword ptr [esp + 16]
	movzx	eax, byte ptr [eax + publicarray]
	mov	dword ptr [esp], eax
	call	leakByteNoinlineFunction
.LBB4_2:
	add	esp, 12
	ret
.Lfunc_end4:
	.size	victim_function_v3, .Lfunc_end4-victim_function_v3
                                        # -- End function
	.globl	victim_function_v4              # -- Begin function victim_function_v4
	.p2align	4, 0x90
	.type	victim_function_v4,@function
victim_function_v4:                     # @victim_function_v4
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB5_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	shl	eax, 1
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB5_2:
	ret
.Lfunc_end5:
	.size	victim_function_v4, .Lfunc_end5-victim_function_v4
                                        # -- End function
	.globl	victim_function_v5              # -- Begin function victim_function_v5
	.p2align	4, 0x90
	.type	victim_function_v5,@function
victim_function_v5:                     # @victim_function_v5
# %bb.0:
	push	eax
	mov	eax, dword ptr [esp + 8]
	mov	eax, dword ptr [esp + 8]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB6_6
# %bb.1:
	mov	eax, dword ptr [esp + 8]
	sub	eax, 1
	mov	dword ptr [esp], eax
.LBB6_2:                                # =>This Inner Loop Header: Depth=1
	cmp	dword ptr [esp], 0
	jl	.LBB6_5
# %bb.3:                                #   in Loop: Header=BB6_2 Depth=1
	mov	eax, dword ptr [esp]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
# %bb.4:                                #   in Loop: Header=BB6_2 Depth=1
	mov	eax, dword ptr [esp]
	add	eax, -1
	mov	dword ptr [esp], eax
	jmp	.LBB6_2
.LBB6_5:
	jmp	.LBB6_6
.LBB6_6:
	pop	eax
	ret
.Lfunc_end6:
	.size	victim_function_v5, .Lfunc_end6-victim_function_v5
                                        # -- End function
	.globl	victim_function_v6              # -- Begin function victim_function_v6
	.p2align	4, 0x90
	.type	victim_function_v6,@function
victim_function_v6:                     # @victim_function_v6
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	and	eax, dword ptr [array_size_mask]
	cmp	eax, dword ptr [esp + 4]
	jne	.LBB7_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB7_2:
	ret
.Lfunc_end7:
	.size	victim_function_v6, .Lfunc_end7-victim_function_v6
                                        # -- End function
	.globl	victim_function_v7              # -- Begin function victim_function_v7
	.p2align	4, 0x90
	.type	victim_function_v7,@function
victim_function_v7:                     # @victim_function_v7
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [victim_function_v7.last_x]
	jne	.LBB8_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB8_2:
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB8_4
# %bb.3:
	mov	eax, dword ptr [esp + 4]
	mov	dword ptr [victim_function_v7.last_x], eax
.LBB8_4:
	ret
.Lfunc_end8:
	.size	victim_function_v7, .Lfunc_end8-victim_function_v7
                                        # -- End function
	.globl	victim_function_v8              # -- Begin function victim_function_v8
	.p2align	4, 0x90
	.type	victim_function_v8,@function
victim_function_v8:                     # @victim_function_v8
# %bb.0:
	push	eax
	mov	eax, dword ptr [esp + 8]
	mov	eax, dword ptr [esp + 8]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB9_2
# %bb.1:
	mov	eax, dword ptr [esp + 8]
	add	eax, 1
	mov	dword ptr [esp], eax            # 4-byte Spill
	jmp	.LBB9_3
.LBB9_2:
	xor	eax, eax
	mov	dword ptr [esp], eax            # 4-byte Spill
	jmp	.LBB9_3
.LBB9_3:
	mov	eax, dword ptr [esp]            # 4-byte Reload
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
	pop	eax
	ret
.Lfunc_end9:
	.size	victim_function_v8, .Lfunc_end9-victim_function_v8
                                        # -- End function
	.globl	victim_function_v9              # -- Begin function victim_function_v9
	.p2align	4, 0x90
	.type	victim_function_v9,@function
victim_function_v9:                     # @victim_function_v9
# %bb.0:
	mov	eax, dword ptr [esp + 8]
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 8]
	cmp	dword ptr [eax], 0
	je	.LBB10_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB10_2:
	ret
.Lfunc_end10:
	.size	victim_function_v9, .Lfunc_end10-victim_function_v9
                                        # -- End function
	.globl	victim_function_v10             # -- Begin function victim_function_v10
	.p2align	4, 0x90
	.type	victim_function_v10,@function
victim_function_v10:                    # @victim_function_v10
# %bb.0:
	mov	al, byte ptr [esp + 8]
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB11_4
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [esp + 8]
	cmp	eax, ecx
	jne	.LBB11_3
# %bb.2:
	movzx	ecx, byte ptr [publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB11_3:
	jmp	.LBB11_4
.LBB11_4:
	ret
.Lfunc_end11:
	.size	victim_function_v10, .Lfunc_end11-victim_function_v10
                                        # -- End function
	.globl	mymemcmp                        # -- Begin function mymemcmp
	.p2align	4, 0x90
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
# %bb.0:
	sub	esp, 12
	mov	eax, dword ptr [esp + 24]
	mov	eax, dword ptr [esp + 20]
	mov	eax, dword ptr [esp + 16]
	mov	dword ptr [esp], 0
	mov	eax, dword ptr [esp + 16]
	mov	dword ptr [esp + 8], eax
	mov	eax, dword ptr [esp + 20]
	mov	dword ptr [esp + 4], eax
.LBB12_1:                               # =>This Inner Loop Header: Depth=1
	xor	eax, eax
	cmp	eax, dword ptr [esp + 24]
	jge	.LBB12_6
# %bb.2:                                #   in Loop: Header=BB12_1 Depth=1
	mov	eax, dword ptr [esp + 8]
	movzx	eax, byte ptr [eax]
	mov	ecx, dword ptr [esp + 4]
	movzx	ecx, byte ptr [ecx]
	sub	eax, ecx
	mov	dword ptr [esp], eax
	cmp	eax, 0
	je	.LBB12_4
# %bb.3:
	jmp	.LBB12_6
.LBB12_4:                               #   in Loop: Header=BB12_1 Depth=1
	jmp	.LBB12_5
.LBB12_5:                               #   in Loop: Header=BB12_1 Depth=1
	mov	eax, dword ptr [esp + 8]
	add	eax, 1
	mov	dword ptr [esp + 8], eax
	mov	eax, dword ptr [esp + 4]
	add	eax, 1
	mov	dword ptr [esp + 4], eax
	mov	eax, dword ptr [esp + 24]
	add	eax, -1
	mov	dword ptr [esp + 24], eax
	jmp	.LBB12_1
.LBB12_6:
	mov	eax, dword ptr [esp]
	add	esp, 12
	ret
.Lfunc_end12:
	.size	mymemcmp, .Lfunc_end12-mymemcmp
                                        # -- End function
	.globl	victim_function_v11             # -- Begin function victim_function_v11
	.p2align	4, 0x90
	.type	victim_function_v11,@function
victim_function_v11:                    # @victim_function_v11
# %bb.0:
	sub	esp, 12
	mov	eax, dword ptr [esp + 16]
	mov	eax, dword ptr [esp + 16]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB13_2
# %bb.1:
	mov	eax, dword ptr [esp + 16]
	movzx	ecx, byte ptr [eax + publicarray]
	lea	eax, [publicarray2]
	add	eax, ecx
	lea	ecx, [temp]
	mov	dword ptr [esp], ecx
	mov	dword ptr [esp + 4], eax
	mov	dword ptr [esp + 8], 1
	call	mymemcmp
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB13_2:
	add	esp, 12
	ret
.Lfunc_end13:
	.size	victim_function_v11, .Lfunc_end13-victim_function_v11
                                        # -- End function
	.globl	victim_function_v12             # -- Begin function victim_function_v12
	.p2align	4, 0x90
	.type	victim_function_v12,@function
victim_function_v12:                    # @victim_function_v12
# %bb.0:
	mov	eax, dword ptr [esp + 8]
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	add	eax, dword ptr [esp + 8]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB14_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	add	eax, dword ptr [esp + 8]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB14_2:
	ret
.Lfunc_end14:
	.size	victim_function_v12, .Lfunc_end14-victim_function_v12
                                        # -- End function
	.globl	is_x_safe                       # -- Begin function is_x_safe
	.p2align	4, 0x90
	.type	is_x_safe,@function
is_x_safe:                              # @is_x_safe
# %bb.0:
	push	eax
	mov	eax, dword ptr [esp + 8]
	mov	eax, dword ptr [esp + 8]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB15_2
# %bb.1:
	mov	dword ptr [esp], 1
	jmp	.LBB15_3
.LBB15_2:
	mov	dword ptr [esp], 0
.LBB15_3:
	mov	eax, dword ptr [esp]
	pop	ecx
	ret
.Lfunc_end15:
	.size	is_x_safe, .Lfunc_end15-is_x_safe
                                        # -- End function
	.globl	victim_function_v13             # -- Begin function victim_function_v13
	.p2align	4, 0x90
	.type	victim_function_v13,@function
victim_function_v13:                    # @victim_function_v13
# %bb.0:
	sub	esp, 12
	mov	eax, dword ptr [esp + 16]
	mov	eax, dword ptr [esp + 16]
	mov	dword ptr [esp], eax
	call	is_x_safe
	cmp	eax, 0
	je	.LBB16_2
# %bb.1:
	mov	eax, dword ptr [esp + 16]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB16_2:
	add	esp, 12
	ret
.Lfunc_end16:
	.size	victim_function_v13, .Lfunc_end16-victim_function_v13
                                        # -- End function
	.globl	victim_function_v14             # -- Begin function victim_function_v14
	.p2align	4, 0x90
	.type	victim_function_v14,@function
victim_function_v14:                    # @victim_function_v14
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB17_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	xor	eax, 255
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB17_2:
	ret
.Lfunc_end17:
	.size	victim_function_v14, .Lfunc_end17-victim_function_v14
                                        # -- End function
	.globl	victim_function_v15             # -- Begin function victim_function_v15
	.p2align	4, 0x90
	.type	victim_function_v15,@function
victim_function_v15:                    # @victim_function_v15
# %bb.0:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [eax]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB18_2
# %bb.1:
	mov	eax, dword ptr [esp + 4]
	mov	eax, dword ptr [eax]
	movzx	eax, byte ptr [eax + publicarray]
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
.LBB18_2:
	ret
.Lfunc_end18:
	.size	victim_function_v15, .Lfunc_end18-victim_function_v15
                                        # -- End function
	.type	publicarray_size,@object        # @publicarray_size
	.data
	.globl	publicarray_size
	.p2align	2
publicarray_size:
	.long	16                              # 0x10
	.size	publicarray_size, 4

	.type	publicarray,@object             # @publicarray
	.globl	publicarray
publicarray:
	.ascii	"\000\001\002\003\004\005\006\007\b\t\n\013\f\r\016\017"
	.size	publicarray, 16

	.type	temp,@object                    # @temp
	.bss
	.globl	temp
temp:
	.byte	0                               # 0x0
	.size	temp, 1

	.type	publicarray2,@object            # @publicarray2
	.globl	publicarray2
publicarray2:
	.zero	64
	.size	publicarray2, 64

	.type	array_size_mask,@object         # @array_size_mask
	.data
	.globl	array_size_mask
	.p2align	2
array_size_mask:
	.long	15                              # 0xf
	.size	array_size_mask, 4

	.type	victim_function_v7.last_x,@object # @victim_function_v7.last_x
	.local	victim_function_v7.last_x
	.comm	victim_function_v7.last_x,4,4
	.type	secret,@object                  # @secret
	.bss
	.globl	secret
secret:
	.byte	0                               # 0x0
	.size	secret, 1

	.ident	"Ubuntu clang version 12.0.0-++20210406072642+d28af7c654d8-1~exp1~20210406173427.72"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym leakByteLocalFunction
	.addrsig_sym leakByteNoinlineFunction
	.addrsig_sym mymemcmp
	.addrsig_sym is_x_safe
	.addrsig_sym publicarray_size
	.addrsig_sym publicarray
	.addrsig_sym temp
	.addrsig_sym publicarray2
	.addrsig_sym array_size_mask
	.addrsig_sym victim_function_v7.last_x
	.addrsig_sym secret
