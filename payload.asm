[bits 16]
[org 0x7C00]

start:
    ; Настройка сегментных регистров
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Установка видеорежима (текстовый 80x25, цветной)
    mov ax, 0x0003
    int 0x10

spam_loop:
    mov si, msg

print_char:
    lodsb
    or al, al
    jz spam_loop ; Когда строка кончилась — крутим по кругу на бесконечный спам
    
    mov ah, 0x0E ; Прерывание BIOS: вывод символа на экран
    mov bh, 0x00
    mov bl, 0x0C ; Ярко-красный цвет текста
    int 0x10
    jmp print_char

msg db 'MBR! ', 0

; Дополнение байтами 0x00 до 510 байт
times 510-($-$$) db 0

; Сигнатура загрузочного сектора MBR (2 байта)
dw 0xAA55
