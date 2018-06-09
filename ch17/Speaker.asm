TITLE Speaker Demo Program               (Speaker.asm)

; This program plays a series of ascending notes on
; the PC speaker.
; Last update: 10/8/01

INCLUDE Irvine16.inc	; 16-bit Real mode program
speaker  =  61h	; address of speaker port
timer    =  42h	; address of timer port
delay1   = 500
delay2   = 0D000h	; delay between notes
startPitch = 60

.code
main PROC
	in   al,speaker	; get speaker status
	push ax             	; save status
	or   al,00000011b   	; set lowest 2 bits
	out  speaker,al     	; turn speaker on
	mov  al,startPitch          ; starting pitch

L2:
	out  timer,al       	; timer port: pulses speaker

   ; Create a delay loop between pitches:
	mov  cx,delay1
L3:	push cx	; outer loop
	mov  cx,delay2
L3a:	; inner loop
	loop L3a
	pop  cx
	loop L3

	sub  al,1           	; raise pitch
	jnz  L2             	; play another note

	pop  ax              	; get original status
	and  al,11111100b    	; clear lowest 2 bits
	out  speaker,al	; turn speaker off
	exit
main ENDP
END main