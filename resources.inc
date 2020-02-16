WM_NOTIFY			    equ 78

;Closing a window
WM_DESTROY			    equ 2

;Create a window
WM_CREATE			    equ 1

;Command a window
WM_COMMAND              equ 0111h

;For paint
WM_PAINT                equ 000Fh
RDW_INVALIDATE          equ 0001h

;Error icon
MB_ICONERROR		    equ 00000010h

;Active window
WM_ACTIVATEAPP          equ 001Ch

MAX_PATH			    equ 260

BS_PUSHBUTTON           equ 00000000h
LB_RESETCONTENT         equ 0184h
LB_ADDSTRING            equ	0180h
LB_RESETCONTENT         equ 0184h

CREATE_SUSPENDED        equ 00000004h

PROCESS_TERMINATE       equ 0001h
PROCESS_QUERY_INFORMATION   equ 0400h
LB_GETCURSEL            equ 0188h
LB_GETTEXT              equ 0189h

STANDARD_RIGHTS_REQUIRED equ 000F0000h
SYNCHRONIZE              equ 00100000h
PROCESS_ALL_ACCESS      equ (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or 0FFFFh)

PROCESS_VM_READ         equ 0010h  
PROCESS_VM_WRITE        equ 0020h  

;IDS
ID_LIST_PROC		    equ 00000020h
ID_LIST_MODUL 		    equ 00000021h
ID_BTN_KILL_PROC 	    equ 00000022h
ID_TABCTRL 			    equ 00000023h
ID_BTN_PAUSE_PROC 	    equ 00000024h
ID_BTN_RESUME_PROC 	    equ 00000025h

WS_CHILD 			    equ 40000000h
WS_VISIBLE              equ 10000000h
LBS_NOTIFY         	    equ 0001h
LBS_SORT                equ 0002h
WS_VSCROLL              equ 00200000h
WS_BORDER               equ 00800000h
LBS_WANTKEYBOARDINPUT   equ 0400h
LBS_STANDARD            equ (LBS_NOTIFY or LBS_SORT or WS_VSCROLL or WS_BORDER)

ICC_TAB_CLASSES         equ 00000008h ;tab, tooltips
TCIF_TEXT               equ	0001h ;text
TCM_FIRST			    equ 1300h
TCM_GETCURFOCUS 	    equ (TCM_FIRST + 47)
TCM_GETITEMCOUNT        equ (TCM_FIRST + 4)
TCM_INSERTITEMW         equ (TCM_FIRST + 62)

;Window propertirs
CS_VREDRAW			    equ 1h
CS_HREDRAW			    equ 2h
CS_GLOBALCLASS 		    equ 4000h
WS_OVERLAPPEDWINDOW     equ 000CF0000h
STYLE_WINDOW 		    equ CS_HREDRAW+CS_VREDRAW+CS_GLOBALCLASS

;Programm icon
IDI_APPLICATION		    equ 32512

WS_EX_CLIENTEDGE	    equ 00000200h

;Cursor id
IDC_CROSS			    equ 32515

MAX_MODULE_NAME32 	    equ 255

;Window mode
SW_SHOWNORMAL		    equ 1

;For processes
TH32CS_SNAPPROCESS      equ 00000002h

;For modules
TH32CS_SNAPMODULE       equ 00000008h

;Message structure
MSGSTRUCT struct
	MSHWND				dd	?			;Window id
	MSMESSAGE			dd 	?			;Message id
	MSWPARAM			dd	?			;Additional message information
	MSLPARAM			dd	?			;Additional message information
	MSTIME				dd	?			;Post time
	MSPT				dd	?			;Cursor position
MSGSTRUCT ends
;!Message structure

;Window structure
WNDCLASS struct
	CLSSTYLE			dd	?			;Window style
	CLWNDPROC			dd	?			;Window procedure pointer
	CLSCEXTRA			dd	? 			;Additional byte information for this structure
	CLWNDEXTRA			dd	? 			;Additional byte information for window
	CLSHISTANCE			dd	?			;Window HINST
	CLSHICON			dd	?			;Icon id
	CLSHCURSOR			dd	?			;Cursor id
	CLBKGROUND			dd	?			;Brush id
	CLMENUNAME			dd	?			;Name id
	CLNAME				dd	?			;Specifies a window class name
WNDCLASS ends
;!Window structure

;Tabs structure
TCC_ITEM struct
	_mask 				dd 	?
    dwState 			dd 	?
    dwStateMask 		dd 	?
    pszText 			dd 	?
    cchTextMax 			dd 	?
    iImage 				dd 	?
TCC_ITEM ends
;!Tabs structure

;Initcommoncontrol structure
INITCOMMONCONTROL struct
    dwICC 				dd 	? 
    dwSize 				dd 	?
INITCOMMONCONTROL ends
;!Initcommoncontrol structure

;For paint area
; PAINTSTRUCT struct
;     hdc                dword ?
;     fErase             dword ?
;     rcPaint            dword ?
;     fRestore           dword ?
;     fIncUpdate         dword ?
;     rgbReserved        dw 32 dup(?)
; PAINTSTRUCT ends

RECT struct
    left               dword ?
    top                dword ?
    right              dword ?
    bottom             dword ?
RECT ends
;!For paint area

;Structure for processes
PROCESSENTRY32 struct
    dwSize              dword ?
    cntUsage            dword ?
    th32ProcessID       dword ?
    th32DefaultHeapID   dword ?
    th32ModuleID        dword ?
    cntThreads          dword ?
    th32ParentProcessID dword ?
    pcPriClassBase      dword ?
    dwFlags             dword ?
    szExeFile           dw MAX_PATH dup(?)
PROCESSENTRY32 ends
;!Structure for processes

;Structure for modules
MODULEENTRY32 struct
    dwSize              dword ?
    th32ModuleID        dword ?
    th32ProcessID       dword ?
    GlblcntUsage        dword ?
    ProccntUsage        dword ?
    modBaseAddr         dword ?
    modBaseSize         dword ?
    hModule             dword ?
    szModule            dw MAX_MODULE_NAME32+1 dup(?)
    szExePath           dw MAX_PATH dup(?)
MODULEENTRY32 ends
;!Structure for modules

;Prototypes of external procedures
extern MessageBoxA@16:NEAR
extern MessageBoxW@16:NEAR
extern CreateWindowExA@48:NEAR
extern CreateWindowExW@48:NEAR
extern DefWindowProcA@16:NEAR
extern DispatchMessageA@4:NEAR
extern ExitProcess@4:NEAR
extern GetMessageA@16:NEAR
extern OpenProcess@12:NEAR

extern _imp__GetModuleHandleW@4:NEAR
extern _imp__GetProcAddress@8:NEAR
; extern _imp__GetModuleHandleA@4:NEAR
extern GetModuleHandleA@4:NEAR
extern GetModuleHandleW@4:NEAR

;Plot
extern BeginPaint@8:NEAR
extern CreatePen@12:NEAR
extern SelectObject@8:NEAR
extern Rectangle@20:NEAR
extern GetDC@4:NEAR
extern MoveToEx@16:NEAR
extern LineTo@12:NEAR
extern EndPaint@8:NEAR
extern RedrawWindow@16:NEAR
extern InvalidateRect@12:NEAR
extern ReleaseDC@8:NEAR
extern DeleteDC@4:NEAR
extern Sleep@4:NEAR
;!Plot

; extern _beginthreadex@14:NEAR
extern SuspendThread@4:NEAR
extern ResumeThread@4:NEAR
extern ExitThread@4:NEAR
extern TerminateThread@8:NEAR
extern CreateThread@24:NEAR
extern GetProcAddress@8:NEAR
extern GetModuleHandleA@4:NEAR
extern LoadCursorA@8:NEAR
extern LoadIconA@8:NEAR
extern PostQuitMessage@4:NEAR
extern RegisterClassA@4:NEAR
extern ShowWindow@8:NEAR
extern TranslateMessage@4:NEAR
extern UpdateWindow@4:NEAR
extern CreateToolhelp32Snapshot@8:NEAR
extern Process32FirstW@8:NEAR
extern SendMessageW@16:NEAR
extern SendMessageA@16:NEAR
extern InitCommonControlsEx@4:NEAR
extern SendMessageW@16:NEAR
extern Process32NextW@8:NEAR
extern OpenProcess@12:NEAR
extern TerminateProcess@8:NEAR
extern CloseHandle@4:NEAR
extern MoveWindow@24:NEAR
extern UpdateWindow@4:NEAR
extern Module32FirstW@8:NEAR
extern Module32NextW@8:NEAR
extern GetLastError@0:NEAR
;!Prototypes of external procedures