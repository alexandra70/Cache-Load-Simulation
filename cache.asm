;; defining constants, you can use these as immediate values in your code
%include "utils/printf32.asm"
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .data
    offset dd 0 ;;dd - deci double d, nu db
    tag dd 0 ;;deci eu incep de la tag si am 32 de biti sa pun ce vreau eu in ei
    i dd 1000 ;; linia, ca in enunt(unde am gasit tagul)
    
section .text
    global load
    extern printf

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE
    jmp func

cauta_in_tags:

    PRINTF32 `offset = = = = =?%d\n\x0`, [offset]
    mov ebx, [ebp + 12]
    xor ecx, ecx

linii_tags:

    mov edi, [ebx + ecx * 4] ;; valaorea de la linia offset din tag
    ;;PRINTF32 `\n  tags[offset] ?%d\n\n\x0`, edi

    mov esi, [tag]
    cmp esi, edi
    mov [i], ecx
    je tag_gasit

    inc ecx
    cmp ecx, CACHE_LINES
    je tag_negasit
    jmp linii_tags


suprascrie_linie_cache:

    mov ecx, [ebp + 16] ; cache
    mov edi, [ebp + 24] ; to_replace
    ;;trebuie sa scuprscriu linia edi din edi, cum?
    mov [i], edi ; cand caut tot la linia asta gasesc

    ;; calculez liania de la care trebuie sa incep sa pun bytes
    ;; deci va fi ceva de forma 8 * nr_linie + deplasament
    xor ecx, ecx
    mov eax, 8
    mul edi
    mov edi, eax ;;pun rezultatul dupa inmultire in edi(tot in edi)  
    PRINTF32 ` suprascrie_linie_cache cand suprascriu la ce pos pun  %d\n\x0`,  edi

    ; ecx e in intervalul [0 , 7]
line_loop:

    mov eax, [tag] ;; fac adrese, iau ce am in tag si adaug ecx
    shl eax, 3 ;;fac loc de ultimii 3 biti
    add eax, ecx ;;pun 000, 001, 010 , ... 111; (pana la 7)

    mov bl, [eax] ;;pun otetul pe care il gasesc la adresa eax
    ;;PRINTF32 `............. %hhd\n\x0`,  ebx

    mov esi, [ebp + 16] ;;adresa lui cache
    ;; se zice in enunt ca se vor a fi parcurse ca vector-->
    mov [esi + edi], bl ;;mut octetul la al edi octet din cache
    inc edi ;;cresc pozitia
 
    ;;PRINTF32 `intru sa afisex ecx %d\n\x0`,  ecx  
    inc ecx
    ;; verific dc am parcurs toti octetii de pe linie
    cmp ecx, 8
    jne line_loop

    ;; dc am pus in cache, inseama si ca am gasit octetul pe care il vreau 
    jmp tag_gasit

take_from_cache:
    
    mov eax, 8
    mov edi, [i]
    PRINTF32 `\n  take_from_cache -[i]  %d  \n\x0`, edi

    ;; calculez de unde iau octetul, pun rezulatul in edi
    mul edi
    mov edi, eax 
    mov ebx, [offset]
    add edi, ebx

    mov ecx, [ebp + 16] ; cache
    PRINTF32 `\n  take_from_cache - de unde iau %d  \n\x0`, edi
    mov bl, byte[ecx + edi]
    PRINTF32 `\nOCTET REZULATAT  %hhd\n\x0`, [ecx + edi]

    ;;scriu in reg rezultatul final.
    mov eax, [ebp + 8] ;; reg unde scriu

    mov [eax], bl
    jmp stop

func:
 
    ;;deci eu vreau sa pun in adresa de la eax o valoare
    ;;si valoarea aia se gaseste si ea la o adresa in edx
    mov ebx, [edx]
 
    ;; fac rost de tag si de offset cu shl, respectiv shr
    push edi 
    mov edi, edx
    ;; fac ultimii 3 biti zero(din tag)
    shl edi, 29
    shr edi, 29
    mov [offset], edi
    pop edi
    
    push edi 
    mov edi, edx
    shr edi, 3

    mov [tag], edi
    pop edi
    ;;in punctul asta am si tagul si offsetul calculate, acum vad dc la tags[de offset] am acelasi lucru ca in [tag]
    jmp cauta_in_tags ;;caut tag in tags la offset

tag_gasit:
    PRINTF32 `tag_gasit         %d\n\x0`, [offset]
    PRINTF32 `  AMCUMVA LINIA DE LA INCEPUT   %d\n\x0`, [i]
    jmp take_from_cache

tag_negasit:
    PRINTF32 `tag_negasit   %d\n\x0`, [offset]
    jmp suprascrie_linie_cache
    jmp take_from_cache
    
stop:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


