.386P			; директива .386P разрешает использовать команды МП 386 и 486
				; в частности позволяет работать с 32-разрядными операндами

; Структура для описания дескрипторов сегментов
descr		struc
limit 		dw 		0		; Граница (биты 0...15)
base_l 		dw 		0		; База (биты 0...15)
base_m 		db 		0		; База (биты 1...23)
attr_1 		db 		0		; Байт атрибутов 1
attr_2 		db 		0		; Граница (биты 16...19) и атрибуты 2
base_h 		db 		0		; База биты 24...31
descr 		ends

; СЕГМЕНТ ДАННЫХ
data 	segment 	use16				; use16 говорит о том, что в данном
										; сегменте используются 16-разрядные адреса
; Таблица глобальных дескрипторов GDT
gdt_null 	descr 	<0, 0, 0, 0, 0, 0>				; Нулевой дескриптор
gdt_data 	descr 	<data_size - 1,0,0,92h,0,0>		; Дескриптор сегмента данных
gdt_code 	descr 	<code_size - 1,0,0,98h,0,0>		; Дескриптор сегмента кода
gdt_stack 	descr 	<255,0,0,92h,0,0>				; Дескриптор сегмента стека
gdt_screen 	descr 	<4095, 8000h, 0Bh, 92h, 0, 0>	; Дескриптор видеобуфера
gdt_size = $ - gdt_null								; Вычичсление размера GDT
; Поля данных программы
pdescr		dq 		0								; Псевдодескриптор
msg_r_1 	db 		' in real mode$'
msg_p 		db 		' in protected mode$'
msg_r_2 	db 		' back in real mode$'	
data_size = $ - gdt_null 							; Вычичсление размера сегмента данных
data ends

; СЕГМЕНТ КОДА
text	segment	'code'	use16			; use16 говорит о том, что в данном
										; сегменте используются 16-разрядные адреса
	assume cs:text, ds:data
main	proc
		xor 	eax, eax
		mov 	ax, data
		mov 	ds, ax

; Вывод на экран сообщения о нахождении в реальном режиме
		mov si, offset msg_r_1 			; Сообщение по адресу ds:si
		mov ax,	0b800h 					; Адрес видеобуфера в ES
		mov es,	ax
		mov di,	640 					; Начальная позиция на экране
		mov cx, 13 						; Число выводимых символов

screen_1:
		lodsb 							; Считать байт из DS:SI в AL
		mov ah, 0Dh
		stosw 							; Записывает слово регистра AX в слово ES:DI (вывод на экран)
		loop screen_1

; Вычисление 32-разрядного линейного адреса сегмента данных, загрузка его в GDT
		xor	eax, eax
		mov	ax, ds 						; в DS уже находится адрес сегмента данных
		shl eax, 4 						; В EAX - линейный базовый адрес, shl - сдвиг влево
		mov ebp, eax					; Cохраним линейный базовый адрес в EBP
		mov bx, offset gdt_data			; В BX адрес дескриптора сегмента данных
		mov [bx].base_l, ax				; Загрузим младшую часть базы
		rol eax, 16						; Обмен младшей и старшей половин EAX
		mov [bx].base_m, al				; Загрузим среднюю часть базы

; Аналогично вычисляется и загружается в GDT 32-разрядный линейный адрес сегмента кода
		xor	eax, eax
		mov ax, cs
		shl eax, 4
		mov bx, offset gdt_code
		mov [bx].base_l, ax
		rol eax, 16
		mov [bx].base_m, al

; Аналогично вычисляется и загружается в GDT 32-разрядный линейный адрес сегмента стека
		xor eax, eax
		mov ax, ss
		shl eax, 4
		mov bx, offset gdt_stack
		mov [bx].base_l, ax
		rol eax, 16
		mov [bx].base_m, al

; Подготовка псевдодескриптора pdescr и загрузка его в регист GDTR
		mov dword ptr pdescr + 2, ebp 			; База GDT
		mov word ptr pdescr, gdt_size - 1 		; Граница GDT
		lgdt pdescr
; Подготовка к переходу в защищенный режим
		cli										; Запрет аппаратных прерываний
		mov al, 80h 							; Запрет немаскируемых прерываний
		out 70h, al

; Переход в защищенный режим
		mov	eax, cr0				; В EAX - содержимое регистра CR0
		or	eax, 1					; Установка бита PE для перехода в защищенный режим
		mov	cr0, eax				; Запись в CR0
; Теперь система работает в защищенном режиме

; Команда дальнего перехода, которая меняет содержимое регистров IP и CS,
; а значит, делает адресуемым CS, который программно недоступен
		db 	0EAh				; Код команды far jmp
		dw 	offset 	continue	; Смещение
		dw 	16					; Селектор сегмента кода

continue:
; Делаем адресуемыми данные, стек, видеобуфер
		mov ax, 8
		mov ds, ax

		mov ax, 24
		mov ss, ax

		mov ax, 32
		mov es, ax

; Вывод сообщения о нахождении в защищенном режиме
		mov di,	800
		mov cx, 18
		mov si, offset msg_p
screen_2:
		lodsb
		mov ah, 47h
		stosw
		loop screen_2

; Подготовка к возврату в реальный режим: запись ffff в границы сегментов
		mov	gdt_data.limit,	0FFFFh
		mov gdt_code.limit,	0FFFFh
		mov gdt_stack.limit, 0FFFFh
		mov gdt_screen.limit, 0FFFFh
; Загрузка теневых регистров для сегментов данных, стека и дополнительного сегмента
		mov ax, 8
		mov ds, ax
		mov ax, 24
		mov ss, ax
		mov ax, 32
		mov es, ax
; Загрузка теневых регистров для сегмента кода
		db 0EAh					; Код команды far jmp
		dw offset go			; Смещение
		dw 16					; Селектор сегмента кода

; Переход в реальный режим
go:
		mov eax, cr0			; Получить значение регистра CR0
		and eax, 0FFFFFFFEh		; сбросить бит PE
		mov cr0, eax			; Записать значение cr0

		db 0EAh					; Код команды far jmp
		dw offset return		; Смещение
		dw text					; Селектор сегмента кода

; Теперь процессор снова работает в реальном режиме
return:
; Востановление  адресуемости данных и стека
		mov AX, data
		mov DS, AX
		mov AX, stk
		mov SS, AX
		sti				; Разрешение аппаратных немаскируемых прерываний

		mov AL, 0		; Разрешение маскируемых прерываний
		out 70h, AL

; Вывод сообщения о возврате в реальный режим
		mov ax, 0b800h
		mov es, ax
		mov si, offset msg_r_2
		mov di, 960
		mov cx, 18
screen_3:
		lodsb
		mov ah, 0Ah
		stosw
		loop screen_3

; Завершение программы
		mov AX, 4C00h
		int 21h
main 	endp 				; Конец процедуры main
code_size = $ - main 	; Вычисление размера сегмента кода
text	ends

; СЕГМЕНТ СТЕКА
stk 	segment stack  'stack' use16
	db 	256 dup('^')
stk 	ends
	end main
