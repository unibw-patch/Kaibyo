.file    "spectre-pht.c"
.intel_syntax noprefix
.text
.globl    publicarray_size
.data
.align 4
.type    publicarray_size, @object
.size    publicarray_size, 4
publicarray_size:
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
.LFB6:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L3
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L3:
nop
ret
.cfi_endproc
.LFE6:
.size    victim_function_v1, .-victim_function_v1
.globl    leakByteLocalFunction
.type    leakByteLocalFunction, @function
leakByteLocalFunction:
.LFB7:
.cfi_startproc
sub    esp, 4
.cfi_def_cfa_offset 8
mov    eax, DWORD PTR [esp+8]
mov    BYTE PTR [esp], al
movzx    eax, BYTE PTR [esp]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 4
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE7:
.size    leakByteLocalFunction, .-leakByteLocalFunction
.globl    victim_function_v2
.type    victim_function_v2, @function
victim_function_v2:
.LFB8:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L7
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
push    eax
.cfi_def_cfa_offset 8
call    leakByteLocalFunction
add    esp, 4
.cfi_def_cfa_offset 4
.L7:
nop
ret
.cfi_endproc
.LFE8:
.size    victim_function_v2, .-victim_function_v2
.globl    leakByteNoinlineFunction
.type    leakByteNoinlineFunction, @function
leakByteNoinlineFunction:
.LFB9:
.cfi_startproc
sub    esp, 4
.cfi_def_cfa_offset 8
mov    eax, DWORD PTR [esp+8]
mov    BYTE PTR [esp], al
movzx    eax, BYTE PTR [esp]
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
add    esp, 4
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE9:
.size    leakByteNoinlineFunction, .-leakByteNoinlineFunction
.globl    victim_function_v3
.type    victim_function_v3, @function
victim_function_v3:
.LFB10:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L11
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
push    eax
.cfi_def_cfa_offset 8
call    leakByteNoinlineFunction
add    esp, 4
.cfi_def_cfa_offset 4
.L11:
nop
ret
.cfi_endproc
.LFE10:
.size    victim_function_v3, .-victim_function_v3
.globl    victim_function_v4
.type    victim_function_v4, @function
victim_function_v4:
.LFB11:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L14
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, eax
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L14:
nop
ret
.cfi_endproc
.LFE11:
.size    victim_function_v4, .-victim_function_v4
.globl    victim_function_v5
.type    victim_function_v5, @function
victim_function_v5:
.LFB12:
.cfi_startproc
sub    esp, 16
.cfi_def_cfa_offset 20
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+20], eax
jnb    .L19
lfence
mov    eax, DWORD PTR [esp+20]
sub    eax, 1
mov    DWORD PTR [esp+12], eax
jmp    .L17
.L18:
mov    eax, DWORD PTR [esp+12]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
sub    DWORD PTR [esp+12], 1
.L17:
cmp    DWORD PTR [esp+12], 0
jns    .L18
.L19:
nop
add    esp, 16
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE12:
.size    victim_function_v5, .-victim_function_v5
.globl    array_size_mask
.data
.align 4
.type    array_size_mask, @object
.size    array_size_mask, 4
array_size_mask:
.long    15
.text
.globl    victim_function_v6
.type    victim_function_v6, @function
victim_function_v6:
.LFB13:
.cfi_startproc
mov    eax, DWORD PTR array_size_mask
and    eax, DWORD PTR [esp+4]
cmp    DWORD PTR [esp+4], eax
jne    .L22
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L22:
nop
ret
.cfi_endproc
.LFE13:
.size    victim_function_v6, .-victim_function_v6
.globl    victim_function_v7
.type    victim_function_v7, @function
victim_function_v7:
.LFB14:
.cfi_startproc
mov    eax, DWORD PTR last_x.2704
cmp    DWORD PTR [esp+4], eax
jne    .L24
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L24:
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L26
mov    eax, DWORD PTR [esp+4]
mov    DWORD PTR last_x.2704, eax
.L26:
nop
ret
.cfi_endproc
.LFE14:
.size    victim_function_v7, .-victim_function_v7
.globl    victim_function_v8
.type    victim_function_v8, @function
victim_function_v8:
.LFB15:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L28
mov    eax, DWORD PTR [esp+4]
add    eax, 1
jmp    .L29
.L28:
mov    eax, 0
.L29:
lfence
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
nop
ret
.cfi_endproc
.LFE15:
.size    victim_function_v8, .-victim_function_v8
.globl    victim_function_v9
.type    victim_function_v9, @function
victim_function_v9:
.LFB16:
.cfi_startproc
mov    eax, DWORD PTR [esp+8]
mov    eax, DWORD PTR [eax]
test    eax, eax
je    .L32
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L32:
nop
ret
.cfi_endproc
.LFE16:
.size    victim_function_v9, .-victim_function_v9
.globl    victim_function_v10
.type    victim_function_v10, @function
victim_function_v10:
.LFB17:
.cfi_startproc
sub    esp, 4
.cfi_def_cfa_offset 8
mov    eax, DWORD PTR [esp+12]
mov    BYTE PTR [esp], al
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+8], eax
jnb    .L35
lfence
mov    eax, DWORD PTR [esp+8]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
cmp    BYTE PTR [esp], al
jne    .L35
movzx    edx, BYTE PTR publicarray2
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L35:
nop
add    esp, 4
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE17:
.size    victim_function_v10, .-victim_function_v10
.globl    victim_function_v11
.type    victim_function_v11, @function
victim_function_v11:
.LFB18:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L38
lfence
mov    eax, OFFSET FLAT:temp
movzx    edx, BYTE PTR [eax]
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
add    eax, OFFSET FLAT:publicarray2
movzx    eax, BYTE PTR [eax]
sub    edx, eax
mov    eax, edx
mov    BYTE PTR temp, al
.L38:
nop
ret
.cfi_endproc
.LFE18:
.size    victim_function_v11, .-victim_function_v11
.globl    victim_function_v12
.type    victim_function_v12, @function
victim_function_v12:
.LFB19:
.cfi_startproc
mov    edx, DWORD PTR [esp+4]
mov    eax, DWORD PTR [esp+8]
add    edx, eax
mov    eax, DWORD PTR publicarray_size
cmp    edx, eax
jnb    .L41
lfence
mov    edx, DWORD PTR [esp+4]
mov    eax, DWORD PTR [esp+8]
add    eax, edx
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L41:
nop
ret
.cfi_endproc
.LFE19:
.size    victim_function_v12, .-victim_function_v12
.globl    is_x_safe
.type    is_x_safe, @function
is_x_safe:
.LFB20:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L43
mov    eax, 1
ret
.L43:
mov    eax, 0
ret
.cfi_endproc
.LFE20:
.size    is_x_safe, .-is_x_safe
.globl    victim_function_v13
.type    victim_function_v13, @function
victim_function_v13:
.LFB21:
.cfi_startproc
push    DWORD PTR [esp+4]
.cfi_def_cfa_offset 8
call    is_x_safe
add    esp, 4
.cfi_def_cfa_offset 4
test    eax, eax
je    .L47
lfence
mov    eax, DWORD PTR [esp+4]
add    eax, OFFSET FLAT:publicarray
movzx    eax, BYTE PTR [eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L47:
nop
ret
.cfi_endproc
.LFE21:
.size    victim_function_v13, .-victim_function_v13
.globl    victim_function_v14
.type    victim_function_v14, @function
victim_function_v14:
.LFB22:
.cfi_startproc
mov    eax, DWORD PTR publicarray_size
cmp    DWORD PTR [esp+4], eax
jnb    .L50
lfence
mov    eax, DWORD PTR [esp+4]
xor    al, -1
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L50:
nop
ret
.cfi_endproc
.LFE22:
.size    victim_function_v14, .-victim_function_v14
.globl    victim_function_v15
.type    victim_function_v15, @function
victim_function_v15:
.LFB23:
.cfi_startproc
mov    eax, DWORD PTR [esp+4]
mov    edx, DWORD PTR [eax]
mov    eax, DWORD PTR publicarray_size
cmp    edx, eax
jnb    .L53
lfence
mov    eax, DWORD PTR [esp+4]
mov    eax, DWORD PTR [eax]
movzx    eax, BYTE PTR publicarray[eax]
movzx    eax, al
movzx    edx, BYTE PTR publicarray2[eax]
movzx    eax, BYTE PTR temp
and    eax, edx
mov    BYTE PTR temp, al
.L53:
nop
ret
.cfi_endproc
.LFE23:
.size    victim_function_v15, .-victim_function_v15
.globl    main
.type    main, @function
main:
.LFB24:
.cfi_startproc
mov    eax, 0
ret
.cfi_endproc
.LFE24:
.size    main, .-main
.local    last_x.2704
.comm    last_x.2704,4,4
.ident    "GCC: (Debian 8.3.0-6) 8.3.0"
.section    .note.GNU-stack,"",@progbits
