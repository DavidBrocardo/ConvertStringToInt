; Recuperação da Prova 01 - Converte uma sequencia de string para decimal 
; arquivo: DavidABrocardo.LMRAV01.asm
; Autor : David Antonio Brocardo.
; nasm -f elf64 DavidABrocardo.LMRAV01.asm ; ld DavidABrocardo.LMRAV01.o -o DavidABrocardo.LMRAV01.x

%define maxChars 10 ; no. máximo de caracteres a serem lidos
section .data                  
    entrada : dq "98563255",0
    v2: db 0
    ;invalida: db 0
   ; valida: db 0x1

section .bss
    resultado : resq 8
    isCastValid : resb 1

section .text
    global _start:

_start:
 
    mov byte [isCastValid] ,1
    mov rsi , entrada     ; recebe o endereco da string
    xor rcx , rcx    ; Contador 
    xor eax, eax     ; limpar o registrador EAX
  
    
 
calcula_tamanho:
        cmp byte [rsi], 0 ; verifica se chegou ao final da string
        je fim_calc ; sai do loop se chegou ao final
        inc rsi ; incrementa o registrador de origem para apontar para o próximo caractere
        inc rcx ; incrementa o contador de caracteres
        jmp calcula_tamanho ; volta para o início do loop

fim_calc:      
        mov [v2], rcx ; bakcup
        xor rsi , rsi ; zera  o endereco da string    
        xor r8 , r8 ; Multiplicador
        xor rcx , rcx    ; Contador 
        xor eax, eax     ; limpar o registrador EAX

convert_int:    
    mov rcx , [v2]     ; recebe o valor armazenando em v2  
    add rdi, r8 ;  Soma todas as partes
    ; Verifica se houve overflow na soma
    and r8, 0xF           ; Retira o lixo do registrador
    
    cmp rcx , 0  ; terminou a string    
    je salvaResul    
       
        mov r8, [entrada+rsi]      ; Passa  a string para o registrador 
        
        inc rsi               ; Incrementa o registrador de origem para apontar para o próximo caractere       
        sub r8, 0x30          ; Extrai o número da tabela ASCII   
        and r8, 0xF           ; Retira o lixo do registrador
       
        dec rcx 
        mov [v2],rcx
        
        cmp r8 , 13
        je negativo  ; se tiver o sinal negativo 

        jmp for_mult
        
   
            
        negativo: 
             
             mov r9 , r8
             xor r8 , r8 
                                         
            jmp convert_int

        for_mult:
            cmp rcx, 0 ; verifica se o contador atingiu o valor minimo
            je convert_int ; sai do loop se o contador fez todas as mult
                
            imul r8 , 10 ; exemplo pegamos o 7 de 7500 , entao devemos fazer 7 *10³, mas como é permitido o uso de expoente, fica 7 * 10 *10 *10
             jo overflow_occurred           ; verifica se estorou o tamanho de registrador, ativando a flag de overflow
            dec rcx   ; rcx --
            cmp rdi , 0
            jl overflow_occurred            ; verifica se estorou o tamanho de registrador, de maneira que torna o reg com valor negativo
            
        jmp for_mult 
              
salvaResul:
     
    cmp r9 , 13         ; verifica se o valor é negativo
    je salvaResulNeg
    mov  [resultado] ,  rdi
    jmp _fim

salvaResulNeg:

    neg rdi             ; se for nega o registrador antes de salva no rdi
    mov [resultado] , rdi      
    jmp _fim

overflow_occurred:
  
    mov byte [isCastValid] ,0 
    jmp  for_mult 
    
_fim:
    mov rax, 60
    mov rdi, 0
    syscall
