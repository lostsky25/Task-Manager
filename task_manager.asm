.386p
.model flat, stdcall

;Library Linker Directives
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\msvcrt.lib
includelib C:\masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\comctl32.lib
; includelib \masm32\lib\masm32.lib

include \masm32\include\gdi32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\user32.inc
; include \masm32\include\comctl32.inc
include \masm32\include\kernel32.inc

include resources.inc

;Data segment
_data segment dword public use32 'data'
	; BUF byte	1024 DUP(0)
	NEWHWND					dd					0
	LISTBOXPROCESSES		dd 					0
	LISTBOXMODULES	 		dd 					0
	BTNKILLPROC				dd 					0
	BTNPAUSEPROC			dd 					0
	BTNRESUMEPROC			dd 					0
	TAB	 					dd 					0
	DWTEMP					dd 					0
	HINST					dd					0
	hSnapshot				dd 					?
	mSnapshot				dd 					?
	processHandle			dd					?
	pfnNtSuspendProcess 	dd					?
	hProcess 				dd					?
	procTemplateBuf 		db					"%S %d",0
	
	;String of errors
	_errMessage				db					"Error message",0
	_errProcOpen	 		db					"Error: 101",0
	_errModulLoad			db					"Error: 102",0
	_errFuncFromDll			db					"Error: 103",0
	_errNoneChooseProc		db					"Error: 104",0
	_errPermisions			db					"Error: 105",0
	_errProcTerm			db 					"Error: 106",0
	_errProcList			db					"Error: 107",0
	_errFirstGetModul		db					"Error: 108",0
	_errGetModuleHandle 	db					"Error: 109",0
	_errDrawPlot		 	db					"Error: 110",0
	;!String of errors

	;Paint
	delta 					dword				30
	hdc						dd					?
	colorFrame				dword				?
	pen						dword				?
	; renderState				byte				0
	plotThreadId			dword				0
	plotArea				RECT				<30, 60, 480, 180>
	; ps						PAINTSTRUCT			<?>
	;!Paint

	NtSuspendProcessAStr 	db 					"NtSuspendProcess",0
	NtResumeProcessAStr 	db 					"NtResumeProcess",0
	NtModuleNameWStr		dw					"n","t","d","l","l",0

	modulTemplateBuf 		db					"ba: 0x%08X, bs: 0x%08X, %S", 0

	procInfoTemplate 		db					"%s %s",0
	procName 				db					?
	procInfoStr		 		db					?
	procPidStr				db					?
	procBuf 				db 					MAX_PATH dup(?)	
	modulBuf 				db 					MAX_PATH dup(?)
	TITLENAME				db					'Task Manager', 0
	WC_BUTTONW				db					'Button', 0
	TITLELISTBOX			db					'ListBox', 0
	CLASSNAME				db					'CLASS32', 0
	CAP		    			db					'Message', 0
	NOPROCMSG    			db					'You should chose some process', 0
	FIRSTTABNAME	    	dw					"P","r","o","c","e","s","s","e","s", 0
	SECONDTABNAME	    	dw					"M","o","d","u","l","e","s", 0
	THIRDTABNAME			dw      			"P","e","r","f","o","m","e","n","c","e",0
	BTNKILLPROCNAME	    	db					"Kill",0
	BTNPAUSEPROCNAME    	db      			"Pause",0
	BTNRESUMEPROCNAME   	db      			"Resume",0
	WC_TABCONTROLW			db					'SysTabControl32', 0
	ERROR_SNAP				db					'Errot get snapshot', 0
	MSG						MSGSTRUCT 		  	<?>
	WC						WNDCLASS		  	<?>
	PROCDATA 				PROCESSENTRY32    	<>
	MODULDATA				MODULEENTRY32	  	<>
	tie     				TCC_ITEM 		  	<> 
	icex    				INITCOMMONCONTROL 	<>
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
	mov eax, [HINST]
	mov [WC.CLSHISTANCE], eax

;Icon
	push IDI_APPLICATION
	push 0
	call LoadIconA@8
	mov [WC.CLSHICON], eax

;Cursor
	push IDC_CROSS
	push 0
	call LoadCursorA@8
	mov [WC.CLSHCURSOR], eax

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
	push 400					;Window height
	push 600					;Window width
	push 100					;Left upper coordinate
	push 100					;Right upper coordinate
	push WS_OVERLAPPEDWINDOW
	push OFFSET TITLENAME 		;Window name
	push OFFSET CLASSNAME 		;Class name
	push 0
	call CreateWindowExA@48

;Check error
	cmp eax, 0
	jz _ERR
	mov [NEWHWND], eax 			;Window handle

	push SW_SHOWNORMAL
	push [NEWHWND]
	call ShowWindow@8 			;Show window

;----------------------------------------------

	push [NEWHWND]
	call UpdateWindow@4 		;Redraw window (WM_PAINT)
;Message processing cycle
MSG_LOOP:
	push 0
	push 0
	push 0
	push OFFSET MSG
	call GetMessageA@16
	cmp eax, 0
	je END_LOOP
	push OFFSET MSG
	call TranslateMessage@4
	push OFFSET MSG
	call DispatchMessageA@4
	jmp MSG_LOOP
;!Message processing cycle

END_LOOP:
	push [MSG.MSWPARAM]
	call ExitProcess@4

_ERR:
	jmp END_LOOP

createFrame proc left:dword, top:dword, right:dword, bottom:dword
	; <30, 60, 480, 180>
	;Frame
	;Top
	push 0
	push top
	push left
	push hdc
	call MoveToEx@16

	push top
	push right
	push hdc
	call LineTo@12
	;!Top

	;Right
	push 0
	push top
	push right
	push hdc
	call MoveToEx@16

	push bottom
	push right
	push hdc
	call LineTo@12
	;!Right

	;Bottom
	push 0
	push bottom
	push right
	push hdc
	call MoveToEx@16

	push bottom
	push left
	push hdc
	call LineTo@12
	;!Buttom

	;Left
	push 0
	push bottom
	push left
	push hdc
	call MoveToEx@16

	sub top, 1

	push top
	push left
	push hdc
	call LineTo@12
	;!Left
	
	;!Frame
	ret
createFrame endp

;Draw plot
plot proc
	mov delta, 30

	push [TAB]
	call GetDC@4 ;Why can't I use BeginPaint?

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errDrawPlot
		push 0
		call MessageBoxA@16

		push 110
		call PostQuitMessage@4
		mov eax, 0
	.endif

	mov hdc, eax

	push 0
	push 2
	push 0
	call CreatePen@12

	mov pen, eax

	push pen
	push hdc
	call SelectObject@8

	; push plotArea.bottom
	; push plotArea.right
	; push plotArea.top
	; push plotArea.left
	; push hdc
	; call Rectangle@20

	.while 1

		push 0
		push 90
		push delta
		push hdc
		call MoveToEx@16

		push 90
		push delta
		push hdc
		call LineTo@12

		push 180
		push 480
		push 60
		push 30
		call createFrame
		

		.if delta > 479
			
			
			; push RDW_INVALIDATE
			; push 0
			; push offset plotArea
			; ; push DWORD PTR [ebp + 08H]
			; push [TAB]
			; call RedrawWindow@16

			; push RDW_INVALIDATE
			; push 0
			; push offset plotArea
			; push DWORD PTR [ebp + 08H]
			; ; push [TAB]
			; call RedrawWindow@16

			push 0
			push 0
			push DWORD PTR [ebp + 08H]
			call InvalidateRect@12

			; push hdc
			; push DWORD PTR [ebp + 08H]
			; call ReleaseDC@8

			; push hdc
			; call DeleteDC@4

			; push [TAB]
			; call UpdateWindow@4
			
				
			; push DWORD PTR [ebp + 08H]
			; call UpdateWindow@4
			
			mov delta, 30
		.endif
		
		push DWORD PTR [ebp + 08H]
		call UpdateWindow@4

		
		push [TAB]
		call UpdateWindow@4
		
		add delta, 1

		push 20
		call Sleep@4
	.endw



	; push offset ps
	; push [TAB]
	; call EndPaint@8

	ret 0
plot endp
;!Draw plot

;Process resume
resumeProc proc pid:dword

	push pid
	push 0
	push PROCESS_ALL_ACCESS
	call OpenProcess@12	

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errProcOpen
		push 0
		call MessageBoxA@16

		push 101
		call PostQuitMessage@4
		mov eax, 0
	.endif

	mov processHandle, eax

	push offset NtModuleNameWStr
	call GetModuleHandleW@4

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errGetModuleHandle
		push 0
		call MessageBoxA@16
		
		push 109
		call PostQuitMessage@4
		mov eax, 0
	.endif

	push offset NtResumeProcessAStr
	push eax
	call GetProcAddress@8

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errFuncFromDll
		push 0
		call MessageBoxA@16

		push 103
		call PostQuitMessage@4
		mov eax, 0	
	.endif

	push processHandle
	call eax

	push processHandle
	call CloseHandle@4
	
	ret
resumeProc endp

;Process pause
pauseProc proc pid:dword

	push pid
	push 0
	push PROCESS_ALL_ACCESS
	call OpenProcess@12

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errProcOpen
		push 0
		call MessageBoxA@16

		push 101
		call PostQuitMessage@4
		mov eax, 0
	.endif

	mov processHandle, eax

	push offset NtModuleNameWStr
	call GetModuleHandleW@4

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errGetModuleHandle
		push 0
		call MessageBoxA@16

		push 109
		call PostQuitMessage@4
		mov eax, 0
	.endif

	push offset NtSuspendProcessAStr
	push eax
	call GetProcAddress@8

	.if eax == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errFuncFromDll
		push 0
		call MessageBoxA@16

		push 103
		call PostQuitMessage@4
		mov eax, 0
	.endif

	push processHandle
	call eax

	push processHandle
	call CloseHandle@4

	ret
pauseProc endp

getCurrentProc proc
	push 0
	push 0
	push LB_GETCURSEL
	push [LISTBOXPROCESSES]
	call SendMessageA@16

	;eax index of selected element

	.if eax != 0FFFFFFFFh
		push 0
		push 0
		push LB_GETCURSEL
		push [LISTBOXPROCESSES]
		call SendMessageA@16

		push offset procInfoStr
		push eax
		push LB_GETTEXT
		push [LISTBOXPROCESSES]
		call SendMessageA@16
		
		invoke crt_sscanf, offset procInfoStr, offset procInfoTemplate, offset procName, offset procPidStr

		invoke crt_atoi, offset procPidStr
		
	.else
		push MB_ICONERROR
		push offset _errMessage
		push offset _errNoneChooseProc
		push 0
		call MessageBoxA@16

		push 104
		call PostQuitMessage@4
		mov eax, 0
	.endif

	ret
getCurrentProc endp

;Process kill
killProc proc pid:dword

	push pid
	push 0
	push PROCESS_TERMINATE
	call OpenProcess@12

	mov hProcess, eax

	.if hProcess != 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errProcOpen
		push 0
		call MessageBoxA@16

		push 101
		call PostQuitMessage@4
		mov eax, 0
	.endif

	push 9
	push hProcess
	call TerminateProcess@8

	.if ecx != 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errProcTerm
		push 0
		call MessageBoxA@16

		push 106
		call PostQuitMessage@4
		mov eax, 0
	.endif

	push hProcess
	call CloseHandle@4

	ret
killProc endp

;For certain process
updateModuleSnapshot proc
	push PROCDATA.th32ProcessID
	push TH32CS_SNAPMODULE
	call CreateToolhelp32Snapshot@8

	mov mSnapshot, eax
	
	;Problem with EAX value
	; .if mSnapshot == -1
	; 	push MB_ICONERROR
	; 	push offset _errMessage
	; 	push offset _errProcList
	; 	push 0
	; 	call MessageBoxA@16
	; .endif

	ret
updateModuleSnapshot endp

updateModuleList proc
	mov MODULDATA.dwSize, sizeof MODULEENTRY32

	push offset MODULDATA
	push mSnapshot
	call Module32FirstW@8

	.if ecx == 0
		push MB_ICONERROR
		push offset _errMessage
		push offset _errFirstGetModul
		push 0
		call MessageBoxA@16

		push 108
		call PostQuitMessage@4
		mov eax, 0
	.endif

	.repeat
		invoke wsprintfA, offset modulBuf, offset modulTemplateBuf, MODULDATA.modBaseAddr, MODULDATA.modBaseSize, offset MODULDATA.szModule

		push offset modulBuf
		push 0
		push LB_ADDSTRING
		push [LISTBOXMODULES]

		call SendMessageA@16

		push offset MODULDATA
		push mSnapshot
		call Module32NextW@8

	.until ecx >= 0

	ret
updateModuleList endp

updateProcessList proc
	push 0
	push 0
	push LB_RESETCONTENT
	push [LISTBOXPROCESSES]
	call SendMessageA@16

	push 0
	push TH32CS_SNAPPROCESS
	call CreateToolhelp32Snapshot@8

	mov hSnapshot, eax

	;Problem with EAX value
	; .if hSnapshot == -1
	; 	push MB_ICONERROR
	; 	push offset _errMessage
	; 	push offset _errProcList
	; 	push 0
	; 	call MessageBoxA@16
	; .endif

	mov PROCDATA.dwSize, sizeof PROCESSENTRY32

	push offset PROCDATA
	push hSnapshot
	call Process32FirstW@8

	call updateModuleSnapshot

	.while eax != 0

		push PROCDATA.th32ProcessID
		push TH32CS_SNAPMODULE
		call CreateToolhelp32Snapshot@8

		mov mSnapshot, eax
		
		;Problem with EAX value
		; .if mSnapshot == -1
		; 	push MB_ICONERROR
		; 	push offset _errMessage
		; 	push offset _errProcList
		; 	push 0
		; 	call MessageBoxA@16
		; .endif

		invoke wsprintfA, offset procBuf, offset procTemplateBuf, offset PROCDATA.szExeFile, PROCDATA.th32ProcessID

		push offset procBuf
		push 0
		push LB_ADDSTRING
		push [LISTBOXPROCESSES]
		call SendMessageA@16

		call updateModuleList

		push OFFSET PROCDATA
		push hSnapshot
		call Process32NextW@8
	.endw

	push hSnapshot
	call CloseHandle@4
	
	push mSnapshot
	call CloseHandle@4

	ret 0
updateProcessList endp

;WNDPROC Function
;Location pf parameters on the stack
;[EBP+014H] LPARAM
;[EBP+10H] WAPARAM
;[EBP+0CH] MES
;[EBP+8] HWND

WNDPROC proc
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	cmp DWORD PTR [ebp + 0CH], WM_DESTROY
	je WMDESTROY
	cmp DWORD PTR [ebp + 0CH], WM_CREATE
	je WMCREATE
	cmp DWORD PTR [ebp + 0CH], WM_NOTIFY
	je WMNOTIFY
	cmp DWORD PTR [ebp + 0CH], WM_PAINT
	je WMPAINT
	cmp DWORD PTR [ebp + 0CH], WM_COMMAND
	je WMCOMMAND
	cmp DWORD PTR [ebp + 0CH], WM_ACTIVATEAPP
	je WMACTIVATEAPP

	jmp DEFWNDPROC

WMCREATE:
	
	mov icex.dwSize, sizeof INITCOMMONCONTROL
	mov icex.dwICC, ICC_TAB_CLASSES
	
	push OFFSET [ICEX]
	call InitCommonControlsEx@4

	push 0
	push 0
	push ID_TABCTRL
	push DWORD PTR [ebp + 08H]
	push 400					;Window height
	push 600					;Window width
	push 0						;Left upper coordinate
	push 0						;Right upper coordinate
	push WS_CHILD or WS_VISIBLE
	push 0
	push OFFSET WC_TABCONTROLW
	push WS_EX_CLIENTEDGE
	call CreateWindowExA@48

	mov TAB, eax

	;First tab
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
	;!First tab

	;Second tab
	mov tie._mask, TCIF_TEXT
	mov tie.pszText, OFFSET SECONDTABNAME

	push 0
	push 0
	push TCM_GETITEMCOUNT
	push [TAB]

	call SendMessageW@16

	push OFFSET tie
	push 2
	push TCM_INSERTITEMW
	push [TAB]

	call SendMessageW@16
	;!Second tab

	;Thrird tab
	mov tie._mask, TCIF_TEXT
	mov tie.pszText, OFFSET THIRDTABNAME

	push 0
	push 0
	push TCM_GETITEMCOUNT
	push [TAB]

	call SendMessageW@16

	push OFFSET tie
	push 3
	push TCM_INSERTITEMW
	push [TAB]

	call SendMessageW@16
	;!Thrird tab

	;Create list box (with processes)
	push 0
	push 0
	push ID_LIST_PROC
	push [TAB]  				;Is it need?
	push 300					;Window height
	push 570					;Window width
	push 30						;Left upper coordinate
	push 5						;Right upper coordinate
	push WS_CHILD or WS_VISIBLE or LBS_STANDARD or LBS_WANTKEYBOARDINPUT
	push 0					 	;Class name
	push OFFSET TITLELISTBOX 	;Window name
	push WS_EX_CLIENTEDGE
	call CreateWindowExA@48

	mov LISTBOXPROCESSES, eax

	push SW_SHOWNORMAL
	push [LISTBOXPROCESSES]
	call ShowWindow@8 			;Show window
	;!Create list box (with processes)

	;Create list box (with modules)
	push 0
	push 0
	push ID_LIST_MODUL
	push [TAB]  				;Is it need?
	push 300					;Window height
	push 570					;Window width
	push 30					;Left upper coordinate
	push 1200					;Right upper coordinate
	push WS_CHILD or WS_VISIBLE or LBS_STANDARD or LBS_WANTKEYBOARDINPUT
	push 0					 	;Class name
	push OFFSET TITLELISTBOX 	;Window name
	push WS_EX_CLIENTEDGE
	call CreateWindowExA@48

	mov LISTBOXMODULES, eax

	push SW_SHOWNORMAL
	push [LISTBOXMODULES]
	call ShowWindow@8 			;Show window
	;!Create list box (with modules)

	;Create button (kill proc)
	push 0
	push 0
	push ID_BTN_KILL_PROC
	push DWORD PTR [ebp + 08H]
	push 20						;Window height
	push 60						;Window width
	push 335					;Left upper coordinate
	push 520					;Right upper coordinate
	push WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
	push OFFSET BTNKILLPROCNAME ;Name btn
	push OFFSET WC_BUTTONW 		;Window name
	push 0					 
	call CreateWindowExA@48

	mov BTNKILLPROC, eax

	push SW_SHOWNORMAL
	push [BTNKILLPROC]
	call ShowWindow@8 			;Show window
	;!Create button (kill proc)

	;Create button (pause proc)
	push 0
	push 0
	push ID_BTN_PAUSE_PROC
	push DWORD PTR [ebp + 08H]
	push 20						;Window height
	push 60						;Window width
	push 335					;Left upper coordinate
	push 455					;Right upper coordinate
	push WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
	push OFFSET BTNPAUSEPROCNAME ;Name btn
	push OFFSET WC_BUTTONW 		;Window name
	push 0					 
	call CreateWindowExA@48

	mov BTNPAUSEPROC, eax

	push SW_SHOWNORMAL
	push [BTNPAUSEPROC]
	call ShowWindow@8 			;Show window
	;!Create button (pause proc)

	;Create button (pause proc)
	push 0
	push 0
	push ID_BTN_RESUME_PROC
	push DWORD PTR [ebp + 08H]
	push 20						;Window height
	push 60						;Window width
	push 335					;Left upper coordinate
	push 390					;Right upper coordinate
	push WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
	push OFFSET BTNRESUMEPROCNAME ;Name btn
	push OFFSET WC_BUTTONW 		;Window name
	push 0					 
	call CreateWindowExA@48

	mov BTNRESUMEPROC, eax

	push SW_SHOWNORMAL
	push [BTNRESUMEPROC]
	call ShowWindow@8 			;Show window
	;!Create button (pause proc)

	call updateProcessList

	mov eax, 0
	jmp FINISH

WMPAINT:
	; invoke CreateThread, 0, 0, offset plot, 0, CREATE_SUSPENDED, 0
	; mov plotThreadId, eax

WMNOTIFY:
	cmp DWORD PTR [ebp + 10H], ID_TABCTRL
	je IDTABCTRL

WMCOMMAND:
	cmp DWORD PTR [ebp + 10H], ID_BTN_KILL_PROC
	je IDBTNKILLPROC
	cmp DWORD PTR [ebp + 10H], ID_BTN_PAUSE_PROC
	je IDBTNPAUSEPROC
	cmp DWORD PTR [ebp + 10H], ID_BTN_RESUME_PROC
	je IDBTNRESUMEPROC
	
WMACTIVATEAPP:
	; call updateProcessList
	; invoke CreateThread, 0, 0, offset updateProcessList, 0, 0, 0
	jmp FINISH ;It need here?

IDBTNRESUMEPROC:
	call getCurrentProc
	
	push eax
	call resumeProc

	jmp FINISH

IDBTNPAUSEPROC:

	call getCurrentProc
	
	push eax
	call pauseProc

	jmp FINISH

IDBTNKILLPROC:

	call getCurrentProc
	
	push eax
	call killProc
	
	jmp FINISH

IDTABCTRL:
	push 0
	push 0
	push TCM_GETCURFOCUS
	push [TAB]
	call SendMessageA@16

	.if eax == 0
		; call updateProcessList

		; mov renderState, 0

		.if plotThreadId != 0
			push 0
			push plotThreadId
			call TerminateThread@8
			mov plotThreadId, eax
		.endif

		push 1
		push 300
		push 570
		push 30
		push 5	
		push LISTBOXPROCESSES
		call MoveWindow@24

		push 1
		push 300
		push 570
		push 30
		push 1200
		push LISTBOXMODULES
		call MoveWindow@24

		push [TAB]
		call UpdateWindow@4

	.elseif eax == 1
		; call updateProcessList
		
		; mov renderState, 0

		.if plotThreadId != 0
			push 0
			push plotThreadId
			call TerminateThread@8
			mov plotThreadId, eax
		.endif

		push 1
		push 300
		push 570
		push 30
		push 5	
		push LISTBOXMODULES
		call MoveWindow@24

		push 1
		push 300
		push 570
		push 30
		push 1200
		push LISTBOXPROCESSES
		call MoveWindow@24

		push [TAB]
		call UpdateWindow@4
	.elseif eax == 2
		; call updateProcessList
		; mov renderState, 1

		; invoke _beginthreadex, 0, 0, offset plot, 0, 0, 0

		; push plotThreadId
		; call ResumeThread@4

		.if plotThreadId == 0
			invoke CreateThread, 0, 0, offset plot, 0, 0, 0
			mov plotThreadId, eax
		.endif

		push 1
		push 300
		push 570
		push 30
		push 1800
		push LISTBOXMODULES
		call MoveWindow@24

		push 1
		push 300
		push 570
		push 30
		push 1200
		push LISTBOXPROCESSES
		call MoveWindow@24

		push [TAB]
		call UpdateWindow@4
	.endif

DEFWNDPROC:
	push DWORD PTR [ebp + 14H]
	push DWORD PTR [ebp + 10H]
	push DWORD PTR [ebp + 0CH]
	push DWORD PTR [ebp + 08H]
	call DefWindowProcA@16
	jmp FINISH
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