; Intro to STRUCT               (Struct1.asm)

; This program demonstrates the STRUC directive.
; 32-bit version.

INCLUDE Irvine32.inc
INCLUDE macros.inc

COORD STRUCT
  X WORD ?
  Y WORD ?
COORD ENDS

; Structure with no member alignment:
EmployeeBad STRUCT	
	Idnum    BYTE "000000000"	;  9
	Lastname BYTE 30 DUP(0)		; 30
	Years    WORD 0			;  2
	SalaryHistory DWORD 0,0,0,0	; 16
EmployeeBad ENDS				; 57 total

; Structure with correct member alignment:
Employee STRUCT	
	Idnum    BYTE "000000000"	;  9
	Lastname BYTE 30 DUP(0)		; 30
	ALIGN    WORD				;  1 byte added
	Years    WORD 0			;  2
	ALIGN    DWORD				;  2 bytes added
	SalaryHistory DWORD 0,0,0,0	; 16
Employee ENDS					; 60 total

.code
main PROC

	call test_field_access
	call test_alignment
	exit
main ENDP

;---------------------------------------------------
test_alignment PROC
;
; Compare the performance of aligned structure
; fields versus misaligned fields.

; Execution time using Employee: 6141 milliseconds
; Execution time using EmployeeBad: 6203 milliseconds
;---------------------------------------------------
.data
ALIGN DWORD
startTime DWORD ?			; align startTime
emp EmployeeBad <>			; or: emp Employee <>

.code
	call	GetMSeconds		; get starting time
	mov	startTime,eax
	
	mov	ecx,0FFFFFFFFh		; loop counter
L1:	mov	emp.Years,5
	mov	emp.SalaryHistory,35000
	loop	L1

	call	GetMSeconds		; get starting time
	sub	eax,startTime
	mWrite "Elapsed time: "
	call	WriteDec			; display elapsed time
	call	Crlf

	ret
test_alignment ENDP

;---------------------------------------------------
test_field_access PROC
;---------------------------------------------------
.data

; Create instances of the COORD structure,
; assigning values to both X and Y:
point1 COORD <5,10>
point2 COORD <10,20>

worker Employee <>

department Employee 5 DUP(<>)

; override all fields. Either angle brackets
; or curly braces can be used: 
person1 Employee <"555223333">
person2 Employee {"555223333"}

; override only the second field:
person3 Employee <,"Jones">

; skip the first three fields, and
; use DUP to initialize the last field:
person4 Employee <,,,2 DUP(20000)>

; Create an array of COORD objects:
NumPoints = 3
AllPoints COORD NumPoints DUP(<0,0>)

.code
; Get the offset of a field within a structure:
	mov edx,OFFSET Employee.SalaryHistory

; The following generates an "undefined identifier" error:
	;mov edx,OFFSET Salary

; The TYPE, LENGTH, and SIZE operators can be applied
; to the structure and its fields:
	mov eax,TYPE Employee
	mov ebx,SIZE Employee
	mov ecx,SIZE worker
	mov edx,SIZEOF worker
	call DumpRegs
	

	mov eax,TYPE Employee.SalaryHistory	; 4
	mov eax,LENGTH Employee.SalaryHistory	; 4
	mov eax,SIZEOF Employee.SalaryHistory	; 16

; The TYPE, LENGTH and SIZE operators can be applied
; to instances of the structure:
	mov eax,TYPE worker				; 82
	mov eax,TYPE worker.Years		; 2

; Indirect operands require the PTR operator:
	mov esi,offset worker
	mov ax,(Employee PTR [esi]).Years		; 2

; Indexed operands:

	mov	esi,TYPE Employee
	mov	department[esi].years, 4

; Loop through the array of points and set their
; X and Y values:
	mov edi,0
	mov ecx,NumPoints
	mov ax,1
L1:
	mov (COORD PTR AllPoints[edi]).X,ax
	mov (COORD PTR AllPoints[edi]).X,ax
	add edi,TYPE COORD
	inc ax
	Loop L1

	ret
test_field_access ENDP

END main