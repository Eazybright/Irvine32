; Include file for the ArraySum Program      (sum.inc)

INCLUDE Irvine32.inc

PromptForIntegers PROTO,
	ptrPrompt:PTR BYTE,		; prompt string
	ptrArray:PTR DWORD,		; points to the array
	arraySize:DWORD		; size of the array

ArraySum PROTO,
	ptrArray:PTR DWORD,		; points to the array
	count:DWORD		; size of the array

DisplaySum PROTO,
	ptrPrompt:PTR BYTE,		; prompt string
	theSum:DWORD		; sum of the array