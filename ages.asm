%include "utils/printf32.asm"
;

;sa nu uit sa exclud asta la final - caut peste tot exclud

;
; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages
    extern printf
   
; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);

ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages

    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    xor eax, eax
    xor ecx, ecx
    xor ebx, ebx
    
func:
    cmp ecx, edx
    je out

    mov ebx, [edi + my_date_size * ecx + my_date.year]

    mov eax, [esi + my_date.year]
    cmp ebx, eax
    sub eax, ebx ; acum vad dc trebuie sa scad anul curent, adica dc nu am depasit si luna in care s a nascut
    push eax
    jmp comp_after_month

    comp_after_day:
    xor ebx, ebx
    mov bx, word [edi + my_date_size * ecx + my_date.day]
    xor eax, eax
    mov ax, [esi + my_date.day] 
    cmp ax, bx ;;setez eflags ? se mentine oare   
    jge out_comp_after_month ;;nu am ajuns la ziua de nastere din anul acesta
    ;; altfel si-a facut deja ziua si dau increment ani
    pop eax
    dec eax
    push eax

    jmp out_comp_after_month
    
comp_after_month:

    xor ebx, ebx
    mov bx, word [edi + my_date_size * ecx + my_date.month]
    xor eax, eax
    mov ax, word [esi + my_date.month] 
    cmp ax, bx ;;setez eflags
    jg out_comp_after_month ;; inca nu a avut ziua de nastere anul acesta
    je comp_after_day
    ;;altfel nu a avut ziua de nastere si atunci se scade un an
    pop eax
    dec eax
    push eax

out_comp_after_month:
    ;;in eax am rezultatul - varsta
    pop eax 
    cmp eax, 0
    jl is_about_to_be_born

revin:
    mov ebx, [ebp + 20]
    mov [ebx + 4 * ecx], eax

    inc ecx
    jmp func

is_about_to_be_born:
    mov eax, 0
    jmp revin
   
out:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
