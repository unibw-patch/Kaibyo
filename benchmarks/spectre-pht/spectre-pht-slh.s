	.text
	.intel_syntax noprefix
	.file	"spectre-pht.c"
	.globl	victim_function_v1              # -- Begin function victim_function_v1
	.p2align	4, 0x90
	.type	victim_function_v1,@function
victim_function_v1:                     # @victim_function_v1
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 32]
	mov	eax, dword ptr [esp + 32]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB0_3
	jmp	.LBB0_1
.LBB0_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB0_2
.LBB0_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB0_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end0:
	.size	victim_function_v1, .Lfunc_end0-victim_function_v1
                                        # -- End function
	.globl	victim_function_v4              # -- Begin function victim_function_v4
	.p2align	4, 0x90
	.type	victim_function_v4,@function
victim_function_v4:                     # @victim_function_v4
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 32]
	mov	eax, dword ptr [esp + 32]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB1_3
	jmp	.LBB1_1
.LBB1_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB1_2
.LBB1_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	shl	ecx, 1
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB1_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end1:
	.size	victim_function_v4, .Lfunc_end1-victim_function_v4
                                        # -- End function
	.globl	victim_function_v5              # -- Begin function victim_function_v5
	.p2align	4, 0x90
	.type	victim_function_v5,@function
victim_function_v5:                     # @victim_function_v5
# %bb.0:
	sub	esp, 52
	mov	rax, -1
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 40], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 56]
	mov	eax, dword ptr [esp + 56]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB2_7
	jmp	.LBB2_1
.LBB2_7:
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 40]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	jmp	.LBB2_6
.LBB2_1:
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 40]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 56]
	sub	ecx, 1
	mov	dword ptr [esp + 48], ecx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
.LBB2_2:                                # =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	cmp	dword ptr [esp + 48], 0
	jl	.LBB2_5
# %bb.3:                                #   in Loop: Header=BB2_2 Depth=1
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovl	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	mov	ecx, dword ptr [esp + 48]
	movzx	ecx, byte ptr [ecx + publicarray]
	or	eax, ecx
	movzx	ecx, byte ptr [eax + publicarray2]
	movzx	eax, byte ptr [temp]
	and	eax, ecx
                                        # kill: def $al killed $al killed $eax
	mov	byte ptr [temp], al
# %bb.4:                                #   in Loop: Header=BB2_2 Depth=1
	mov	rax, qword ptr [esp]            # 8-byte Reload
	mov	ecx, dword ptr [esp + 48]
	add	ecx, -1
	mov	dword ptr [esp + 48], ecx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB2_2
.LBB2_5:
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovge	rax, rcx
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	jmp	.LBB2_6
.LBB2_6:
	mov	rax, qword ptr [esp + 24]       # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 52
	ret
.Lfunc_end2:
	.size	victim_function_v5, .Lfunc_end2-victim_function_v5
                                        # -- End function
	.globl	victim_function_v6              # -- Begin function victim_function_v6
	.p2align	4, 0x90
	.type	victim_function_v6,@function
victim_function_v6:                     # @victim_function_v6
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 32]
	mov	eax, dword ptr [esp + 32]
	and	eax, dword ptr [array_size_mask]
	cmp	eax, dword ptr [esp + 32]
	jne	.LBB3_3
	jmp	.LBB3_1
.LBB3_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmove	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB3_2
.LBB3_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovne	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB3_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end3:
	.size	victim_function_v6, .Lfunc_end3-victim_function_v6
                                        # -- End function
	.globl	victim_function_v7              # -- Begin function victim_function_v7
	.p2align	4, 0x90
	.type	victim_function_v7,@function
victim_function_v7:                     # @victim_function_v7
# %bb.0:
	sub	esp, 44
	mov	rax, -1
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 48]
	mov	eax, dword ptr [esp + 48]
	cmp	eax, dword ptr [victim_function_v7.last_x]
	jne	.LBB4_5
	jmp	.LBB4_1
.LBB4_5:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	cmove	rax, rcx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB4_2
.LBB4_1:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	cmovne	rax, rcx
	mov	ecx, dword ptr [esp + 48]
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
.LBB4_2:
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	eax, dword ptr [esp + 48]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB4_6
	jmp	.LBB4_3
.LBB4_6:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB4_4
.LBB4_3:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 48]
	mov	dword ptr [victim_function_v7.last_x], ecx
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB4_4:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 44
	ret
.Lfunc_end4:
	.size	victim_function_v7, .Lfunc_end4-victim_function_v7
                                        # -- End function
	.globl	victim_function_v8              # -- Begin function victim_function_v8
	.p2align	4, 0x90
	.type	victim_function_v8,@function
victim_function_v8:                     # @victim_function_v8
# %bb.0:
	sub	esp, 36
	mov	rax, -1
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 40]
	mov	eax, dword ptr [esp + 40]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB5_2
# %bb.1:
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	cmovae	rcx, rax
	mov	eax, dword ptr [esp + 40]
	add	eax, 1
	mov	qword ptr [esp], rcx            # 8-byte Spill
	mov	dword ptr [esp + 12], eax       # 4-byte Spill
	jmp	.LBB5_3
.LBB5_2:
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	cmovb	rcx, rax
	xor	eax, eax
	mov	qword ptr [esp], rcx            # 8-byte Spill
	mov	dword ptr [esp + 12], eax       # 4-byte Spill
	jmp	.LBB5_3
.LBB5_3:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	mov	ecx, dword ptr [esp + 12]       # 4-byte Reload
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	shl	rax, 47
	or	rsp, rax
	add	esp, 36
	ret
.Lfunc_end5:
	.size	victim_function_v8, .Lfunc_end5-victim_function_v8
                                        # -- End function
	.globl	victim_function_v10             # -- Begin function victim_function_v10
	.p2align	4, 0x90
	.type	victim_function_v10,@function
victim_function_v10:                    # @victim_function_v10
# %bb.0:
	sub	esp, 44
	mov	rax, -1
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
	mov	al, byte ptr [esp + 52]
	mov	eax, dword ptr [esp + 48]
	mov	eax, dword ptr [esp + 48]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB6_5
	jmp	.LBB6_1
.LBB6_5:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB6_4
.LBB6_1:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	cmovae	rax, rcx
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	ecx, dword ptr [esp + 48]
	movzx	ecx, byte ptr [ecx + publicarray]
	or	eax, ecx
	movzx	ecx, byte ptr [esp + 52]
	cmp	eax, ecx
	jne	.LBB6_6
	jmp	.LBB6_2
.LBB6_6:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmove	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB6_3
.LBB6_2:
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovne	rax, rcx
	movzx	edx, byte ptr [publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB6_3:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB6_4
.LBB6_4:
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 44
	ret
.Lfunc_end6:
	.size	victim_function_v10, .Lfunc_end6-victim_function_v10
                                        # -- End function
	.globl	mymemcmp                        # -- Begin function mymemcmp
	.p2align	4, 0x90
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
# %bb.0:
	sub	esp, 60
	mov	rax, -1
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	ecx, dword ptr [esp + 72]
	mov	ecx, dword ptr [esp + 68]
	mov	ecx, dword ptr [esp + 64]
	mov	dword ptr [esp + 48], 0
	mov	ecx, dword ptr [esp + 64]
	mov	dword ptr [esp + 56], ecx
	mov	ecx, dword ptr [esp + 68]
	mov	dword ptr [esp + 52], ecx
	mov	qword ptr [esp + 40], rax       # 8-byte Spill
.LBB7_1:                                # =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [esp + 40]       # 8-byte Reload
	mov	qword ptr [esp + 24], rax       # 8-byte Spill
	xor	eax, eax
	cmp	eax, dword ptr [esp + 72]
	jge	.LBB7_7
	jmp	.LBB7_2
.LBB7_7:
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 24]       # 8-byte Reload
	cmovl	rax, rcx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB7_6
.LBB7_2:                                #   in Loop: Header=BB7_1 Depth=1
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	mov	rcx, qword ptr [esp + 24]       # 8-byte Reload
	cmovge	rcx, rax
	mov	qword ptr [esp + 8], rcx        # 8-byte Spill
	mov	eax, dword ptr [esp + 56]
	movzx	edx, byte ptr [eax]
	mov	eax, ecx
	or	eax, edx
	mov	edx, dword ptr [esp + 52]
	movzx	edx, byte ptr [edx]
	or	ecx, edx
	sub	eax, ecx
	mov	dword ptr [esp + 48], eax
	cmp	eax, 0
	je	.LBB7_4
# %bb.3:
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmove	rax, rcx
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	jmp	.LBB7_6
.LBB7_4:                                #   in Loop: Header=BB7_1 Depth=1
	mov	rcx, qword ptr [esp + 32]       # 8-byte Reload
	mov	rax, qword ptr [esp + 8]        # 8-byte Reload
	cmovne	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB7_5
.LBB7_5:                                #   in Loop: Header=BB7_1 Depth=1
	mov	rax, qword ptr [esp]            # 8-byte Reload
	mov	ecx, dword ptr [esp + 56]
	add	ecx, 1
	mov	dword ptr [esp + 56], ecx
	mov	ecx, dword ptr [esp + 52]
	add	ecx, 1
	mov	dword ptr [esp + 52], ecx
	mov	ecx, dword ptr [esp + 72]
	add	ecx, -1
	mov	dword ptr [esp + 72], ecx
	mov	qword ptr [esp + 40], rax       # 8-byte Spill
	jmp	.LBB7_1
.LBB7_6:
	mov	rcx, qword ptr [esp + 16]       # 8-byte Reload
	mov	eax, dword ptr [esp + 48]
	shl	rcx, 47
	or	rsp, rcx
	add	esp, 60
	ret
.Lfunc_end7:
	.size	mymemcmp, .Lfunc_end7-mymemcmp
                                        # -- End function
	.globl	victim_function_v11             # -- Begin function victim_function_v11
	.p2align	4, 0x90
	.type	victim_function_v11,@function
victim_function_v11:                    # @victim_function_v11
# %bb.0:
	push	esi
	sub	esp, 56
	mov	rax, -1
	mov	qword ptr [esp + 40], rax       # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 48], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 64]
	mov	eax, dword ptr [esp + 64]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB8_3
	jmp	.LBB8_1
.LBB8_3:
	mov	rcx, qword ptr [esp + 40]       # 8-byte Reload
	mov	rax, qword ptr [esp + 48]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
	jmp	.LBB8_2
.LBB8_1:
	mov	rcx, qword ptr [esp + 40]       # 8-byte Reload
	mov	rax, qword ptr [esp + 48]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 64]
	movzx	ecx, byte ptr [ecx + publicarray]
	mov	edx, eax
	or	edx, ecx
	lea	ecx, [publicarray2]
	add	ecx, edx
	lea	edx, [temp]
	mov	dword ptr [esp], edx
	mov	dword ptr [esp + 4], ecx
	mov	dword ptr [esp + 8], 1
	shl	rax, 47
	or	rsp, rax
	mov	rax, offset .Lslh_ret_addr0
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	call	mymemcmp
.Lslh_ret_addr0:
	mov	rsi, qword ptr [esp + 16]       # 8-byte Reload
	mov	rdx, qword ptr [esp + 40]       # 8-byte Reload
	mov	rcx, rsp
	sar	rcx, 63
	cmp	rsi, offset .Lslh_ret_addr0
	cmovne	rcx, rdx
	mov	qword ptr [esp + 24], rcx       # 8-byte Spill
	mov	ecx, eax
	mov	rax, qword ptr [esp + 24]       # 8-byte Reload
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp + 32], rax       # 8-byte Spill
.LBB8_2:
	mov	rax, qword ptr [esp + 32]       # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 56
	pop	esi
	ret
.Lfunc_end8:
	.size	victim_function_v11, .Lfunc_end8-victim_function_v11
                                        # -- End function
	.globl	victim_function_v12             # -- Begin function victim_function_v12
	.p2align	4, 0x90
	.type	victim_function_v12,@function
victim_function_v12:                    # @victim_function_v12
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 36]
	mov	eax, dword ptr [esp + 32]
	mov	eax, dword ptr [esp + 32]
	add	eax, dword ptr [esp + 36]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB9_3
	jmp	.LBB9_1
.LBB9_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB9_2
.LBB9_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	add	ecx, dword ptr [esp + 36]
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB9_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end9:
	.size	victim_function_v12, .Lfunc_end9-victim_function_v12
                                        # -- End function
	.globl	victim_function_v14             # -- Begin function victim_function_v14
	.p2align	4, 0x90
	.type	victim_function_v14,@function
victim_function_v14:                    # @victim_function_v14
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	eax, dword ptr [esp + 32]
	mov	eax, dword ptr [esp + 32]
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB10_3
	jmp	.LBB10_1
.LBB10_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB10_2
.LBB10_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	xor	ecx, 255
	movzx	edx, byte ptr [ecx + publicarray]
	mov	ecx, eax
	or	ecx, edx
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB10_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end10:
	.size	victim_function_v14, .Lfunc_end10-victim_function_v14
                                        # -- End function
	.globl	victim_function_v15             # -- Begin function victim_function_v15
	.p2align	4, 0x90
	.type	victim_function_v15,@function
victim_function_v15:                    # @victim_function_v15
# %bb.0:
	sub	esp, 28
	mov	rax, -1
	mov	qword ptr [esp + 8], rax        # 8-byte Spill
	mov	rax, rsp
	sar	rax, 63
	mov	qword ptr [esp + 16], rax       # 8-byte Spill
	mov	ecx, dword ptr [esp + 32]
	mov	ecx, dword ptr [esp + 32]
	mov	ecx, dword ptr [ecx]
	or	eax, ecx
	cmp	eax, dword ptr [publicarray_size]
	jae	.LBB11_3
	jmp	.LBB11_1
.LBB11_3:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovb	rax, rcx
	mov	qword ptr [esp], rax            # 8-byte Spill
	jmp	.LBB11_2
.LBB11_1:
	mov	rcx, qword ptr [esp + 8]        # 8-byte Reload
	mov	rax, qword ptr [esp + 16]       # 8-byte Reload
	cmovae	rax, rcx
	mov	ecx, dword ptr [esp + 32]
	mov	edx, dword ptr [ecx]
	mov	ecx, eax
	or	ecx, edx
	movzx	ecx, byte ptr [ecx + publicarray]
	movzx	edx, byte ptr [ecx + publicarray2]
	movzx	ecx, byte ptr [temp]
	and	ecx, edx
                                        # kill: def $cl killed $cl killed $ecx
	mov	byte ptr [temp], cl
	mov	qword ptr [esp], rax            # 8-byte Spill
.LBB11_2:
	mov	rax, qword ptr [esp]            # 8-byte Reload
	shl	rax, 47
	or	rsp, rax
	add	esp, 28
	ret
.Lfunc_end11:
	.size	victim_function_v15, .Lfunc_end11-victim_function_v15
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
	.addrsig_sym mymemcmp
	.addrsig_sym publicarray_size
	.addrsig_sym publicarray
	.addrsig_sym temp
	.addrsig_sym publicarray2
	.addrsig_sym array_size_mask
	.addrsig_sym victim_function_v7.last_x
	.addrsig_sym secret
