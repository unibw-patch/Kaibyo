.file    "spectre-sct.c"
.intel_syntax noprefix
.text
.globl    idx_array
.bss
.type    idx_array, @object
.size    idx_array, 2
idx_array:
.zero    2
.globl    publicarray
.data
.type    publicarray, @object
.size    publicarray, 2
publicarray:
.byte    20
.zero    1
.globl    secretarray
.type    secretarray, @object
.size    secretarray, 2
secretarray:
.byte    10
.byte    21
.text
.globl    victim
.type    victim, @function
victim:
.LFB6:
.cfi_startproc
sub    esp, 20
.cfi_def_cfa_offset 24
mov    eax, DWORD PTR [esp+24]
mov    BYTE PTR [esp], al
cmp    BYTE PTR [esp], 1
ja    .L3
mov    BYTE PTR idx_array, 64
movzx    eax, BYTE PTR [esp]
movzx    eax, BYTE PTR idx_array[eax]
movzx    edx, al
movzx    eax, BYTE PTR [esp]
imul    eax, edx
movzx    eax, BYTE PTR publicarray[eax]
mov    BYTE PTR [esp+19], al
.L3:
nop
add    esp, 20
.cfi_def_cfa_offset 4
ret
.cfi_endproc
.LFE6:
.size    victim, .-victim
.globl    main
.type    main, @function
main:
.LFB7:
.cfi_startproc
mov    eax, 0
ret
.cfi_endproc
.LFE7:
.size    main, .-main
.ident    "GCC: (Debian 8.3.0-6) 8.3.0"
.section    .note.GNU-stack,"",@progbits
