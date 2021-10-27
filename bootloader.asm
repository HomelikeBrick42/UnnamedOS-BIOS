[org 0x7c00]
[bits 16]

; Setup the stack
;
; If we overflow the stack it will start to
; overwrite this code
mov sp, 0x9000
mov bp, sp

call draw_colors

jmp $

%define x_size 320
%define y_size 200

draw_colors:
	push ax
	push bx
	push cx
	push dx

	mov ah, 0x00  ; Set graphics mode
	mov al, 0x13  ; Graphics mode
	int 0x10

	mov ah, 0x05  ; Set visible page
	mov al, 0     ; Page
	int 0x10

	mov ah, 0x0C  ; Draw pixel
	mov bh, 0     ; Page
	mov al, 0000b ; Color
	mov cx, 0     ; X coordinate
	mov dx, 0     ; Y coordinate

	start_x_loop:

		cmp cx, x_size
		jge end_x_loop

		mov dx, 0

		start_y_loop:

			cmp dx, y_size
			jge end_y_loop

			; Call the interupt to draw the pixel
			int 0x10

			inc dx
			jmp start_y_loop

		end_y_loop:

		inc al

		inc cx
		jmp start_x_loop

	end_x_loop:

	pop dx
	pop cx
	pop bx
	pop ax

	ret

times 510-($-$$) db 0
dw 0xAA55
