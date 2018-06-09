TITLE Multiple Segment Example                 (MultiSeg.asm)

; This program shows how to explicityly declare
; multiple data segments.
; Last update: 06/01/2006

cseg  SEGMENT 'CODE'
      ASSUME cs:cseg, ds:data1, ss:mystack

main PROC
	mov  ax,data1           	; point DS to data1 segment
	mov  ds,ax
	mov  ax,seg val2        	; point ES to data2 segment
	mov  es,ax

	mov  ax,val1            	; requires ASSUME for DS
	mov  bx,es:val2         	; ASSUME not required
	cmp  ax,bx
	jb   L1                 	; requires ASSUME for CS
	mov  ax,0

L1:
	mov  ax,4C00h           	; return to MS-DOS
	int  21h
main ENDP
cseg  ENDS

data1 SEGMENT 'DATA'        	; specify class type
	val1  dw  1001h
data1 ENDS

data2 SEGMENT 'DATA'
	val2  dw  1002h
data2 ENDS

mystack SEGMENT para STACK 'STACK'
	BYTE 100h dup('S')
mystack ENDS

END main