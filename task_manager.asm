.386P
.MODEL FLAT, stdcall

include resources.inc
include process_list_res.inc

;Library Linker Directives
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\comctl32.inc

includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\comctl32.lib
includelib \masm32\lib\masm32.lib

;Message structure
MSGSTRUCT STRUC
	MSHWND		DD	?	;Window id
	MSMESSAGE	DD 	?	;Message id
	MSWPARAM	DD	?	;Additional message information
	MSLPARAM	DD	?	;Additional message information
	MSTIME		DD	?	;Post time
	MSPT		DD	?	;Cursor position
MSGSTRUCT ENDS
;!Message structure

;Window structure
WNDCLASS STRUC
	CLSSTYLE	DD	?	;Window style
	CLWNDPROC	DD	?	;Window procedure pointer
	CLSCEXTRA	DD	? 	;Additional byte information for this structure
	CLWNDEXTRA	DD	? 	;Additional byte information for window
	CLSHISTANCE	DD	?	;Window HINST
	CLSHICON	DD	?	;Icon id
	CLSHCURSOR	DD	?	;Cursor id
	CLBKGROUND	DD	?	;Brush id
	CLMENUNAME	DD	?	;Name id
	CLNAME		DD	?	;Specifies a window class name
WNDCLASS ENDS
;!Window structure

TCC_ITEM STRUC
	_mask DD ?
    dwState DD ?
    dwStateMask DD ?
    pszText DD ?
    cchTextMax DD ?
    iImage DD ?
TCC_ITEM ENDS

INITCOMMONCONTROL STRUC
	wSize DD ?
    dwICC DD ? 
    dwSize DD ?
INITCOMMONCONTROL ENDS

;Data segment
_data segment dword public use32 'data'
	NEWHWND		dd			0
	LISTBOXPROCESSES	 dd 	0
	TAB	 dd 	0
	MSG			MSGSTRUCT 	<?>
	WC			WNDCLASS	<?>
	HINST		dd			0	;Application HINST
	TITLENAME	db			'Task Manager',0
	TITLELISTBOX db			'ListBox',0
	CLASSNAME	db			'CLASS32',0
	CAP		    db			'Message',0
	FIRSTTABNAME	    db			'Processes',0
	WC_TABCONTROLW		    db			'SysTabControl32',0
	ERROR_SNAP	db			'Errot get snapshot',0
	PROCDATA 	PROCESSENTRY32W <>
	tie     TCC_ITEM <> 
	icex    INITCOMMONCONTROL <>
	PROCH		dd ?
_data ends
;!Data segment


;Code segmant
_text segment dword public use32 'code'

START:
	;Get application handle
	push 0
	call GetModuleHandleA@4
	mov [HINST], eax

REG_CLASS:
	;Filling the window structure
	mov [WC.CLSSTYLE], STYLE_WINDOW
	mov [WC.CLWNDPROC], OFFSET WNDPROC
	mov [WC.CLSCEXTRA], 0
	mov [WC.CLWNDEXTRA], 0
	mov EAX, [HINST]
	mov [WC.CLSHISTANCE], EAX

;Icon
	push IDI_APPLICATION
	push 0
	call LoadIconA@8
	mov [WC.CLSHICON], EAX

;Cursor
	push IDC_CROSS
	push 0
	call LoadCursorA@8
	mov [WC.CLSHCURSOR], EAX

	mov [WC.CLBKGROUND], 17
	mov DWORD PTR [WC.CLMENUNAME],0
	mov DWORD PTR [WC.CLNAME], OFFSET CLASSNAME
	push OFFSET WC
	call RegisterClassA@4

;Create window
	push 0
	push [HINST]
	push 0
	push 0
	push 400	;Window height
	push 400	;Window width
	push 100	;Left upper coordinate
	push 100	;Right upper coordinate
	push WS_OVERLAPPEDWINDOW
	push OFFSET TITLENAME ;Window name
	push OFFSET CLASSNAME ;Class name
	push 0
	call CreateWindowExA@48

;Check error
	cmp eax, 0
	jz _ERR
	mov [NEWHWND], eax ;Window handle

	push SW_SHOWNORMAL
	push [NEWHWND]
	call ShowWindow@8 ;Show window

;----------------------------------------------

	push [NEWHWND]
	call UpdateWindow@4 ;Redraw window (WM_PAINT)
;Message processing cycle
MSG_LOOP:
	push 0
	push 0
	push 0
	push OFFSET MSG
	call GetMessageA@16
	CMP EAX, 0
	JE END_LOOP
	push OFFSET MSG
	call TranslateMessage@4
	push OFFSET MSG
	call DispatchMessageA@4
	JMP MSG_LOOP
;!Message processing cycle

END_LOOP:
	push [MSG.MSWPARAM]
	call ExitProcess@4

_ERR:
	jmp END_LOOP


GETPROCESSLIST PROC

	push 0
	push TH32CS_SNAPPROCESS
	call CreateToolhelp32Snapshot@8

	mov PROCH, eax

	.if PROCH == -1
		PUSH MB_ICONERROR
		PUSH OFFSET CAP
		PUSH OFFSET ERROR_SNAP
		PUSH DWORD PTR [ebp + 08H] ;ДЕСКРИПТОР ОКНА
		CALL MessageBoxA@16
	.endif

	mov PROCDATA.dwSize, sizeof PROCESSENTRY32W

	push offset PROCDATA
	push PROCH
	call Process32FirstW@8

	.if eax == 0
		PUSH MB_ICONERROR
		PUSH OFFSET CAP
		PUSH OFFSET ERROR_SNAP
		PUSH DWORD PTR [ebp + 08H] ;ДЕСКРИПТОР ОКНА
		CALL MessageBoxA@16
	.endif

	; .repeat

	; 	call SendMessage@16
	; .until ()

	;mov eax, 0
	ret 0
GETPROCESSLIST ENDP

;WNDPROC Function
;Location pf parameters on the stack
;[EBP+014H] LPARAM
;[EBP+10H] WAPARAM
;[EBP+0CH] MES
;[EBP+8] HWND

WNDPROC PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	cmp DWORD PTR [ebp + 0CH], WM_DESTROY
	je WMDESTROY
	cmp DWORD PTR [ebp + 0CH], WM_CREATE
	je WMCREATE

	jmp DEFWNDPROC

WMCREATE:
	
	mov icex.dwSize, sizeof INITCOMMONCONTROL
	mov icex.dwICC, ICC_TAB_CLASSES
	
	push OFFSET [icex]
	call InitCommonControlsEx@4

	push 0
	push 0
	push 0
	push DWORD PTR [ebp + 08]
	push 60		;Window height
	push 60		;Window width
	push 10		;Left upper coordinate
	push 10		;Right upper coordinate
	push WS_CHILD or WS_VISIBLE
	push 0
	push OFFSET WC_TABCONTROLW
	push 0
	call CreateWindowExW@48

	mov TAB, eax

	mov tie._mask, TCIF_TEXT
	mov tie.pszText, OFFSET FIRSTTABNAME

	push 0
	push 0
	push TCM_GETITEMCOUNT
	push [TAB]

	call SendMessageW@16

	push OFFSET tie
	push 1
	push TCM_INSERTITEMW
	push [TAB]

	call SendMessageW@16


	;Create list box (with processes)
	; push 0
	; push 0
	; push 0
	; push DWORD PTR [ebp + 08]
	; push 50		;Window height
	; push 50		;Window width
	; push 10		;Left upper coordinate
	; push 10		;Right upper coordinate
	; push WS_CHILD or WS_VISIBLE or LBS_STANDARD or LBS_WANTKEYBOARDINPUT
	; push 0					 ;Class name
	; push OFFSET TITLELISTBOX ;Window name
	; push WS_EX_CLIENTEDGE
	; call CreateWindowExA@48

	; mov LISTBOXPROCESSES, eax


	push SW_SHOWNORMAL
	push [LISTBOXPROCESSES]
	call ShowWindow@8 ;Show window

	call GETPROCESSLIST
	mov eax, 0
	jmp FINISH
DEFWNDPROC:
	push DWORD PTR [EBP + 14H]
	push DWORD PTR [EBP + 10H]
	push DWORD PTR [EBP + 0CH]
	push DWORD PTR [EBP + 08H]
	call DefWindowProcA@16
	JMP FINISH
WMDESTROY:
	push 0
	call PostQuitMessage@4
	mov eax, 0
FINISH:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret 16
WNDPROC ENDP
;!WNDPROC Function

_text ends
end START
;!Code segmant