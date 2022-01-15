section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    ;; la incput ecx e len
    xor eax, eax
    xor ebx, ebx
func:
    mov byte bl, [esi + eax] 
    mov byte bh, [edi + ecx - 1]
    xor bl, bh
    mov byte [edx + eax], bl
    inc eax

    loop func

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY