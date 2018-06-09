TITLE Disk Free Space                  (DiskSpc.asm)

; This program calls INT 21h Function 7303h, to get free 
; space information on a FAT-type drive volume. It 
; displays both the volume size and free space. Works 
; under Windows 95/98/Me, but not under Windows NT/2000/XP.
; Last update: 06/01/2006

INCLUDE Irvine16.inc

.data
buffer ExtGetDskFreSpcStruc <>
driveName BYTE "C:\",0
str1 BYTE "Volume size (KB): ",0
str2 BYTE "Free space (KB):  ",0
str3 BYTE "Function call failed.",0dh,0ah,0

.code
main PROC
	mov	ax,@data
	mov	ds,ax
	mov	es,ax

	mov	buffer.Level,0			; must be zero
	mov	di,OFFSET buffer		; ES:DI points to buffer
	mov	cx,SIZEOF buffer		; buffer size
	mov	dx,OFFSET DriveName		; ptr to drive name
	mov	ax,7303h				; get disk free space
	int	21h
	jc	error				; failed if CF = 1

	mov	dx,OFFSET str1			; volume size
	call	WriteString
	call	CalcVolumeSize
	call	WriteDec
	call	Crlf

	mov	dx,OFFSET str2			; free space
	call	WriteString
	call	CalcVolumeFree
	call	WriteDec
	call	Crlf
	jmp	quit
error:
	mov	dx,OFFSET str3
	call	WriteString
quit:
	exit
main ENDP

;------------------------------------------------------------
CalcVolumeSize PROC
;
; Calculate and return the disk volume size, in kilobytes.
; Receives: buffer variable, a ExtGetDskFreSpcStruc structure
; Returns:  EAX = volume size
; Remarks:  (SectorsPerCluster * 512 * TotalClusters) / 1024
;------------------------------------------------------------
	mov	eax,buffer.SectorsPerCluster
	shl	eax,9			; mult by 512
	mul	buffer.TotalClusters
	mov	ebx,1024
	div	ebx				; return kilobytes
	ret
CalcVolumeSize ENDP

;-------------------------------------------------------------
CalcVolumeFree PROC
;
; Calculate and return the number of available kilobytes 
; on the given volume.
; Receives: buffer variable, a ExtGetDskFreSpcStruc structure
; Returns:  EAX = available space, in kilobytes
; Remarks: (SectorsPerCluster * 512 * AvailableClusters) / 1024
;-------------------------------------------------------------
	mov	eax,buffer.SectorsPerCluster
	shl	eax,9			; mult by 512
	mul	buffer.AvailableClusters
	mov	ebx,1024
	div	ebx				; return kilobytes
	ret
CalcVolumeFree ENDP

END main