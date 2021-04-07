.text
.intel_syntax noprefix
.file    "spectre-pht.c"
.globl    victim_function_v1      # -- Begin function victim_function_v1
.p2align    4, 0x90
.type    victim_function_v1,@function
victim_function_v1:                     # @victim_function_v1
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB0_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB0_2:
lfence
pop    ebp
ret
.Lfunc_end0:
.size    victim_function_v1, .Lfunc_end0-victim_function_v1
                                    # -- End function
.globl    leakByteLocalFunction   # -- Begin function leakByteLocalFunction
.p2align    4, 0x90
.type    leakByteLocalFunction,@function
leakByteLocalFunction:                  # @leakByteLocalFunction
# %bb.0:
push    ebp
mov    ebp, esp
mov    al, byte ptr [ebp + 8]
movzx    ecx, byte ptr [ebp + 8]
movzx    ecx, byte ptr [ecx + publicarray2]
movzx    edx, byte ptr [temp]
and    edx, ecx
                                    # kill: def $dl killed $dl killed $edx
mov    byte ptr [temp], dl
pop    ebp
ret
.Lfunc_end1:
.size    leakByteLocalFunction, .Lfunc_end1-leakByteLocalFunction
                                    # -- End function
.globl    victim_function_v2      # -- Begin function victim_function_v2
.p2align    4, 0x90
.type    victim_function_v2,@function
victim_function_v2:                     # @victim_function_v2
# %bb.0:
push    ebp
mov    ebp, esp
sub    esp, 8
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB2_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
mov    dword ptr [esp], eax
call    leakByteLocalFunction
.LBB2_2:
lfence
add    esp, 8
pop    ebp
ret
.Lfunc_end2:
.size    victim_function_v2, .Lfunc_end2-victim_function_v2
                                    # -- End function
.globl    leakByteNoinlineFunction # -- Begin function leakByteNoinlineFunction
.p2align    4, 0x90
.type    leakByteNoinlineFunction,@function
leakByteNoinlineFunction:               # @leakByteNoinlineFunction
# %bb.0:
push    ebp
mov    ebp, esp
mov    al, byte ptr [ebp + 8]
movzx    ecx, byte ptr [ebp + 8]
movzx    ecx, byte ptr [ecx + publicarray2]
movzx    edx, byte ptr [temp]
and    edx, ecx
                                    # kill: def $dl killed $dl killed $edx
mov    byte ptr [temp], dl
pop    ebp
ret
.Lfunc_end3:
.size    leakByteNoinlineFunction, .Lfunc_end3-leakByteNoinlineFunction
                                    # -- End function
.globl    victim_function_v3      # -- Begin function victim_function_v3
.p2align    4, 0x90
.type    victim_function_v3,@function
victim_function_v3:                     # @victim_function_v3
# %bb.0:
push    ebp
mov    ebp, esp
sub    esp, 8
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB4_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
mov    dword ptr [esp], eax
call    leakByteNoinlineFunction
.LBB4_2:
lfence
add    esp, 8
pop    ebp
ret
.Lfunc_end4:
.size    victim_function_v3, .Lfunc_end4-victim_function_v3
                                    # -- End function
.globl    victim_function_v4      # -- Begin function victim_function_v4
.p2align    4, 0x90
.type    victim_function_v4,@function
victim_function_v4:                     # @victim_function_v4
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB5_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
shl    eax, 1
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB5_2:
lfence
pop    ebp
ret
.Lfunc_end5:
.size    victim_function_v4, .Lfunc_end5-victim_function_v4
                                    # -- End function
.globl    victim_function_v5      # -- Begin function victim_function_v5
.p2align    4, 0x90
.type    victim_function_v5,@function
victim_function_v5:                     # @victim_function_v5
# %bb.0:
push    ebp
mov    ebp, esp
push    eax
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB6_6
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
sub    eax, 1
mov    dword ptr [ebp - 4], eax
.LBB6_2:                                # =>This Inner Loop Header: Depth=1
cmp    dword ptr [ebp - 4], 0
jl    .LBB6_5
# %bb.3:                                #   in Loop: Header=BB6_2 Depth=1
lfence
mov    eax, dword ptr [ebp - 4]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
# %bb.4:                                #   in Loop: Header=BB6_2 Depth=1
mov    eax, dword ptr [ebp - 4]
add    eax, -1
mov    dword ptr [ebp - 4], eax
jmp    .LBB6_2
.LBB6_5:
lfence
jmp    .LBB6_6
.LBB6_6:
lfence
add    esp, 4
pop    ebp
ret
.Lfunc_end6:
.size    victim_function_v5, .Lfunc_end6-victim_function_v5
                                    # -- End function
.globl    victim_function_v6      # -- Begin function victim_function_v6
.p2align    4, 0x90
.type    victim_function_v6,@function
victim_function_v6:                     # @victim_function_v6
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
and    ecx, dword ptr [array_size_mask]
cmp    ecx, dword ptr [ebp + 8]
jne    .LBB7_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB7_2:
lfence
pop    ebp
ret
.Lfunc_end7:
.size    victim_function_v6, .Lfunc_end7-victim_function_v6
                                    # -- End function
.globl    victim_function_v7      # -- Begin function victim_function_v7
.p2align    4, 0x90
.type    victim_function_v7,@function
victim_function_v7:                     # @victim_function_v7
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [victim_function_v7.last_x]
jne    .LBB8_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB8_2:
lfence
mov    eax, dword ptr [ebp + 8]
cmp    eax, dword ptr [publicarray_size]
jae    .LBB8_4
# %bb.3:
lfence
mov    eax, dword ptr [ebp + 8]
mov    dword ptr [victim_function_v7.last_x], eax
.LBB8_4:
lfence
pop    ebp
ret
.Lfunc_end8:
.size    victim_function_v7, .Lfunc_end8-victim_function_v7
                                    # -- End function
.globl    victim_function_v8      # -- Begin function victim_function_v8
.p2align    4, 0x90
.type    victim_function_v8,@function
victim_function_v8:                     # @victim_function_v8
# %bb.0:
push    ebp
mov    ebp, esp
push    eax
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB9_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
add    eax, 1
mov    dword ptr [ebp - 4], eax # 4-byte Spill
jmp    .LBB9_3
.LBB9_2:
lfence
xor    eax, eax
mov    dword ptr [ebp - 4], eax # 4-byte Spill
jmp    .LBB9_3
.LBB9_3:
mov    eax, dword ptr [ebp - 4] # 4-byte Reload
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
add    esp, 4
pop    ebp
ret
.Lfunc_end9:
.size    victim_function_v8, .Lfunc_end9-victim_function_v8
                                    # -- End function
.globl    victim_function_v9      # -- Begin function victim_function_v9
.p2align    4, 0x90
.type    victim_function_v9,@function
victim_function_v9:                     # @victim_function_v9
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 12]
mov    ecx, dword ptr [ebp + 8]
mov    edx, dword ptr [ebp + 12]
cmp    dword ptr [edx], 0
je    .LBB10_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB10_2:
lfence
pop    ebp
ret
.Lfunc_end10:
.size    victim_function_v9, .Lfunc_end10-victim_function_v9
                                    # -- End function
.globl    victim_function_v10     # -- Begin function victim_function_v10
.p2align    4, 0x90
.type    victim_function_v10,@function
victim_function_v10:                    # @victim_function_v10
# %bb.0:
push    ebp
mov    ebp, esp
mov    al, byte ptr [ebp + 12]
mov    ecx, dword ptr [ebp + 8]
mov    edx, dword ptr [ebp + 8]
cmp    edx, dword ptr [publicarray_size]
jae    .LBB11_4
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    ecx, byte ptr [ebp + 12]
cmp    eax, ecx
jne    .LBB11_3
# %bb.2:
lfence
movzx    eax, byte ptr [publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB11_3:
lfence
jmp    .LBB11_4
.LBB11_4:
lfence
pop    ebp
ret
.Lfunc_end11:
.size    victim_function_v10, .Lfunc_end11-victim_function_v10
                                    # -- End function
.globl    mymemcmp                # -- Begin function mymemcmp
.p2align    4, 0x90
.type    mymemcmp,@function
mymemcmp:                               # @mymemcmp
# %bb.0:
push    ebp
mov    ebp, esp
push    esi
sub    esp, 12
mov    eax, dword ptr [ebp + 16]
mov    ecx, dword ptr [ebp + 12]
mov    edx, dword ptr [ebp + 8]
mov    dword ptr [ebp - 16], 0
mov    esi, dword ptr [ebp + 8]
mov    dword ptr [ebp - 8], esi
mov    esi, dword ptr [ebp + 12]
mov    dword ptr [ebp - 12], esi
.LBB12_1:                               # =>This Inner Loop Header: Depth=1
xor    eax, eax
cmp    eax, dword ptr [ebp + 16]
jge    .LBB12_6
# %bb.2:                                #   in Loop: Header=BB12_1 Depth=1
lfence
mov    eax, dword ptr [ebp - 8]
movzx    eax, byte ptr [eax]
mov    ecx, dword ptr [ebp - 12]
movzx    ecx, byte ptr [ecx]
sub    eax, ecx
mov    dword ptr [ebp - 16], eax
cmp    eax, 0
je    .LBB12_4
# %bb.3:
lfence
jmp    .LBB12_6
.LBB12_4:                               #   in Loop: Header=BB12_1 Depth=1
lfence
jmp    .LBB12_5
.LBB12_5:                               #   in Loop: Header=BB12_1 Depth=1
mov    eax, dword ptr [ebp - 8]
add    eax, 1
mov    dword ptr [ebp - 8], eax
mov    eax, dword ptr [ebp - 12]
add    eax, 1
mov    dword ptr [ebp - 12], eax
mov    eax, dword ptr [ebp + 16]
add    eax, -1
mov    dword ptr [ebp + 16], eax
jmp    .LBB12_1
.LBB12_6:
lfence
mov    eax, dword ptr [ebp - 16]
add    esp, 12
pop    esi
pop    ebp
ret
.Lfunc_end12:
.size    mymemcmp, .Lfunc_end12-mymemcmp
                                    # -- End function
.globl    victim_function_v11     # -- Begin function victim_function_v11
.p2align    4, 0x90
.type    victim_function_v11,@function
victim_function_v11:                    # @victim_function_v11
# %bb.0:
push    ebp
mov    ebp, esp
sub    esp, 24
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB13_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
lea    ecx, [publicarray2]
add    ecx, eax
lea    eax, [temp]
mov    dword ptr [esp], eax
mov    dword ptr [esp + 4], ecx
mov    dword ptr [esp + 8], 1
call    mymemcmp
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
.LBB13_2:
lfence
add    esp, 24
pop    ebp
ret
.Lfunc_end13:
.size    victim_function_v11, .Lfunc_end13-victim_function_v11
                                    # -- End function
.globl    victim_function_v12     # -- Begin function victim_function_v12
.p2align    4, 0x90
.type    victim_function_v12,@function
victim_function_v12:                    # @victim_function_v12
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 12]
mov    ecx, dword ptr [ebp + 8]
mov    edx, dword ptr [ebp + 8]
add    edx, dword ptr [ebp + 12]
cmp    edx, dword ptr [publicarray_size]
jae    .LBB14_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
add    eax, dword ptr [ebp + 12]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB14_2:
lfence
pop    ebp
ret
.Lfunc_end14:
.size    victim_function_v12, .Lfunc_end14-victim_function_v12
                                    # -- End function
.globl    is_x_safe               # -- Begin function is_x_safe
.p2align    4, 0x90
.type    is_x_safe,@function
is_x_safe:                              # @is_x_safe
# %bb.0:
push    ebp
mov    ebp, esp
push    eax
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB15_2
# %bb.1:
lfence
mov    dword ptr [ebp - 4], 1
jmp    .LBB15_3
.LBB15_2:
lfence
mov    dword ptr [ebp - 4], 0
.LBB15_3:
mov    eax, dword ptr [ebp - 4]
add    esp, 4
pop    ebp
ret
.Lfunc_end15:
.size    is_x_safe, .Lfunc_end15-is_x_safe
                                    # -- End function
.globl    victim_function_v13     # -- Begin function victim_function_v13
.p2align    4, 0x90
.type    victim_function_v13,@function
victim_function_v13:                    # @victim_function_v13
# %bb.0:
push    ebp
mov    ebp, esp
sub    esp, 8
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
mov    dword ptr [esp], ecx
mov    dword ptr [ebp - 4], eax # 4-byte Spill
call    is_x_safe
cmp    eax, 0
je    .LBB16_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB16_2:
lfence
add    esp, 8
pop    ebp
ret
.Lfunc_end16:
.size    victim_function_v13, .Lfunc_end16-victim_function_v13
                                    # -- End function
.globl    victim_function_v14     # -- Begin function victim_function_v14
.p2align    4, 0x90
.type    victim_function_v14,@function
victim_function_v14:                    # @victim_function_v14
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB17_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
xor    eax, 255
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB17_2:
lfence
pop    ebp
ret
.Lfunc_end17:
.size    victim_function_v14, .Lfunc_end17-victim_function_v14
                                    # -- End function
.globl    victim_function_v15     # -- Begin function victim_function_v15
.p2align    4, 0x90
.type    victim_function_v15,@function
victim_function_v15:                    # @victim_function_v15
# %bb.0:
push    ebp
mov    ebp, esp
mov    eax, dword ptr [ebp + 8]
mov    ecx, dword ptr [ebp + 8]
mov    ecx, dword ptr [ecx]
cmp    ecx, dword ptr [publicarray_size]
jae    .LBB18_2
# %bb.1:
lfence
mov    eax, dword ptr [ebp + 8]
mov    eax, dword ptr [eax]
movzx    eax, byte ptr [eax + publicarray]
movzx    eax, byte ptr [eax + publicarray2]
movzx    ecx, byte ptr [temp]
and    ecx, eax
                                    # kill: def $cl killed $cl killed $ecx
mov    byte ptr [temp], cl
.LBB18_2:
lfence
pop    ebp
ret
.Lfunc_end18:
.size    victim_function_v15, .Lfunc_end18-victim_function_v15
                                    # -- End function
.globl    main                    # -- Begin function main
.p2align    4, 0x90
.type    main,@function
main:                                   # @main
# %bb.0:
push    ebp
mov    ebp, esp
sub    esp, 24
mov    dword ptr [ebp - 4], 0
call    __VERIFIER_nondet_long
mov    dword ptr [ebp - 8], eax
call    __VERIFIER_nondet_int
mov    dword ptr [ebp - 12], eax
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v1
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v2
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v3
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v4
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v5
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v6
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v7
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v8
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
lea    eax, [ebp - 12]
mov    dword ptr [esp + 4], eax
call    victim_function_v9
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
mov    dword ptr [esp + 4], 10
call    victim_function_v10
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v11
mov    eax, dword ptr [ebp - 8]
mov    ecx, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
mov    dword ptr [esp + 4], ecx
call    victim_function_v12
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v13
mov    eax, dword ptr [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v14
lea    eax, [ebp - 8]
mov    dword ptr [esp], eax
call    victim_function_v15
xor    eax, eax
add    esp, 24
pop    ebp
ret
.Lfunc_end19:
.size    main, .Lfunc_end19-main
                                    # -- End function
.type    publicarray_size,@object # @publicarray_size
.data
.globl    publicarray_size
.p2align    2
publicarray_size:
.long    16                      # 0x10
.size    publicarray_size, 4

.type    publicarray,@object     # @publicarray
.globl    publicarray
publicarray:
.ascii    "\000\001\002\003\004\005\006\007\b\t\n\013\f\r\016\017"
.size    publicarray, 16

.type    temp,@object            # @temp
.bss
.globl    temp
temp:
.byte    0                       # 0x0
.size    temp, 1

.type    publicarray2,@object    # @publicarray2
.comm    publicarray2,64,1
.type    array_size_mask,@object # @array_size_mask
.data
.globl    array_size_mask
.p2align    2
array_size_mask:
.long    15                      # 0xf
.size    array_size_mask, 4

.type    victim_function_v7.last_x,@object # @victim_function_v7.last_x
.local    victim_function_v7.last_x
.comm    victim_function_v7.last_x,4,4
.type    secret,@object          # @secret
.comm    secret,1,1
.ident    "Ubuntu clang version 10.0.1-++20201112101950+ef32c611aa2-1~exp1~20201112092551.202"
.section    ".note.GNU-stack","",@progbits
.addrsig
.addrsig_sym victim_function_v1
.addrsig_sym leakByteLocalFunction
.addrsig_sym victim_function_v2
.addrsig_sym leakByteNoinlineFunction
.addrsig_sym victim_function_v3
.addrsig_sym victim_function_v4
.addrsig_sym victim_function_v5
.addrsig_sym victim_function_v6
.addrsig_sym victim_function_v7
.addrsig_sym victim_function_v8
.addrsig_sym victim_function_v9
.addrsig_sym victim_function_v10
.addrsig_sym mymemcmp
.addrsig_sym victim_function_v11
.addrsig_sym victim_function_v12
.addrsig_sym is_x_safe
.addrsig_sym victim_function_v13
.addrsig_sym victim_function_v14
.addrsig_sym victim_function_v15
.addrsig_sym __VERIFIER_nondet_long
.addrsig_sym __VERIFIER_nondet_int
.addrsig_sym publicarray_size
.addrsig_sym publicarray
.addrsig_sym temp
.addrsig_sym publicarray2
.addrsig_sym array_size_mask
.addrsig_sym victim_function_v7.last_x
.addrsig_sym secret
.arrayinit  publicarray, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
.arraysize  publicarray2, 16
.varinit  array_size_mask, 15
.varinit  publicarray_size, 16
.varinit  temp, 0
