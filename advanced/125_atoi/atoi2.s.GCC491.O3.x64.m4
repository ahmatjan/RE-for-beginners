include(`commons.m4').LC0:
	.string	"Error! Unexpected char: '%c'\n"

my_atoi:
	sub	rsp, 8
	movsx	edx, BYTE PTR [rdi]
; _EN(`check for minus sign')_RU(`проверка на знак минуса')
	cmp	dl, 45 ; '-'
	je	.L22
	xor	esi, esi
	test	dl, dl
	je	.L20
.L10:
; ESI=0 _EN(`here if there was no minus sign and 1 if it was')_RU(``здесь, если знака минуса не было, или 1 в противном случае'')
	lea	eax, [rdx-48]
; _EN(`any character other than digit will result unsigned number greater than 9 after subtraction')_RU(``любой символ отличающийся от цифры в результате даст беззнаковое число больше 9 после вычитания'')
; _EN(``so if it is not digit, jump to L4, where error will be reported:'')_RU(``так что если это не число, перейти на L4, где будет просигнализировано об ошибке:'')
	cmp	al, 9
	ja	.L4
	xor	eax, eax
	jmp	.L6
.L7:
	lea	ecx, [rdx-48]
	cmp	cl, 9
	ja	.L4
.L6:
	lea	eax, [rax+rax*4]
	add	rdi, 1
	lea	eax, [rdx-48+rax*2]
	movsx	edx, BYTE PTR [rdi]
	test	dl, dl
	jne	.L7
; _EN(``if there was no minus sign, skip NEG instruction'')_RU(``если знака минуса не было, пропустить инструкцию NEG'')
; _EN(``if it was, execute it'')_RU(``а если был, то исполнить её'').
	test	esi, esi
	je	.L18
	neg	eax
.L18:
	add	rsp, 8
	ret
.L22:
	movsx	edx, BYTE PTR [rdi+1]
	lea	rax, [rdi+1]
	test	dl, dl
	je	.L20
	mov	rdi, rax
	mov	esi, 1
	jmp	.L10
.L20:
	xor	eax, eax
	jmp	.L18
.L4:
; _EN(``report error. character is in EDX'')_RU(``сообщить об ошибке. символ в EDX'')
	mov	edi, 1
	mov	esi, OFFSET FLAT:.LC0 ; "Error! Unexpected char: '%c'\n"
	xor	eax, eax
	call	__printf_chk
	xor	edi, edi
	call	exit
