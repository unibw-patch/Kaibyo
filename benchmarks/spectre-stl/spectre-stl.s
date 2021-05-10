.file    "spectre-stl.c"
.intel_syntax noprefix
.text
.globl    array_size
.data
.align 4
.type    array_size, @object
.size    array_size, 4
array_size:
.long    16
.globl    publicarray
.align 4
.type    publicarray, @object
.size    publicarray, 16
publicarray:
.byte    0
.byte    1
.byte    2
.byte    3
.byte    4
.byte    5
.byte    6
.byte    7
.byte    8
.byte    9
.byte    10
.byte    11
.byte    12
.byte    13
.byte    14
.byte    15
.globl    publicarray2
.align 4
.type    publicarray2, @object
.size    publicarray2, 16
publicarray2:
.byte    20
.zero    15
.globl    secretarray
.align 4
.type    secretarray, @object
.size    secretarray, 16
secretarray:
.byte    10
.byte    21
.byte    32
.byte    43
.byte    54
.byte    65
.byte    76
.byte    87
.byte    98
.byte    109
.byte    110
.byte    121
.byte    -124
.byte    -113
.byte    -102
.byte    -91
.globl    temp
.bss
.type    temp, @object
.size    temp, 1
temp:
.zero    1
.text
.globl    victim_function_v1
.type    victim_function_v1, @function
victim_function_v1:
.LFB0:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+20]
mov    edx, eax
mov    DWORD PTR [esp+8], OFFSET FLAT:secretarray
lea    eax, [esp+8]
mov    DWORD PTR [esp+4], eax
lea    eax, [esp+4]
mov    DWORD PTR [esp+12], eax
mov    eax, DWORD PTR [esp+12]
mov    eax, DWORD PTR [eax]
mov    eax, DWORD PTR [eax]
mov    ecx, edx
add    eax, ecx
mov    BYTE PTR [eax], 0
mov    eax, edx
movzx    eax, BYTE PTR secretarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE0:
.size    victim_function_v1, .-victim_function_v1
.globl    victim_function_v2
.type    victim_function_v2, @function
victim_function_v2:
.LFB1:
.cfi_startproc
mov    eax, DWORD PTR array_size
sub    eax, 1
and    DWORD PTR [esp+4], eax
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE1:
.size    victim_function_v2, .-victim_function_v2
.globl    victim_function_v3
.type    victim_function_v3, @function
victim_function_v3:
.LFB2:
.cfi_startproc
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+4]
mov    edx, eax
mov    eax, edx
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE2:
.size    victim_function_v3, .-victim_function_v3
.globl    victim_function_v4
.type    victim_function_v4, @function
victim_function_v4:
.LFB3:
.cfi_startproc
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+4]
mov    edx, eax
mov    eax, edx
mov    BYTE PTR secretarray[eax], 0
mov    eax, edx
movzx    eax, BYTE PTR secretarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE3:
.size    victim_function_v4, .-victim_function_v4
.globl    case5_ptr
.data
.align 4
.type    case5_ptr, @object
.size    case5_ptr, 4
case5_ptr:
.long    secretarray
.text
.globl    victim_function_v5
.type    victim_function_v5, @function
victim_function_v5:
.LFB4:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+20]
mov    edx, eax
mov    DWORD PTR case5_ptr, OFFSET FLAT:publicarray
mov    eax, DWORD PTR case5_ptr
add    eax, edx
movzx    eax, BYTE PTR [eax]
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE4:
.size    victim_function_v5, .-victim_function_v5
.globl    case6_idx
.bss
.align 4
.type    case6_idx, @object
.size    case6_idx, 4
case6_idx:
.zero    4
.globl    case6_array
.data
.align 4
.type    case6_array, @object
.size    case6_array, 8
case6_array:
.long    secretarray
.long    publicarray
.text
.globl    victim_function_v6
.type    victim_function_v6, @function
victim_function_v6:
.LFB5:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+20]
mov    edx, eax
mov    DWORD PTR case6_idx, 1
mov    eax, DWORD PTR case6_idx
mov    eax, DWORD PTR case6_array[0+eax*4]
add    eax, edx
movzx    eax, BYTE PTR [eax]
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE5:
.size    victim_function_v6, .-victim_function_v6
.globl    case7_mask
.data
.align 4
.type    case7_mask, @object
.size    case7_mask, 4
case7_mask:
.long    -1
.text
.globl    victim_function_v7
.type    victim_function_v7, @function
victim_function_v7:
.LFB6:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR array_size
sub    eax, 1
mov    DWORD PTR case7_mask, eax
mov    eax, DWORD PTR case7_mask
and    eax, DWORD PTR [esp+20]
movzx    eax, BYTE PTR publicarray[eax]
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE6:
.size    victim_function_v7, .-victim_function_v7
.globl    case8_mult
.data
.align 4
.type    case8_mult, @object
.size    case8_mult, 4
case8_mult:
.long    200
.text
.globl    victim_function_v8
.type    victim_function_v8, @function
victim_function_v8:
.LFB7:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    DWORD PTR case8_mult, 0
mov    eax, DWORD PTR case8_mult
imul    eax, DWORD PTR [esp+20]
movzx    eax, BYTE PTR publicarray[eax]
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE7:
.size    victim_function_v8, .-victim_function_v8
.globl    victim_function_v9
.type    victim_function_v9, @function
victim_function_v9:
.LFB8:
.cfi_startproc
push    ebx
.cfi_def_cfa_offset 8
.cfi_offset 3, -8
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+8]
mov    edx, eax
mov    eax, edx
mov    BYTE PTR secretarray[eax], 0
mov    ecx, 0
jmp    .L10
.L11:
mov    eax, ecx
mov    ebx, eax
movzx    eax, BYTE PTR temp
and    eax, ebx
mov    BYTE PTR temp, al
mov    eax, ecx
add    eax, 1
mov    ecx, eax
.L10:
mov    eax, ecx
cmp    eax, 199
jbe    .L11
mov    eax, edx
movzx    eax, BYTE PTR secretarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
pop    ebx
.cfi_restore 3
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE8:
.size    victim_function_v9, .-victim_function_v9
.globl    victim_function_v9_bis
.type    victim_function_v9_bis, @function
victim_function_v9_bis:
.LFB9:
.cfi_startproc
push    ebx
.cfi_def_cfa_offset 8
.cfi_offset 3, -8
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+8]
mov    edx, eax
mov    eax, edx
mov    BYTE PTR secretarray[eax], 0
mov    ecx, 0
jmp    .L13
.L14:
mov    eax, ecx
mov    ebx, eax
movzx    eax, BYTE PTR temp
and    eax, ebx
mov    BYTE PTR temp, al
mov    eax, ecx
add    eax, 1
mov    ecx, eax
.L13:
mov    eax, ecx
cmp    eax, 9
jbe    .L14
mov    eax, edx
movzx    eax, BYTE PTR secretarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
pop    ebx
.cfi_restore 3
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE9:
.size    victim_function_v9_bis, .-victim_function_v9_bis
.globl    victim_function_v10_do_mask
.type    victim_function_v10_do_mask, @function
victim_function_v10_do_mask:
.LFB10:
.cfi_startproc
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+4]
mov    edx, eax
mov    eax, edx
ret
.cfi_endproc
.LFE10:
.size    victim_function_v10_do_mask, .-victim_function_v10_do_mask
.globl    victim_function_v10
.type    victim_function_v10, @function
victim_function_v10:
.LFB11:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
push    DWORD PTR [esp+20]
.cfi_def_cfa_offset 24
call    victim_function_v10_do_mask
add    esp, 4
.cfi_def_cfa_offset 20
mov    DWORD PTR [esp+12], eax
mov    eax, DWORD PTR [esp+12]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE11:
.size    victim_function_v10, .-victim_function_v10
.globl    victim_function_v11_load_value
.type    victim_function_v11_load_value, @function
victim_function_v11_load_value:
.LFB12:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR array_size
sub    eax, 1
and    eax, DWORD PTR [esp+20]
mov    edx, eax
mov    eax, edx
movzx    eax, BYTE PTR publicarray[eax]
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE12:
.size    victim_function_v11_load_value, .-victim_function_v11_load_value
.globl    victim_function_v11
.type    victim_function_v11, @function
victim_function_v11:
.LFB13:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
push    DWORD PTR [esp+20]
.cfi_def_cfa_offset 24
call    victim_function_v11_load_value
add    esp, 4
.cfi_def_cfa_offset 20
mov    BYTE PTR [esp+15], al
movzx    eax, BYTE PTR [esp+15]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE13:
.size    victim_function_v11, .-victim_function_v11
.globl    victim_function_v12
.type    victim_function_v12, @function
victim_function_v12:
.LFB14:
.cfi_startproc
push    DWORD PTR [esp+4]
.cfi_def_cfa_offset 8
call    victim_function_v10_do_mask
add    esp, 4
.cfi_def_cfa_offset 4
mov    edx, eax
mov    eax, edx
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE14:
.size    victim_function_v12, .-victim_function_v12
.globl    victim_function_v13
.type    victim_function_v13, @function
victim_function_v13:
.LFB15:
.cfi_startproc
push    DWORD PTR [esp+4]
.cfi_def_cfa_offset 8
call    victim_function_v11_load_value
add    esp, 4
.cfi_def_cfa_offset 4
mov    edx, eax
mov    eax, edx
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE15:
.size    victim_function_v13, .-victim_function_v13
.globl    main
.type    main, @function
main:
.LFB16:
.cfi_startproc
mov    eax, 0
ret
.cfi_endproc
.LFE16:
.size    main, .-main
.ident    "GCC: (Debian 8.3.0-6) 8.3.0"
.section    .note.GNU-stack,"",@progbits
