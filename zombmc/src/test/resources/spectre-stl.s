.text
.intel_syntax noprefix
.file    "spectre-stl.c"
.globl    victim_function_v1              # -- Begin function victim_function_v1
.p2align    4, 0x90
.type    victim_function_v1,@function
victim_function_v1:                     # @victim_function_v1
# %bb.0:
sub    esp, 16
mov    eax, dword ptr [esp + 20]
mov    eax, dword ptr [esp + 20]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 12], eax
lea    eax, [secretarray]
mov    dword ptr [esp + 8], eax
lea    eax, [esp + 8]
mov    dword ptr [esp + 4], eax
lea    eax, [esp + 4]
mov    dword ptr [esp], eax
mov    eax, dword ptr [esp]
mov    eax, dword ptr [eax]
mov    eax, dword ptr [eax]
mov    ecx, dword ptr [esp + 12]
mov    byte ptr [eax + ecx], 0
mov    eax, dword ptr [esp + 12]
movzx    eax, byte ptr [eax + secretarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 16
ret
.Lfunc_end0:
.size    victim_function_v1, .Lfunc_end0-victim_function_v1
                                    # -- End function
.globl    victim_function_v2              # -- Begin function victim_function_v2
.p2align    4, 0x90
.type    victim_function_v2,@function
victim_function_v2:                     # @victim_function_v2
# %bb.0:
mov    eax, dword ptr [esp + 4]
mov    eax, dword ptr [esp + 4]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
mov    eax, dword ptr [esp + 4]
movzx    eax, byte ptr [eax + publicarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
ret
.Lfunc_end1:
.size    victim_function_v2, .Lfunc_end1-victim_function_v2
                                    # -- End function
.globl    victim_function_v3              # -- Begin function victim_function_v3
.p2align    4, 0x90
.type    victim_function_v3,@function
victim_function_v3:                     # @victim_function_v3
# %bb.0:
push    eax
mov    eax, dword ptr [esp + 8]
mov    eax, dword ptr [esp + 8]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp], eax
mov    eax, dword ptr [esp]
movzx    eax, byte ptr [eax + publicarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
pop    eax
ret
.Lfunc_end2:
.size    victim_function_v3, .Lfunc_end2-victim_function_v3
                                    # -- End function
.globl    victim_function_v4              # -- Begin function victim_function_v4
.p2align    4, 0x90
.type    victim_function_v4,@function
victim_function_v4:                     # @victim_function_v4
# %bb.0:
push    eax
mov    eax, dword ptr [esp + 8]
mov    eax, dword ptr [esp + 8]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp], eax
mov    eax, dword ptr [esp]
mov    byte ptr [eax + secretarray], 0
mov    eax, dword ptr [esp]
movzx    eax, byte ptr [eax + secretarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
pop    eax
ret
.Lfunc_end3:
.size    victim_function_v4, .Lfunc_end3-victim_function_v4
                                    # -- End function
.globl    victim_function_v5              # -- Begin function victim_function_v5
.p2align    4, 0x90
.type    victim_function_v5,@function
victim_function_v5:                     # @victim_function_v5
# %bb.0:
sub    esp, 8
mov    eax, dword ptr [esp + 12]
mov    eax, dword ptr [esp + 12]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
lea    eax, [publicarray]
mov    dword ptr [case5_ptr], eax
mov    eax, dword ptr [case5_ptr]
mov    ecx, dword ptr [esp + 4]
mov    al, byte ptr [eax + ecx]
mov    byte ptr [esp + 3], al
movzx    eax, byte ptr [esp + 3]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 8
ret
.Lfunc_end4:
.size    victim_function_v5, .Lfunc_end4-victim_function_v5
                                    # -- End function
.globl    victim_function_v6              # -- Begin function victim_function_v6
.p2align    4, 0x90
.type    victim_function_v6,@function
victim_function_v6:                     # @victim_function_v6
# %bb.0:
sub    esp, 8
mov    eax, dword ptr [esp + 12]
mov    eax, dword ptr [esp + 12]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
mov    dword ptr [case6_idx], 1
mov    eax, dword ptr [case6_idx]
mov    eax, dword ptr [4*eax + case6_array]
mov    ecx, dword ptr [esp + 4]
mov    al, byte ptr [eax + ecx]
mov    byte ptr [esp + 3], al
movzx    eax, byte ptr [esp + 3]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 8
ret
.Lfunc_end5:
.size    victim_function_v6, .Lfunc_end5-victim_function_v6
                                    # -- End function
.globl    victim_function_v7              # -- Begin function victim_function_v7
.p2align    4, 0x90
.type    victim_function_v7,@function
victim_function_v7:                     # @victim_function_v7
# %bb.0:
push    eax
mov    eax, dword ptr [esp + 8]
mov    eax, dword ptr [array_size]
sub    eax, 1
mov    dword ptr [case7_mask], eax
mov    eax, dword ptr [esp + 8]
and    eax, dword ptr [case7_mask]
mov    al, byte ptr [eax + publicarray]
mov    byte ptr [esp + 3], al
movzx    eax, byte ptr [esp + 3]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
pop    eax
ret
.Lfunc_end6:
.size    victim_function_v7, .Lfunc_end6-victim_function_v7
                                    # -- End function
.globl    victim_function_v8              # -- Begin function victim_function_v8
.p2align    4, 0x90
.type    victim_function_v8,@function
victim_function_v8:                     # @victim_function_v8
# %bb.0:
push    eax
mov    eax, dword ptr [esp + 8]
mov    dword ptr [case8_mult], 0
mov    eax, dword ptr [esp + 8]
imul    eax, dword ptr [case8_mult]
mov    al, byte ptr [eax + publicarray]
mov    byte ptr [esp + 3], al
movzx    eax, byte ptr [esp + 3]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
pop    eax
ret
.Lfunc_end7:
.size    victim_function_v8, .Lfunc_end7-victim_function_v8
                                    # -- End function
.globl    victim_function_v9              # -- Begin function victim_function_v9
.p2align    4, 0x90
.type    victim_function_v9,@function
victim_function_v9:                     # @victim_function_v9
# %bb.0:
sub    esp, 8
mov    eax, dword ptr [esp + 12]
mov    eax, dword ptr [esp + 12]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
mov    eax, dword ptr [esp + 4]
mov    byte ptr [eax + secretarray], 0
mov    dword ptr [esp], 0
.LBB8_1:                                # =>This Inner Loop Header: Depth=1
cmp    dword ptr [esp], 200
jae    .LBB8_4
# %bb.2:                                #   in Loop: Header=BB8_1 Depth=1
mov    ecx, dword ptr [esp]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
# %bb.3:                                #   in Loop: Header=BB8_1 Depth=1
mov    eax, dword ptr [esp]
add    eax, 1
mov    dword ptr [esp], eax
jmp    .LBB8_1
.LBB8_4:
mov    eax, dword ptr [esp + 4]
movzx    eax, byte ptr [eax + secretarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 8
ret
.Lfunc_end8:
.size    victim_function_v9, .Lfunc_end8-victim_function_v9
                                    # -- End function
.globl    victim_function_v9_bis          # -- Begin function victim_function_v9_bis
.p2align    4, 0x90
.type    victim_function_v9_bis,@function
victim_function_v9_bis:                 # @victim_function_v9_bis
# %bb.0:
sub    esp, 8
mov    eax, dword ptr [esp + 12]
mov    eax, dword ptr [esp + 12]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
mov    eax, dword ptr [esp + 4]
mov    byte ptr [eax + secretarray], 0
mov    dword ptr [esp], 0
.LBB9_1:                                # =>This Inner Loop Header: Depth=1
cmp    dword ptr [esp], 10
jae    .LBB9_4
# %bb.2:                                #   in Loop: Header=BB9_1 Depth=1
mov    ecx, dword ptr [esp]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
# %bb.3:                                #   in Loop: Header=BB9_1 Depth=1
mov    eax, dword ptr [esp]
add    eax, 1
mov    dword ptr [esp], eax
jmp    .LBB9_1
.LBB9_4:
mov    eax, dword ptr [esp + 4]
movzx    eax, byte ptr [eax + secretarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 8
ret
.Lfunc_end9:
.size    victim_function_v9_bis, .Lfunc_end9-victim_function_v9_bis
                                    # -- End function
.globl    victim_function_v10_do_mask     # -- Begin function victim_function_v10_do_mask
.p2align    4, 0x90
.type    victim_function_v10_do_mask,@function
victim_function_v10_do_mask:            # @victim_function_v10_do_mask
# %bb.0:
push    eax
mov    eax, dword ptr [esp + 8]
mov    eax, dword ptr [esp + 8]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp], eax
mov    eax, dword ptr [esp]
pop    ecx
ret
.Lfunc_end10:
.size    victim_function_v10_do_mask, .Lfunc_end10-victim_function_v10_do_mask
                                    # -- End function
.globl    victim_function_v10             # -- Begin function victim_function_v10
.p2align    4, 0x90
.type    victim_function_v10,@function
victim_function_v10:                    # @victim_function_v10
# %bb.0:
sub    esp, 12
mov    eax, dword ptr [esp + 16]
mov    eax, dword ptr [esp + 16]
mov    dword ptr [esp], eax
call    victim_function_v10_do_mask
mov    dword ptr [esp + 8], eax
mov    eax, dword ptr [esp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 12
ret
.Lfunc_end11:
.size    victim_function_v10, .Lfunc_end11-victim_function_v10
                                    # -- End function
.globl    victim_function_v11_load_value  # -- Begin function victim_function_v11_load_value
.p2align    4, 0x90
.type    victim_function_v11_load_value,@function
victim_function_v11_load_value:         # @victim_function_v11_load_value
# %bb.0:
sub    esp, 8
mov    eax, dword ptr [esp + 12]
mov    eax, dword ptr [esp + 12]
mov    ecx, dword ptr [array_size]
sub    ecx, 1
and    eax, ecx
mov    dword ptr [esp + 4], eax
mov    eax, dword ptr [esp + 4]
mov    al, byte ptr [eax + publicarray]
mov    byte ptr [esp + 3], al
movzx    eax, byte ptr [esp + 3]
add    esp, 8
ret
.Lfunc_end12:
.size    victim_function_v11_load_value, .Lfunc_end12-victim_function_v11_load_value
                                    # -- End function
.globl    victim_function_v11             # -- Begin function victim_function_v11
.p2align    4, 0x90
.type    victim_function_v11,@function
victim_function_v11:                    # @victim_function_v11
# %bb.0:
sub    esp, 12
mov    eax, dword ptr [esp + 16]
mov    eax, dword ptr [esp + 16]
mov    dword ptr [esp], eax
call    victim_function_v11_load_value
mov    byte ptr [esp + 11], al
movzx    eax, byte ptr [esp + 11]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 12
ret
.Lfunc_end13:
.size    victim_function_v11, .Lfunc_end13-victim_function_v11
                                    # -- End function
.globl    victim_function_v12             # -- Begin function victim_function_v12
.p2align    4, 0x90
.type    victim_function_v12,@function
victim_function_v12:                    # @victim_function_v12
# %bb.0:
sub    esp, 12
mov    eax, dword ptr [esp + 16]
mov    eax, dword ptr [esp + 16]
mov    dword ptr [esp], eax
call    victim_function_v10_do_mask
mov    dword ptr [esp + 8], eax
mov    eax, dword ptr [esp + 8]
movzx    eax, byte ptr [eax + publicarray]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 12
ret
.Lfunc_end14:
.size    victim_function_v12, .Lfunc_end14-victim_function_v12
                                    # -- End function
.globl    victim_function_v13             # -- Begin function victim_function_v13
.p2align    4, 0x90
.type    victim_function_v13,@function
victim_function_v13:                    # @victim_function_v13
# %bb.0:
sub    esp, 12
mov    eax, dword ptr [esp + 16]
mov    eax, dword ptr [esp + 16]
mov    dword ptr [esp], eax
call    victim_function_v11_load_value
mov    byte ptr [esp + 11], al
movzx    eax, byte ptr [esp + 11]
movzx    ecx, byte ptr [eax + publicarray2]
mov    al, byte ptr [temp]
movzx    eax, al
and    eax, ecx
                                    # kill: def $al killed $al killed $eax
mov    byte ptr [temp], al
add    esp, 12
ret
.Lfunc_end15:
.size    victim_function_v13, .Lfunc_end15-victim_function_v13
                                    # -- End function
.globl    main                            # -- Begin function main
.p2align    4, 0x90
.type    main,@function
main:                                   # @main
# %bb.0:
push    eax
mov    dword ptr [esp], 0
xor    eax, eax
pop    ecx
ret
.Lfunc_end16:
.size    main, .Lfunc_end16-main
                                    # -- End function
.type    array_size,@object              # @array_size
.data
.globl    array_size
.p2align    2
array_size:
.long    16                              # 0x10
.size    array_size, 4

.type    publicarray,@object             # @publicarray
.globl    publicarray
publicarray:
.ascii    "\001\002\003\004\005\006\007\b\t\n\013\f\r\016\017\020"
.size    publicarray, 16

.type    publicarray2,@object            # @publicarray2
.globl    publicarray2
publicarray2:
.byte    20                              # 0x14
.zero    15
.size    publicarray2, 16

.type    secretarray,@object             # @secretarray
.globl    secretarray
secretarray:
.ascii    "\n\025 +6ALWbmny\204\217\232\245"
.size    secretarray, 16

.type    temp,@object                    # @temp
.bss
.globl    temp
temp:
.byte    0                               # 0x0
.size    temp, 1

.type    case5_ptr,@object               # @case5_ptr
.data
.globl    case5_ptr
.p2align    2
case5_ptr:
.long    secretarray
.size    case5_ptr, 4

.type    case6_idx,@object               # @case6_idx
.bss
.globl    case6_idx
.p2align    2
case6_idx:
.long    0                               # 0x0
.size    case6_idx, 4

.type    case6_array,@object             # @case6_array
.data
.globl    case6_array
.p2align    2
case6_array:
.long    secretarray
.long    publicarray
.size    case6_array, 8

.type    case7_mask,@object              # @case7_mask
.globl    case7_mask
.p2align    2
case7_mask:
.long    4294967295                      # 0xffffffff
.size    case7_mask, 4

.type    case8_mult,@object              # @case8_mult
.globl    case8_mult
.p2align    2
case8_mult:
.long    200                             # 0xc8
.size    case8_mult, 4

.ident    "Ubuntu clang version 12.0.0-++20210406072642+d28af7c654d8-1~exp1~20210406173427.72"
.section    ".note.GNU-stack","",@progbits
.addrsig
.addrsig_sym victim_function_v10_do_mask
.addrsig_sym victim_function_v11_load_value
.addrsig_sym array_size
.addrsig_sym publicarray
.addrsig_sym publicarray2
.addrsig_sym secretarray
.addrsig_sym temp
.addrsig_sym case5_ptr
.addrsig_sym case6_idx
.addrsig_sym case6_array
.addrsig_sym case7_mask
.addrsig_sym case8_mult
.arrayinit  publicarray, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
.arrayinit  publicarray2, 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20
.varinit  array_size_mask, 15
.varinit  array_size, 16
.varinit  temp, 0
