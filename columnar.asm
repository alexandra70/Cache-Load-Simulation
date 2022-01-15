 
section .data
    extern len_cheie, len_haystack
    extern printf

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE

    mov eax, [len_cheie]
    ;; PRINTF32 `%d\n\x0`, eax

    xor eax, eax
    xor edx, edx
    xor esi, esi ;;cu ecx parcurg sirul rezultat;

    ;;for(int i = 0; i < cheie_len; i ++)
    ;;parcurg vectorul de chei, il iau in ordine si o sa incerc
    ;;sa vad cum ma descurc cu memoria sa pun fix unde trebuie in bufferul
    ;;pe care il returnez, deci voi completa bucati din el
    ;;bucati de lungime key

outter_loop:
    
    ;;extrag indexul coloanei din vectoru
    xor edx, edx
    mov edx, dword [edi + eax * 4]
    push eax
    
    ;; PRINTF32 `\n\nEDX = COLOANA %d \n\x0`, edx
    ;; PRINTF32 `eax = in cheie unde sunt %d \n\x0`, eax

    xor ebx, ebx ; contor pt inner_loop = j
inner_loop:
    ;;acum sunt pe coloana edx si pun cat pot
    ;;pt a nu face inca o verificare in care trebuie sa vad
    ;;cate linii am - lucru ce presupune si ceva impartiri
    ;;inclusziv urm verif-> verific doar dc charul la care am 
    ;;ajuns in plaintext e null cu test val, val

    ;;formula e (coloana + j * lungime_cheie) cat timp nu e null
    mov eax, [len_cheie]
    push edx
    mul ebx
    pop edx
    xor ecx, ecx
    mov ecx, edx
    add ecx, eax ;;gata, aici am pos unde gasesc charul meu
    
    mov eax, [len_haystack]
    cmp ecx, eax
    jge out_from_inner ;; dc amdepasit lungimea sirului, cu toate ca e alocat
   ;; PRINTF32 `ECX = UNDE SUNT IN STRING %d  || \x0`, ecx
   ;; PRINTF32 `esi = contor  %d \n\x0`, esi
    
    xor eax, eax
    push edi
    mov edi, [ebp + 12]
    mov al, byte [edi + ecx]
    pop edi
   
   
    ;;altfel in adaug in cifertext
    push ebx
    mov ebx, [ebp + 16]
    mov byte [ebx + esi], al 
    inc esi
    pop ebx
    inc ebx
  
    jmp inner_loop

out_from_inner:
    pop eax
    inc eax
    push ebx
    mov ebx, [len_cheie]
    cmp eax, ebx
    pop ebx
    jge out
    jmp outter_loop

    ;; for (int j = 0; j < cheie_len && j < len_haystack; j ++)


out:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY